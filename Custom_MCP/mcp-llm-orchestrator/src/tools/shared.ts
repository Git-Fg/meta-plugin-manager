import { z } from "zod";
import { LRUCache } from "lru-cache";
import fs from "fs/promises";
import path from "path";

export const MODELS = {
  GEMINI_FLASH: "gemini-3-flash-preview",
  GEMINI_PRO: "gemini-3-pro-preview",
  PERPLEXITY_SONAR_PRO: "sonar-pro",
  PERPLEXITY_SONAR_DEEP: "sonar-deep-research",
} as const;

export type ModelName = (typeof MODELS)[keyof typeof MODELS];

export interface CostRate {
  input: number;
  output: number;
}

export const COST_PER_MILLION: Record<ModelName, CostRate> = {
  "gemini-3-flash-preview": { input: 0.5, output: 3.0 },
  "gemini-3-pro-preview": { input: 2.0, output: 12.0 },
  "sonar-pro": { input: 10.0, output: 25.0 },
  "sonar-deep-research": { input: 30.0, output: 60.0 },
} satisfies Record<ModelName, CostRate>;

export const EnvSchema = z.object({
  PERPLEXITY_API_KEY: z.string().optional(),
  GOOGLE_API_KEY: z.string().optional(),
});

export const env = EnvSchema.parse(process.env);

export interface CostMetrics {
  model: string;
  inputTokens: number;
  outputTokens: number;
  totalTokens: number;
  estimatedCostUsd: number;
}

export const responseCache = new LRUCache<
  string,
  { response: string; timestamp: number }
>({
  max: 100,
  ttl: 1000 * 60 * 30,
});

export const MIME_TYPES: Record<string, string> = {
  // Images
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".gif": "image/gif",
  ".webp": "image/webp",
  ".bmp": "image/bmp",
  ".svg": "image/svg+xml",
  // Documents
  ".pdf": "application/pdf",
  ".doc": "application/msword",
  ".docx":
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  ".txt": "text/plain",
  ".rtf": "application/rtf",
  ".csv": "text/csv",
  ".json": "application/json",
  // Video/Audio (for Gemini)
  ".mp4": "video/mp4",
  ".webm": "video/webm",
  ".mp3": "audio/mpeg",
  ".wav": "audio/wav",
  ".ogg": "audio/ogg",
  // Code
  ".md": "text/markdown",
};

export function detectMimeType(filePath: string): string {
  const ext = path.extname(filePath).toLowerCase();
  return MIME_TYPES[ext] || "application/octet-stream";
}

export function isAssetData(data: string): "url" | "base64" | "file" {
  if (data.startsWith("http://") || data.startsWith("https://")) {
    return "url";
  }
  if (data.startsWith("data:")) {
    return "base64";
  }
  if (data.startsWith("/") || data.startsWith("./") || data.startsWith("../")) {
    return "file";
  }
  // Assume base64 if it looks like it (contains no special chars that would be in a path)
  return "base64";
}

export interface ProcessedAsset {
  type: "image" | "document" | "video" | "audio";
  mimeType: string;
  data: string;
  isUrl: boolean;
}

export async function processAssetData(
  data: string,
  mimeType?: string,
): Promise<ProcessedAsset> {
  const dataType = isAssetData(data);

  if (dataType === "url") {
    // It's a URL, detect type from extension if possible
    const detectedMime = mimeType || detectMimeType(data);
    const type = getAssetType(detectedMime);
    return { type, mimeType: detectedMime, data, isUrl: true };
  }

  if (dataType === "file") {
    // It's a file path, read and convert to base64
    const resolvedPath = path.resolve(data);
    const fileContent = await fs.readFile(resolvedPath);
    const detectedMime = mimeType || detectMimeType(data);
    const base64Data = fileContent.toString("base64");
    const type = getAssetType(detectedMime);
    return { type, mimeType: detectedMime, data: base64Data, isUrl: false };
  }

  // It's base64 or inline data
  const detectedMime = mimeType || "application/octet-stream";
  const type = getAssetType(detectedMime);
  return { type, mimeType: detectedMime, data, isUrl: false };
}

function getAssetType(
  mimeType: string,
): "image" | "document" | "video" | "audio" {
  if (mimeType.startsWith("image/")) return "image";
  if (mimeType.startsWith("video/")) return "video";
  if (mimeType.startsWith("audio/")) return "audio";
  return "document";
}

export function calculateCost(
  model: ModelName,
  inputTokens: number,
  outputTokens: number,
): CostMetrics {
  const rates = COST_PER_MILLION[model] ?? { input: 0, output: 0 };
  const inputCost = (inputTokens / 1_000_000) * rates.input;
  const outputCost = (outputTokens / 1_000_000) * rates.output;
  return {
    model,
    inputTokens,
    outputTokens,
    totalTokens: inputTokens + outputTokens,
    estimatedCostUsd: Number((inputCost + outputCost).toFixed(6)),
  };
}

export function logCost(metrics: CostMetrics, cacheHit = false): void {
  console.error(
    "[COST]",
    JSON.stringify({
      ...metrics,
      cacheHit,
      timestamp: Date.now(),
    }),
  );
}

export function getCacheKey(
  prefix: string,
  ...parts: (string | undefined)[]
): string {
  return (
    prefix +
    ":" +
    parts
      .map((p) => (p ?? "").slice(0, 100))
      .join(":")
      .replace(/[^a-zA-Z0-9]/g, "-")
  );
}
