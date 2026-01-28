import { z } from "zod";
import Perplexity from "@perplexity-ai/perplexity_ai";
import { MODELS, env, responseCache, calculateCost, logCost, getCacheKey, } from "./shared.js";
const perplexityClient = new Perplexity({
    apiKey: env.PERPLEXITY_API_KEY,
    maxRetries: 3,
    timeout: 30_000,
    logLevel: process.env["PERPLEXITY_LOG"] ?? "warn",
});
async function callPerplexitySearch(query, options) {
    if (!env.PERPLEXITY_API_KEY) {
        throw new Error("PERPLEXITY_API_KEY environment variable not set");
    }
    try {
        const response = await perplexityClient.search.create({
            query,
            max_results: options?.maxResults ?? 10,
            search_domain_filter: options?.searchDomainFilter,
            search_recency_filter: options?.searchRecencyFilter,
            search_after_date_filter: options?.searchAfterDateFilter,
            search_before_date_filter: options?.searchBeforeDateFilter,
            search_mode: options?.searchMode,
        });
        return {
            results: response.results.map((r) => ({
                title: r.title,
                url: r.url,
                snippet: r.snippet,
                date: r.date ?? r.last_updated ?? undefined,
            })),
        };
    }
    catch (err) {
        if (err instanceof Perplexity.APIError) {
            console.error(`[PERPLEXITY SEARCH ERROR] ${err.name} (${err.status}):`, err.headers);
            throw new Error(`Perplexity search failed: ${err.name}`);
        }
        throw err;
    }
}
async function callPerplexity(query, model, systemPrompt, attachments) {
    if (!env.PERPLEXITY_API_KEY) {
        throw new Error("PERPLEXITY_API_KEY environment variable not set");
    }
    const messages = [];
    if (systemPrompt) {
        messages.push({ role: "system", content: systemPrompt });
    }
    const content = [{ type: "text", text: query }];
    if (attachments && attachments.length > 0) {
        for (const att of attachments) {
            const url = att.data.startsWith("http")
                ? att.data
                : `data:${att.mimeType};base64,${att.data}`;
            if (att.type === "image") {
                content.push({ type: "image_url", image_url: { url } });
            }
            else if (att.type === "document") {
                if (att.mimeType === "application/pdf") {
                    content.push({ type: "pdf_url", pdf_url: { url } });
                }
                else {
                    content.push({ type: "file_url", file_url: { url } });
                }
            }
        }
    }
    messages.push({
        role: "user",
        content: content,
    });
    try {
        const response = await perplexityClient.chat.completions.create({
            model,
            messages,
        });
        const message = response.choices[0]?.message;
        let contentText = "";
        if (typeof message?.content === "string") {
            contentText = message.content;
        }
        else if (Array.isArray(message?.content)) {
            contentText = message.content
                .map((c) => {
                if ("text" in c)
                    return c.text;
                return "";
            })
                .join("");
        }
        else {
            contentText = "No response from Perplexity";
        }
        const usage = response.usage ?? {
            prompt_tokens: query.length,
            completion_tokens: contentText.length,
        };
        return {
            response: contentText,
            usage: {
                inputTokens: usage.prompt_tokens ?? 0,
                outputTokens: usage.completion_tokens ?? 0,
            },
        };
    }
    catch (err) {
        if (err instanceof Perplexity.APIError) {
            console.error(`[PERPLEXITY CHAT ERROR] ${err.name} (${err.status}):`, err.headers);
            throw new Error(`Perplexity chat failed: ${err.name}`);
        }
        throw err;
    }
}
export function registerPerplexityTools(server) {
    server.registerTool("ask_perplexity", {
        title: "Ask Perplexity",
        description: "Send a query to Perplexity AI for web-grounded answers with citations. " +
            "Use sonar-pro for advanced search, sonar-deep-research for exhaustive research reports.",
        inputSchema: {
            query: z.string().min(1).describe("The question or research query"),
            model: z
                .enum([MODELS.PERPLEXITY_SONAR_PRO, MODELS.PERPLEXITY_SONAR_DEEP])
                .default(MODELS.PERPLEXITY_SONAR_PRO)
                .describe("Perplexity model to use"),
            system_prompt: z
                .string()
                .optional()
                .describe("Optional system prompt for context"),
        },
        outputSchema: {
            answer: z.string().describe("The web-grounded answer from Perplexity"),
        },
    }, async ({ query, model, system_prompt }) => {
        const cacheKey = getCacheKey("pplx", model, system_prompt, query);
        const cached = responseCache.get(cacheKey);
        if (cached) {
            console.error("[CACHE] Hit for", cacheKey.slice(0, 50));
            return { content: [{ type: "text", text: cached.response }] };
        }
        const result = await callPerplexity(query, model, system_prompt);
        const cost = calculateCost(model, result.usage.inputTokens, result.usage.outputTokens);
        logCost(cost, false);
        responseCache.set(cacheKey, {
            response: result.response,
            timestamp: Date.now(),
        });
        return { content: [{ type: "text", text: result.response }] };
    });
    server.registerTool("search_perplexity", {
        title: "Search Perplexity",
        description: "Get ranked web search results with real-time information. " +
            "Supports multi-query search, domain filtering, date filtering, and search mode (web/academic/sec) for research.",
        inputSchema: {
            query: z
                .union([z.string(), z.array(z.string()).min(1)])
                .describe("Search query or array of queries for batch search"),
            maxResults: z
                .number()
                .min(1)
                .max(50)
                .default(10)
                .describe("Maximum number of results to return"),
            searchDomainFilter: z
                .array(z.string())
                .optional()
                .describe("Limit results to trusted domains (e.g., science.org, nature.com)"),
            searchRecencyFilter: z
                .enum(["hour", "day", "week", "month", "year"])
                .optional()
                .describe("Filter by recency"),
            searchAfterDateFilter: z
                .string()
                .optional()
                .describe("Start date filter (MM/DD/YYYY)"),
            searchBeforeDateFilter: z
                .string()
                .optional()
                .describe("End date filter (MM/DD/YYYY)"),
            searchMode: z
                .enum(["web", "academic", "sec"])
                .optional()
                .default("web")
                .describe("Search mode: web (default), academic (research papers), sec (SEC filings)"),
        },
        outputSchema: {
            results: z
                .array(z.object({
                title: z.string(),
                url: z.string(),
                snippet: z.string(),
                date: z.string().optional(),
            }))
                .describe("Ranked search results"),
        },
    }, async ({ query, maxResults, searchDomainFilter, searchRecencyFilter, searchAfterDateFilter, searchBeforeDateFilter, searchMode, }) => {
        const queryStr = Array.isArray(query) ? query.join("|") : query;
        const cacheKey = getCacheKey("pplx-search", queryStr, maxResults.toString(), searchDomainFilter?.join(","), searchRecencyFilter, searchAfterDateFilter, searchBeforeDateFilter, searchMode);
        const cached = responseCache.get(cacheKey);
        if (cached) {
            console.error("[CACHE] Hit for", cacheKey.slice(0, 50));
            return { content: [{ type: "text", text: cached.response }] };
        }
        const result = await callPerplexitySearch(query, {
            maxResults,
            searchDomainFilter,
            searchRecencyFilter,
            searchAfterDateFilter,
            searchBeforeDateFilter,
            searchMode,
        });
        const formattedResults = result.results
            .map((r, i) => `${i + 1}. [${r.title}](${r.url})\n   ${r.snippet}${r.date ? `\n   Date: ${r.date}` : ""}`)
            .join("\n\n");
        const responseText = `## Search Results\n\n${formattedResults}`;
        console.error("[SEARCH] Query completed:", {
            query: Array.isArray(query) ? query : query.slice(0, 50),
            resultCount: result.results.length,
            timestamp: Date.now(),
        });
        responseCache.set(cacheKey, {
            response: responseText,
            timestamp: Date.now(),
        });
        return {
            content: [
                {
                    type: "text",
                    text: responseText,
                },
            ],
        };
    });
    server.registerTool("ask_perplexity_with_assets", {
        title: "Ask Perplexity with Assets",
        description: "Send a query with image or document attachments to Perplexity Sonar for web-grounded multimodal analysis. " +
            "Supports JPEG, PNG, GIF, WebP images and PDF, DOC, DOCX, TXT, RTF documents (max 50MB). " +
            "Use sonar-deep-research for exhaustive multimodal reports.",
        inputSchema: {
            query: z.string().min(1).describe("The question about the assets"),
            model: z
                .enum([MODELS.PERPLEXITY_SONAR_PRO, MODELS.PERPLEXITY_SONAR_DEEP])
                .default(MODELS.PERPLEXITY_SONAR_PRO)
                .describe("Perplexity model to use"),
            system_prompt: z
                .string()
                .optional()
                .describe("Optional system prompt for context"),
            assets: z
                .array(z.object({
                type: z.enum(["image", "document"]).describe("Asset type"),
                mimeType: z.string().describe("MIME type of the asset"),
                data: z
                    .string()
                    .describe("Asset as base64-encoded content or HTTP/HTTPS URL"),
            }))
                .optional()
                .default([])
                .describe("Array of image or document attachments"),
        },
        outputSchema: {
            answer: z.string().describe("The web-grounded multimodal analysis"),
        },
    }, async ({ query, model, system_prompt, assets }) => {
        const assetKey = assets
            ? assets
                .map((a) => `${a.type}:${a.mimeType}:${a.data.slice(0, 50)}`)
                .join("|")
            : "";
        const cacheKey = getCacheKey("pplx-assets", model, system_prompt, query, assetKey);
        const cached = responseCache.get(cacheKey);
        if (cached) {
            console.error("[CACHE] Hit for", cacheKey.slice(0, 50));
            return { content: [{ type: "text", text: cached.response }] };
        }
        const attachments = assets?.map((a) => ({
            type: a.type,
            mimeType: a.mimeType,
            data: a.data,
        }));
        const result = await callPerplexity(query, model, system_prompt, attachments);
        const cost = calculateCost(model, result.usage.inputTokens, result.usage.outputTokens);
        logCost(cost, false);
        responseCache.set(cacheKey, {
            response: result.response,
            timestamp: Date.now(),
        });
        return { content: [{ type: "text", text: result.response }] };
    });
}
//# sourceMappingURL=perplexity.js.map