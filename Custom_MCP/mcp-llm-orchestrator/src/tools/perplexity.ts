import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import Perplexity from "@perplexity-ai/perplexity_ai";
import type { ChatMessageInput } from "@perplexity-ai/perplexity_ai/resources/shared.js";
import {
  MODELS,
  env,
  responseCache,
  calculateCost,
  logCost,
  getCacheKey,
  processAssetData,
} from "./shared.js";

const perplexityClient = new Perplexity({
  apiKey: env.PERPLEXITY_API_KEY,
  maxRetries: 3,
  timeout: 30_000,
  logLevel:
    (process.env["PERPLEXITY_LOG"] as
      | "debug"
      | "info"
      | "warn"
      | "error"
      | "off") ?? "warn",
});

// Input schemas
const AskPerplexitySchema = z.object({
  query: z.string().min(1).describe("The question or research query"),
  model: z
    .enum([MODELS.PERPLEXITY_SONAR_PRO, MODELS.PERPLEXITY_SONAR_DEEP])
    .default(MODELS.PERPLEXITY_SONAR_PRO)
    .describe("Perplexity model to use"),
  system_prompt: z
    .string()
    .optional()
    .describe("Optional system prompt for context"),
});

const SearchPerplexitySchema = z.object({
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
    .describe(
      "Limit results to trusted domains (e.g., science.org, nature.com)",
    ),
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
    .describe(
      "Search mode: web (default), academic (research papers), sec (SEC filings)",
    ),
});

const AskPerplexityWithAssetsSchema = z.object({
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
    .array(
      z.object({
        type: z.enum(["image", "document"]).describe("Asset type"),
        mimeType: z
          .string()
          .optional()
          .describe(
            "MIME type (auto-detected from file extension if data is a file path)",
          ),
        data: z
          .string()
          .describe(
            "Asset as file path (e.g., /path/to/file.pdf or ./docs/doc.png), URL (http:// or https://), or base64-encoded content",
          ),
      }),
    )
    .optional()
    .default([])
    .describe("Array of image or document attachments"),
});

type AskPerplexityParams = z.infer<typeof AskPerplexitySchema>;
type SearchPerplexityParams = z.infer<typeof SearchPerplexitySchema>;
type AskPerplexityWithAssetsParams = z.infer<
  typeof AskPerplexityWithAssetsSchema
>;

async function callPerplexitySearch(
  query: string | string[],
  options?: {
    maxResults?: number;
    searchDomainFilter?: string[];
    searchRecencyFilter?: "hour" | "day" | "week" | "month" | "year";
    searchAfterDateFilter?: string;
    searchBeforeDateFilter?: string;
    searchMode?: "web" | "academic" | "sec";
  },
): Promise<{
  results: Array<{
    title: string;
    url: string;
    snippet: string;
    date?: string;
  }>;
}> {
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
  } catch (err) {
    if (err instanceof Perplexity.APIError) {
      console.error(
        `[PERPLEXITY SEARCH ERROR] ${err.name} (${err.status}):`,
        err.headers,
      );
      throw new Error(`Perplexity search failed: ${err.name}`);
    }
    throw err;
  }
}

