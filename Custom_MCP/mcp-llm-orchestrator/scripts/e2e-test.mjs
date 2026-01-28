#!/usr/bin/env node
/**
 * Light E2E Test for MCP LLM Orchestrator
 * Tests real API calls using keys from .mcp.json
 */

import { readFileSync } from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));

// Load API keys from .mcp.json
const mcpConfig = JSON.parse(
  readFileSync(join(__dirname, "..", "..", "..", ".mcp.json"), "utf-8"),
);
const env = mcpConfig.mcpServers["llm-orchestrator"].env;

const PERPLEXITY_API_KEY = env.PERPLEXITY_API_KEY;
const GOOGLE_API_KEY = env.GOOGLE_API_KEY;

// Test counters
let passed = 0;
let failed = 0;

function test(name, fn) {
  return async () => {
    process.stderr.write(`\n[Test] ${name}... `);
    try {
      await fn();
      process.stderr.write("PASSED\n");
      passed++;
    } catch (error) {
      process.stderr.write(`FAILED: ${error.message}\n`);
      failed++;
    }
  };
}

async function testPerplexitySonar() {
  if (!PERPLEXITY_API_KEY) throw new Error("PERPLEXITY_API_KEY not configured");

  const response = await fetch("https://api.perplexity.ai/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${PERPLEXITY_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "sonar",
      messages: [{ role: "user", content: "What is 2+2? Answer with just the number." }],
    }),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Perplexity API error: ${response.status} - ${error}`);
  }

  const data = await response.json();
  const answer = data.choices?.[0]?.message?.content ?? "";

  if (!answer.includes("4")) {
    throw new Error(`Expected answer to contain "4", got: ${answer.slice(0, 100)}`);
  }
}

async function testPerplexitySonarPro() {
  if (!PERPLEXITY_API_KEY) throw new Error("PERPLEXITY_API_KEY not configured");

  const response = await fetch("https://api.perplexity.ai/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${PERPLEXITY_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "sonar-pro",
      messages: [{ role: "user", content: "What is the capital of France? One word only." }],
    }),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Perplexity API error: ${response.status} - ${error}`);
  }

  const data = await response.json();
  const answer = data.choices?.[0]?.message?.content ?? "";

  if (!answer.toLowerCase().includes("paris")) {
    throw new Error(`Expected answer to contain "Paris", got: ${answer.slice(0, 100)}`);
  }
}

async function testGeminiFlash() {
  if (!GOOGLE_API_KEY) throw new Error("GOOGLE_API_KEY not configured");

  const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=${GOOGLE_API_KEY}`;

  const response = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      contents: [{ parts: [{ text: "What is 3+3? Answer with just the number." }] }],
      generation_config: { temperature: 0.7, maxOutputTokens: 50 },
    }),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Gemini API error: ${response.status} - ${error}`);
  }

  const data = await response.json();
  const answer = data.candidates?.[0]?.content?.parts?.[0]?.text ?? "";

  if (!answer.includes("6")) {
    throw new Error(`Expected answer to contain "6", got: ${answer.slice(0, 100)}`);
  }
}

async function testGeminiProWithGrounding() {
  if (!GOOGLE_API_KEY) throw new Error("GOOGLE_API_KEY not configured");

  const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-3-pro-preview:generateContent?key=${GOOGLE_API_KEY}`;

  const response = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      contents: [{ parts: [{ text: "What is the capital of France? One word only." }] }],
      generation_config: { temperature: 0.7, maxOutputTokens: 50 },
      tools: [{ google_search: {} }],
    }),
  });

  // Handle rate limiting gracefully
  if (response.status === 429) {
    throw new Error("RATE_LIMIT_EXCEEDED - Gemini Pro quota exceeded");
  }

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Gemini API error: ${response.status} - ${error}`);
  }

  const data = await response.json();
  const answer = data.candidates?.[0]?.content?.parts?.[0]?.text ?? "";

  // Should mention Paris (capital of France)
  if (!answer.toLowerCase().includes("paris")) {
    throw new Error(`Expected answer to contain "Paris", got: ${answer.slice(0, 200)}`);
  }
}

async function testGeminiVision() {
  if (!GOOGLE_API_KEY) throw new Error("GOOGLE_API_KEY not configured");

  // Simple 1x1 red pixel PNG base64
  const redPixel = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==";

  const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=${GOOGLE_API_KEY}`;

  const response = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      contents: [
        {
          parts: [
            { inline_data: { mime_type: "image/png", data: redPixel } },
            { text: "What color is this image? One word only." },
          ],
        },
      ],
      generation_config: { temperature: 0.7, maxOutputTokens: 50 },
    }),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Gemini Vision API error: ${response.status} - ${error}`);
  }

  const data = await response.json();
  const answer = data.candidates?.[0]?.content?.parts?.[0]?.text ?? "";

  // Accept red, maroon, or crimson (shades of red)
  const redVariants = ["red", "maroon", "crimson", "scarlet"];
  const normalized = answer.toLowerCase().trim();
  const isRed = redVariants.some((v) => normalized.includes(v));

  if (!isRed) {
    throw new Error(`Expected answer to contain red color term, got: ${answer.slice(0, 100)}`);
  }
}

// Run tests
async function main() {
  process.stderr.write("=".repeat(60) + "\n");
  process.stderr.write("MCP LLM Orchestrator - Light E2E Test\n");
  process.stderr.write("=".repeat(60) + "\n");

  // Check configuration
  process.stderr.write(`\nConfiguration:\n`);
  process.stderr.write(`  Perplexity: ${PERPLEXITY_API_KEY ? "✓ Configured" : "✗ Not configured"}\n`);
  process.stderr.write(`  Gemini:     ${GOOGLE_API_KEY ? "✓ Configured" : "✗ Not configured"}\n`);

  if (!PERPLEXITY_API_KEY && !GOOGLE_API_KEY) {
    process.stderr.write("\nERROR: No API keys configured. Add keys to .mcp.json\n");
    process.exit(1);
  }

  const tests = [];

  if (PERPLEXITY_API_KEY) {
    tests.push(test("Perplexity Sonar", testPerplexitySonar));
    tests.push(test("Perplexity Sonar Pro", testPerplexitySonarPro));
  }

  if (GOOGLE_API_KEY) {
    tests.push(test("Gemini Flash", testGeminiFlash));
    tests.push(test("Gemini Pro with Grounding", testGeminiProWithGrounding));
    tests.push(test("Gemini Vision", testGeminiVision));
  }

  for (const t of tests) {
    await t();
  }

  // Summary
  process.stderr.write("\n" + "=".repeat(60) + "\n");
  process.stderr.write(`Results: ${passed} passed, ${failed} failed\n`);
  process.stderr.write("=".repeat(60) + "\n");

  process.exit(failed > 0 ? 1 : 0);
}

main().catch((error) => {
  console.error("Test runner error:", error);
  process.exit(1);
});
