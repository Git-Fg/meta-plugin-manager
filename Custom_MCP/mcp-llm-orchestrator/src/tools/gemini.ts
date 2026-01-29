import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { GoogleGenAI } from "@google/genai";
import {
  MODELS,
  type ModelName,
  env,
  responseCache,
  calculateCost,
  logCost,
  getCacheKey,
  processAssetData,
} from "./shared.js";

const ai = new GoogleGenAI({ apiKey: env.GOOGLE_API_KEY });

// Input schemas
const AskGeminiProSchema = z.object({
  query: z
    .string()
    .min(1)
    .describe("The question requiring current information"),
  system_prompt: z
    .string()
    .optional()
    .describe("Optional system prompt for context"),
  disable_web_search: z
    .boolean()
    .default(false)
    .describe("Set true to disable Google Search grounding"),
});

const AskGeminiFlashSchema = z.object({
  query: z.string().min(1).describe("The question to answer"),
  system_prompt: z
    .string()
    .optional()
    .describe("Optional system prompt for context"),
  disable_web_search: z
    .boolean()
    .default(false)
    .describe("Set true to disable Google Search grounding"),
});

const AnalyzeMediaSchema = z.object({
  prompt: z
    .string()
    .min(1)
    .describe("Question or instructions about the media"),
  mediaType: z
    .enum(["image", "video", "audio", "document"])
    .describe("Type of media to analyze"),
  mimeType: z
    .string()
    .optional()
    .describe(
      "MIME type (auto-detected from file extension if data is a file path)",
    ),
  data: z
    .string()
    .optional()
    .describe(
      "File path (e.g., /path/to/image.png or ./docs/document.pdf), URL (http:// or https://), or base64-encoded content",
    ),
  uri: z
    .string()
    .optional()
    .describe("Alias for data parameter (legacy support)"),
  model: z
    .enum([MODELS.GEMINI_FLASH, MODELS.GEMINI_PRO])
    .default(MODELS.GEMINI_FLASH)
    .describe("Model to use (Flash for cost, Pro for complex reasoning)"),
});

type AskGeminiProParams = z.infer<typeof AskGeminiProSchema>;
type AskGeminiFlashParams = z.infer<typeof AskGeminiFlashSchema>;
type AnalyzeMediaParams = z.infer<typeof AnalyzeMediaSchema>;

interface GeminiUsage {
  promptTokenCount?: number;
  candidatesTokenCount?: number;
}

interface GroundingSource {
  uri?: string;
  title?: string;
}

function formatGroundingSources(
  sources: GroundingSource[] | undefined,
): string {
  if (!sources || sources.length === 0) return "";
  const formatted = sources
    .filter((s) => s.uri)
    .map((s) => `- [${s.title ?? s.uri}](${s.uri})`)
    .join("\n");
  return formatted ? `\n\n**Sources:**\n${formatted}` : "";
}

async function callGemini(
  query: string,
  model: string,
  systemPrompt?: string,
  enableGrounding = false,
): Promise<{
  response: string;
  usage: { inputTokens: number; outputTokens: number };
}> {
  const result = await ai.models.generateContent({
    model,
    contents: [{ parts: [{ text: query }] }],
    config: {
      temperature: 0.7,
      maxOutputTokens: 2048,
      ...(systemPrompt && {
        systemInstruction: { parts: [{ text: systemPrompt }] },
      }),
      ...(enableGrounding && {
        tools: [{ googleSearch: {} }],
      }),
    },
  });

  const responseText = result.text ?? "No response from Gemini";
  const usage: GeminiUsage = result.usageMetadata ?? {
    promptTokenCount: query.length,
    candidatesTokenCount: responseText.length,
  };

  const groundingSources = enableGrounding
    ? (
        result.candidates?.[0]?.groundingMetadata as
          | { sources?: Array<{ uri?: string; title?: string }> }
          | undefined
      )?.sources
    : undefined;

  return {
    response: responseText + formatGroundingSources(groundingSources),
    usage: {
      inputTokens: usage.promptTokenCount ?? 0,
      outputTokens: usage.candidatesTokenCount ?? 0,
    },
  };
}

async function callGeminiMultimodal(
  prompt: string,
  _mediaType: "image" | "video" | "audio" | "document",
  mediaSource: "inline" | "uri",
  mimeType: string,
  data?: string,
  uri?: string,
  model: ModelName = MODELS.GEMINI_FLASH,
): Promise<{
  response: string;
  usage: { inputTokens: number; outputTokens: number };
}> {
  const filePart =
    mediaSource === "uri"
      ? { fileData: { mimeType, uri: uri ?? "" } }
      : { inlineData: { mimeType, data: data ?? "" } };

  const result = await ai.models.generateContent({
    model,
    contents: [{ parts: [filePart, { text: prompt }] }],
    config: {
      temperature: 0.7,
      maxOutputTokens: 2048,
    },
  });

  const text = result.text ?? "No response from Gemini";
  const usage: GeminiUsage = result.usageMetadata ?? {
    promptTokenCount: prompt.length,
    candidatesTokenCount: text.length,
  };

  return {
    response: text,
    usage: {
      inputTokens: usage.promptTokenCount ?? 0,
      outputTokens: usage.candidatesTokenCount ?? 0,
    },
  };
}