async function callPerplexity(
  query: string,
  model: string,
  systemPrompt?: string,
  attachments?: Array<{
    type: "image" | "document";
    mimeType: string;
    data: string;
  }>,
): Promise<{
  response: string;
  usage: { inputTokens: number; outputTokens: number };
}> {
  if (!env.PERPLEXITY_API_KEY) {
    throw new Error("PERPLEXITY_API_KEY environment variable not set");
  }

  const messages: ChatMessageInput[] = [];
  if (systemPrompt) {
    messages.push({ role: "system", content: systemPrompt });
  }

  const content: Array<
    | { type: "text"; text: string }
    | { type: "image_url"; image_url: { url: string } }
    | { type: "pdf_url"; pdf_url: { url: string } }
    | { type: "file_url"; file_url: { url: string } }
  > = [{ type: "text", text: query }];

  if (attachments && attachments.length > 0) {
    for (const att of attachments) {
      const processed = await processAssetData(att.data, att.mimeType);
      const url = processed.isUrl
        ? processed.data
        : `data:${processed.mimeType};base64,${processed.data}`;
      if (processed.type === "image") {
        content.push({ type: "image_url", image_url: { url } });
      } else if (processed.type === "document") {
        if (processed.mimeType === "application/pdf") {
          content.push({ type: "pdf_url", pdf_url: { url } });
        } else {
          content.push({ type: "file_url", file_url: { url } });
        }
      }
    }
  }

  messages.push({
    role: "user",
    content: content as ChatMessageInput["content"],
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
    } else if (Array.isArray(message?.content)) {
      contentText = message.content
        .map((c) => {
          if ("text" in c) return c.text;
          return "";
        })
        .join("");
    } else {
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
  } catch (err) {
    if (err instanceof Perplexity.APIError) {
      console.error(
        `[PERPLEXITY CHAT ERROR] ${err.name} (${err.status}):`,
        err.headers,
      );
      throw new Error(`Perplexity chat failed: ${err.name}`);
    }
    throw err;
  }
}

export function registerPerplexityTools(server: McpServer): void {
  server.registerTool(
    "ask_perplexity",
    {
      title: "Ask Perplexity (Web-Grounded Answers)",
      description:
        "Tool to query Perplexity AI for web-grounded answers with citations. Use when you need research-focused responses with sources. Constraint: use search_perplexity for raw search results; use sonar-pro for advanced search.",
      inputSchema: AskPerplexitySchema,
    },
    async ({ query, model, system_prompt }: AskPerplexityParams) => {
      const cacheKey = getCacheKey("pplx", model, system_prompt, query);
      const cached = responseCache.get(cacheKey);
      if (cached) {
        console.error("[CACHE] Hit for", cacheKey.slice(0, 50));
        return {
          content: [{ type: "text", text: cached.response }],
          structuredContent: { cached: true },
        };
      }

      const result = await callPerplexity(query, model, system_prompt);
      const cost = calculateCost(
        model as any,
        result.usage.inputTokens,
        result.usage.outputTokens,
      );
      logCost(cost, false);

      responseCache.set(cacheKey, {
        response: result.response,
        timestamp: Date.now(),
      });

      return {
        content: [{ type: "text", text: result.response }],
        structuredContent: {
          answer: result.response,
          model,
          usage: result.usage,
          cost,
        },
      };
    },
  );

  server.registerTool(
    "search_perplexity",
    {
      title: "Search Perplexity (Raw Web Results)",
      description:
        "Tool to get ranked web search results with real-time information. Use when you need raw search results without AI summarization. Constraint: supports multi-query, domain filtering, date filtering, and search mode (web/academic/sec).",
      inputSchema: SearchPerplexitySchema,
    },
    async ({
      query,
      maxResults,
      searchDomainFilter,
      searchRecencyFilter,
      searchAfterDateFilter,
      searchBeforeDateFilter,
      searchMode,
    }: SearchPerplexityParams) => {
      const queryStr = Array.isArray(query) ? query.join("|") : query;
      const cacheKey = getCacheKey(
        "pplx-search",
        queryStr,
        maxResults.toString(),
        searchDomainFilter?.join(","),
        searchRecencyFilter,
        searchAfterDateFilter,
        searchBeforeDateFilter,
        searchMode,
      );
      const cached = responseCache.get(cacheKey);
      if (cached) {
        console.error("[CACHE] Hit for", cacheKey.slice(0, 50));
        return {
          content: [{ type: "text", text: cached.response }],
          structuredContent: { cached: true },
        };
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
        .map(
          (r, i) =>
            `${i + 1}. [${r.title}](${r.url})\n   ${r.snippet}${r.date ? `\n   Date: ${r.date}` : ""}`,
        )
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
        content: [{ type: "text", text: responseText }],
        structuredContent: {
          results: result.results,
          query: Array.isArray(query) ? query : query,
          resultCount: result.results.length,
        },
      };
    },
  );

  server.registerTool(
    "ask_perplexity_with_assets",
    {
      title: "Ask Perplexity with Assets (Multimodal)",
      description:
        "Tool to query Perplexity with image or document attachments for web-grounded multimodal analysis. Use when you need to analyze visual or document content with web context. Constraint: supports file paths (absolute or relative), URLs, and base64; max 50MB per file.",
      inputSchema: AskPerplexityWithAssetsSchema,
    },
    async ({
      query,
      model,
      system_prompt,
      assets,
    }: AskPerplexityWithAssetsParams) => {
      const assetKey = assets
        ? assets
            .map((a) => `${a.type}:${a.mimeType}:${a.data.slice(0, 50)}`)
            .join("|")
        : "";
      const cacheKey = getCacheKey(
        "pplx-assets",
        model,
        system_prompt,
        query,
        assetKey,
      );
      const cached = responseCache.get(cacheKey);
      if (cached) {
        console.error("[CACHE] Hit for", cacheKey.slice(0, 50));
        return {
          content: [{ type: "text", text: cached.response }],
          structuredContent: { cached: true },
        };
      }

      const attachments = assets?.map((a) => ({
        type: a.type as "image" | "document",
        mimeType: a.mimeType || "application/octet-stream",
        data: a.data,
      }));

      const result = await callPerplexity(
        query,
        model,
        system_prompt,
        attachments,
      );
      const cost = calculateCost(
        model as any,
        result.usage.inputTokens,
        result.usage.outputTokens,
      );
      logCost(cost, false);

      responseCache.set(cacheKey, {
        response: result.response,
        timestamp: Date.now(),
      });

      return {
        content: [{ type: "text", text: result.response }],
        structuredContent: {
          answer: result.response,
          model,
          usage: result.usage,
          cost,
          assetCount: assets?.length ?? 0,
        },
      };
    },
  );
}
