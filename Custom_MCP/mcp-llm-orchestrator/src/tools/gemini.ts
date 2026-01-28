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
} from "./shared.js";

const ai = new GoogleGenAI({ apiKey: env.GOOGLE_API_KEY });

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
        "Query Gemini 3 Pro with Google Search grounding for up-to-date answers with web citations. " +
        "Use disable_web_search=true to disable grounding for pure text responses.",
      inputSchema: {
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
      },
      outputSchema: {
        answer: z
          .string()
          .describe("The answer from Gemini with web citations"),
      },
    },
    async ({ query, system_prompt, disable_web_search }) => {
      const cacheKey = getCacheKey(
        "gemini-pro",
        disable_web_search.toString(),
        system_prompt,
        query,
      );
      const cached = responseCache.get(cacheKey);
      if (cached) {
        console.error("[CACHE] Hit for", cacheKey.slice(0, 50));
        return { content: [{ type: "text", text: cached.response }] };
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
      return { content: [{ type: "text", text: result.response }] };
    },
  );

  server.registerTool(
    "ask_gemini_flash",
    {
      title: "Ask Gemini 3 Flash",
      description:
        "Query Gemini 3 Flash for fast, efficient responses with Google Search grounding. " +
        "Use disable_web_search=true for pure text responses without web grounding. " +
        "Most cost-effective option ($0.50/$3 per 1M tokens).",
      inputSchema: {
        query: z.string().min(1).describe("The question to answer"),
        system_prompt: z
          .string()
          .optional()
          .describe("Optional system prompt for context"),
        disable_web_search: z
          .boolean()
          .default(false)
          .describe("Set true to disable Google Search grounding"),
      },
      outputSchema: {
        answer: z.string().describe("The response from Gemini Flash"),
        sources: z
          .array(z.string())
          .optional()
          .describe("Web sources if grounding enabled"),
      },
    },
    async ({ query, system_prompt, disable_web_search }) => {
      const cacheKey = getCacheKey(
        "gemini-flash",
        disable_web_search.toString(),
        system_prompt,
        query,
      );
      const cached = responseCache.get(cacheKey);
      if (cached) {
        console.error("[CACHE] Hit for", cacheKey.slice(0, 50));
        return { content: [{ type: "text", text: cached.response }] };
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
      return { content: [{ type: "text", text: result.response }] };
    },
  );

  server.registerTool(
    "analyze_media",
    {
      title: "Analyze Image, Video, Audio, or Document",
      description:
        "Use Gemini to analyze images, videos, audio, or documents. " +
        "Flash is recommended for cost efficiency. Pro is better for complex reasoning. " +
        "Supports inline base64 data or File API URIs.",
      inputSchema: {
        prompt: z
          .string()
          .min(1)
          .describe("Question or instructions about the media"),
        mediaType: z
          .enum(["image", "video", "audio", "document"])
          .describe("Type of media to analyze"),
        mediaSource: z
          .enum(["inline", "uri"])
          .describe("inline for base64, uri for File API"),
        mimeType: z
          .string()
          .describe(
            "MIME type (e.g., image/jpeg, video/mp4, audio/wav, application/pdf)",
          ),
        data: z
          .string()
          .optional()
          .describe("Base64-encoded media if mediaSource=inline"),
        uri: z.string().optional().describe("File URI if mediaSource=uri"),
        model: z
          .enum([MODELS.GEMINI_FLASH, MODELS.GEMINI_PRO])
          .default(MODELS.GEMINI_FLASH)
          .describe("Model to use (Flash for cost, Pro for complex reasoning)"),
      },
      outputSchema: {
        answer: z.string().describe("The analysis result from Gemini"),
      },
    },
    async ({ prompt, mediaType, mediaSource, mimeType, data, uri, model }) => {
      const cacheKey = getCacheKey(
        "vision",
        model,
        mediaType,
        prompt.slice(0, 50),
      );
      const cached = responseCache.get(cacheKey);
      if (cached) {
        console.error("[CACHE] Hit for", cacheKey.slice(0, 50));
        return { content: [{ type: "text", text: cached.response }] };
      }

      const result = await callGeminiMultimodal(
        prompt,
        mediaType,
        mediaSource,
        mimeType,
        data,
        uri,
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
      return { content: [{ type: "text", text: result.response }] };
    },
  );
}
