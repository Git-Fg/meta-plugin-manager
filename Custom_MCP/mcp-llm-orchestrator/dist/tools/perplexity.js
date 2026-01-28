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
            "Use sonar for simple queries, sonar-pro for advanced search, sonar-reasoning-pro for complex analysis, " +
            "or sonar-deep-research for exhaustive research reports.",
        inputSchema: {
            query: z.string().min(1).describe("The question or research query"),
            model: z
                .enum([
                MODELS.PERPLEXITY_SONAR,
                MODELS.PERPLEXITY_SONAR_PRO,
                MODELS.PERPLEXITY_SONAR_REASONING,
                MODELS.PERPLEXITY_SONAR_DEEP,
            ])
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
    server.registerTool("ask_perplexity_with_image", {
        title: "Ask Perplexity with Image",
        description: "Send a query with image attachment to Perplexity Sonar for web-grounded visual analysis. " +
            "Supports JPEG, PNG, GIF, WebP images via base64 or URL. " +
            "Use sonar-pro for advanced visual reasoning.",
        inputSchema: {
            query: z.string().min(1).describe("The question about the image"),
            imageData: z.string().describe("Image as base64 or HTTP/HTTPS URL"),
            mimeType: z
                .enum(["image/jpeg", "image/png", "image/gif", "image/webp"])
                .default("image/jpeg")
                .describe("Image MIME type"),
            model: z
                .enum([
                MODELS.PERPLEXITY_SONAR,
                MODELS.PERPLEXITY_SONAR_PRO,
                MODELS.PERPLEXITY_SONAR_REASONING,
                MODELS.PERPLEXITY_SONAR_DEEP,
            ])
                .default(MODELS.PERPLEXITY_SONAR_PRO)
                .describe("Perplexity model to use"),
            system_prompt: z
                .string()
                .optional()
                .describe("Optional system prompt for context"),
        },
        outputSchema: {
            answer: z.string().describe("The web-grounded visual analysis"),
        },
    }, async ({ query, imageData, mimeType, model, system_prompt }) => {
        const isUrl = imageData.startsWith("http://") || imageData.startsWith("https://");
        const cacheKey = getCacheKey("pplx-img", model, isUrl ? imageData : imageData.slice(0, 50), query);
        const cached = responseCache.get(cacheKey);
        if (cached) {
            console.error("[CACHE] Hit for", cacheKey.slice(0, 50));
            return { content: [{ type: "text", text: cached.response }] };
        }
        const result = await callPerplexity(query, model, system_prompt, [
            { type: "image", mimeType, data: imageData },
        ]);
        const cost = calculateCost(model, result.usage.inputTokens, result.usage.outputTokens);
        logCost(cost, false);
        responseCache.set(cacheKey, {
            response: result.response,
            timestamp: Date.now(),
        });
        return { content: [{ type: "text", text: result.response }] };
    });
    server.registerTool("ask_perplexity_with_document", {
        title: "Ask Perplexity with Document",
        description: "Send a query with document attachment to Perplexity Sonar for document analysis. " +
            "Supports PDF, DOC, DOCX, TXT, RTF files (max 50MB). " +
            "Use for analyzing reports, papers, contracts, or other documents with web grounding.",
        inputSchema: {
            query: z.string().min(1).describe("The question about the document"),
            documentData: z
                .string()
                .describe("Document as base64-encoded content or HTTP/HTTPS URL"),
            mimeType: z
                .enum([
                "application/pdf",
                "application/msword",
                "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                "text/plain",
                "application/rtf",
            ])
                .describe("Document MIME type"),
            model: z
                .enum([
                MODELS.PERPLEXITY_SONAR,
                MODELS.PERPLEXITY_SONAR_PRO,
                MODELS.PERPLEXITY_SONAR_REASONING,
                MODELS.PERPLEXITY_SONAR_DEEP,
            ])
                .default(MODELS.PERPLEXITY_SONAR_PRO)
                .describe("Perplexity model to use"),
            system_prompt: z
                .string()
                .optional()
                .describe("Optional system prompt for context"),
        },
        outputSchema: {
            answer: z.string().describe("The web-grounded document analysis"),
        },
    }, async ({ query, documentData, mimeType, model, system_prompt }) => {
        const isUrl = documentData.startsWith("http://") ||
            documentData.startsWith("https://");
        const cacheKey = getCacheKey("pplx-doc", model, isUrl ? documentData : documentData.slice(0, 50), query);
        const cached = responseCache.get(cacheKey);
        if (cached) {
            console.error("[CACHE] Hit for", cacheKey.slice(0, 50));
            return { content: [{ type: "text", text: cached.response }] };
        }
        const result = await callPerplexity(query, model, system_prompt, [
            { type: "document", mimeType, data: documentData },
        ]);
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