export function registerGeminiTools(server: McpServer): void {
  server.registerTool(
    "ask_gemini_pro",
    {
      title: "Ask Gemini 3 Pro with web research",
      description:
        "Tool to query Gemini 3 Pro with Google Search grounding. Use when you need up-to-date answers with web citations. Constraint: use ask_gemini_flash for cost-efficient queries; use disable_web_search=true for pure text without grounding.",
      inputSchema: AskGeminiProSchema,
    },
    async ({
      query,
      system_prompt,
      disable_web_search,
    }: AskGeminiProParams) => {
      const cacheKey = getCacheKey(
        "gemini-pro",
        disable_web_search.toString(),
        system_prompt,
        query,
      );
      const cached = responseCache.get(cacheKey);
      if (cached) {
        console.error("[CACHE] Hit for", cacheKey.slice(0, 50));
        return {
          content: [{ type: "text", text: cached.response }],
          structuredContent: { cached: true },
        };
      }

      const result = await callGemini(
        query,
        MODELS.GEMINI_PRO,
        system_prompt,
        !disable_web_search,
      );
      const cost = calculateCost(
        MODELS.GEMINI_PRO,
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
          model: MODELS.GEMINI_PRO,
          usage: result.usage,
          cost,
        },
      };
    },
  );

  server.registerTool(
    "ask_gemini_flash",
    {
      title: "Ask Gemini 3 Flash (Cost-Efficient)",
      description:
        "Tool to query Gemini 3 Flash for fast, efficient responses with Google Search grounding. Use when you need cost-effective web-grounded answers. Constraint: use ask_gemini_pro for complex reasoning; use disable_web_search=true for pure text responses.",
      inputSchema: AskGeminiFlashSchema,
    },
    async ({
      query,
      system_prompt,
      disable_web_search,
    }: AskGeminiFlashParams) => {
      const cacheKey = getCacheKey(
        "gemini-flash",
        disable_web_search.toString(),
        system_prompt,
        query,
      );
      const cached = responseCache.get(cacheKey);
      if (cached) {
        console.error("[CACHE] Hit for", cacheKey.slice(0, 50));
        return {
          content: [{ type: "text", text: cached.response }],
          structuredContent: { cached: true },
        };
      }

      const result = await callGemini(
        query,
        MODELS.GEMINI_FLASH,
        system_prompt,
        !disable_web_search,
      );
      const cost = calculateCost(
        MODELS.GEMINI_FLASH,
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
          model: MODELS.GEMINI_FLASH,
          usage: result.usage,
          cost,
        },
      };
    },
  );

  server.registerTool(
    "analyze_media",
    {
      title: "Analyze Image, Video, Audio, or Document",
      description:
        "Tool to analyze images, videos, audio, or documents using Gemini. Use when you need multimodal analysis. Constraint: Flash for cost efficiency; Pro for complex reasoning; supports file paths (absolute/relative), URLs, and inline base64.",
      inputSchema: AnalyzeMediaSchema,
    },
    async ({
      prompt,
      mediaType,
      mimeType,
      data,
      uri,
      model,
    }: AnalyzeMediaParams) => {
      const mediaData = data || uri;
      if (!mediaData) {
        return {
          content: [
            { type: "text", text: "Either data or uri parameter is required" },
          ],
          isError: true,
        };
      }

      const cacheKey = getCacheKey(
        "vision",
        model,
        mediaType,
        prompt.slice(0, 50),
      );
      const cached = responseCache.get(cacheKey);
      if (cached) {
        console.error("[CACHE] Hit for", cacheKey.slice(0, 50));
        return {
          content: [{ type: "text", text: cached.response }],
          structuredContent: { cached: true },
        };
      }

      const processed = await processAssetData(mediaData, mimeType);
      const mediaSource: "inline" | "uri" = processed.isUrl ? "uri" : "inline";

      const result = await callGeminiMultimodal(
        prompt,
        mediaType,
        mediaSource,
        processed.mimeType,
        processed.isUrl ? undefined : processed.data,
        processed.isUrl ? processed.data : undefined,
        model,
      );
      const cost = calculateCost(
        model,
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
          analysis: result.response,
          model,
          mediaType,
          usage: result.usage,
          cost,
        },
      };
    },
  );
}
