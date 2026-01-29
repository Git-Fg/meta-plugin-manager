import { z } from "zod";
import { LRUCache } from "lru-cache";
export declare const MODELS: {
    readonly GEMINI_FLASH: "gemini-3-flash-preview";
    readonly GEMINI_PRO: "gemini-3-pro-preview";
    readonly PERPLEXITY_SONAR_PRO: "sonar-pro";
    readonly PERPLEXITY_SONAR_DEEP: "sonar-deep-research";
};
export type ModelName = (typeof MODELS)[keyof typeof MODELS];
export interface CostRate {
    input: number;
    output: number;
}
export declare const COST_PER_MILLION: Record<ModelName, CostRate>;
export declare const EnvSchema: z.ZodObject<{
    PERPLEXITY_API_KEY: z.ZodOptional<z.ZodString>;
    GOOGLE_API_KEY: z.ZodOptional<z.ZodString>;
}, "strip", z.ZodTypeAny, {
    PERPLEXITY_API_KEY?: string | undefined;
    GOOGLE_API_KEY?: string | undefined;
}, {
    PERPLEXITY_API_KEY?: string | undefined;
    GOOGLE_API_KEY?: string | undefined;
}>;
export declare const env: {
    PERPLEXITY_API_KEY?: string | undefined;
    GOOGLE_API_KEY?: string | undefined;
};
export interface CostMetrics {
    model: string;
    inputTokens: number;
    outputTokens: number;
    totalTokens: number;
    estimatedCostUsd: number;
}
export declare const responseCache: LRUCache<string, {
    response: string;
    timestamp: number;
}, unknown>;
export declare const MIME_TYPES: Record<string, string>;
export declare function detectMimeType(filePath: string): string;
export declare function isAssetData(data: string): "url" | "base64" | "file";
export interface ProcessedAsset {
    type: "image" | "document" | "video" | "audio";
    mimeType: string;
    data: string;
    isUrl: boolean;
}
export declare function processAssetData(data: string, mimeType?: string): Promise<ProcessedAsset>;
export declare function calculateCost(model: ModelName, inputTokens: number, outputTokens: number): CostMetrics;
export declare function logCost(metrics: CostMetrics, cacheHit?: boolean): void;
export declare function getCacheKey(prefix: string, ...parts: (string | undefined)[]): string;
//# sourceMappingURL=shared.d.ts.map