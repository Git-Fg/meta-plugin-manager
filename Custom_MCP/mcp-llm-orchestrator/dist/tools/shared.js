import { z } from "zod";
import { LRUCache } from "lru-cache";
export const MODELS = {
    GEMINI_FLASH: "gemini-3-flash-preview",
    GEMINI_PRO: "gemini-3-pro-preview",
    PERPLEXITY_SONAR_PRO: "sonar-pro",
    PERPLEXITY_SONAR_DEEP: "sonar-deep-research",
};
export const COST_PER_MILLION = {
    "gemini-3-flash-preview": { input: 0.5, output: 3.0 },
    "gemini-3-pro-preview": { input: 2.0, output: 12.0 },
    "sonar-pro": { input: 10.0, output: 25.0 },
    "sonar-deep-research": { input: 30.0, output: 60.0 },
};
export const EnvSchema = z.object({
    PERPLEXITY_API_KEY: z.string().optional(),
    GOOGLE_API_KEY: z.string().optional(),
});
export const env = EnvSchema.parse(process.env);
export const responseCache = new LRUCache({
    max: 100,
    ttl: 1000 * 60 * 30,
});
export function calculateCost(model, inputTokens, outputTokens) {
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
export function logCost(metrics, cacheHit = false) {
    console.error("[COST]", JSON.stringify({
        ...metrics,
        cacheHit,
        timestamp: Date.now(),
    }));
}
export function getCacheKey(prefix, ...parts) {
    return (prefix +
        ":" +
        parts
            .map((p) => (p ?? "").slice(0, 100))
            .join(":")
            .replace(/[^a-zA-Z0-9]/g, "-"));
}
//# sourceMappingURL=shared.js.map