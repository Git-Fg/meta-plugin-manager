import { z } from "zod";
import { LRUCache } from "lru-cache";

export const MODELS = {
  PERPLEXITY_SONAR_PRO: "sonar-pro",
  PERPLEXITY_SONAR_DEEP: "sonar-deep-research",
} as const;

export type ModelName = (typeof MODELS)[keyof typeof MODELS];

export interface CostRate {
  input: number;
  output: number;
}

export const COST_PER_MILLION: Record<ModelName, CostRate> = {
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
