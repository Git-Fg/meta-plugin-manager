#!/usr/bin/env node

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { fetch as crawlFetch, fetchMarkdown } from "@just-every/crawl";
import { exec } from "child_process";
import { promisify } from "util";
import fs from "fs/promises";
import path from "path";
import { createHash } from "crypto";
import Perplexity from "@perplexity-ai/perplexity_ai";

const execAsync = promisify(exec);

const SERVER_NAME = "simplewebfetch-mcp-server";
const SERVER_VERSION = "1.0.0";

const PERPLEXITY_API_KEY = process.env["PERPLEXITY_API_KEY"];

const perplexityClient = PERPLEXITY_API_KEY
  ? new Perplexity({
      apiKey: PERPLEXITY_API_KEY,
      maxRetries: 2,
      timeout: 30_000,
    })
  : null;

const CrawlOptionsSchema = z
  .object({
    respectRobots: z.boolean().optional().default(true),
    timeoutMs: z.number().int().positive().max(60000).optional().default(30000),
    userAgent: z
      .string()
      .optional()
      .default(`${SERVER_NAME}/${SERVER_VERSION}`),
    cacheDir: z.string().optional().default(".cache/simplewebfetch-mcp"),
    maxChars: z
      .number()
      .int()
      .positive()
      .max(500000)
      .optional()
      .default(120000),
  })
  .strict();

type FullWebFetchParams = z.infer<typeof FullWebFetchSchema>;
type SimpleWebFetchParams = z.infer<typeof SimpleWebFetchSchema>;

const FullWebFetchSchema = z.object({
  url: z.string().url().describe("http(s) URL to fetch"),
  options: CrawlOptionsSchema.optional(),
});

const SimpleWebFetchSchema = z.object({
  url: z.string().url().describe("http(s) URL to fetch"),
  options: CrawlOptionsSchema.optional(),
});

const CrawlWebFetchSchema = z.object({
  pattern: z
    .string()
    .describe("URL pattern with wildcard (e.g., https://example.com/docs/*)"),
  outputPath: z.string().min(1).describe("Relative output directory"),
  options: z
    .object({
      maxConcurrency: z.number().int().positive().max(10).default(3),
      respectRobots: z.boolean().optional().default(true),
      timeoutMs: z
        .number()
        .int()
        .positive()
        .max(60000)
        .optional()
        .default(30000),
      userAgent: z
        .string()
        .optional()
        .default(`${SERVER_NAME}/${SERVER_VERSION}`),
      cacheDir: z.string().optional().default(".cache/simplewebfetch-mcp"),
      maxChars: z
        .number()
        .int()
        .positive()
        .max(500000)
        .optional()
        .default(120000),
    })
    .optional(),
});

const SaveWebFetchSchema = z.object({
  url: z.string().url().describe("http(s) URL to fetch"),
  outputPath: z
    .string()
    .min(1)
    .describe(
      "Relative output path for saved file (e.g., docs/page.md or docs/)",
    ),
  options: CrawlOptionsSchema.optional(),
});

const AskWebFetchSchema = z.object({
  url: z.string().url().describe("http(s) URL to fetch and analyze"),
  prompt: z
    .string()
    .min(1)
    .describe(
      "Custom prompt for AI analysis (if not provided, extracts extensive key points)",
    ),
  options: CrawlOptionsSchema.optional(),
});

function isPrivateHost(hostname: string): boolean {
  const h = hostname.toLowerCase();

  if (h === "localhost" || h.endsWith(".localhost")) return true;
  if (h === "127.0.0.1" || h === "::1") return true;

  if (h.startsWith("10.")) return true;
  if (h.startsWith("192.168.")) return true;
  if (h.startsWith("172.")) {
    const parts = h.split(".");
    const second = Number(parts[1] ?? "0");
    if (second >= 16 && second <= 31) return true;
  }

  return false;
}

function validateUrl(input: string): URL {
  let url: URL;
  try {
    url = new URL(input);
  } catch {
    throw new Error("Invalid URL format");
  }

  if (url.protocol !== "http:" && url.protocol !== "https:") {
    throw new Error("Only http and https protocols are allowed");
  }

  if (isPrivateHost(url.hostname)) {
    throw new Error("Private/localhost URLs are not allowed for security");
  }

  return url;
}

function truncateForContext(text: string, maxChars: number): string {
  if (maxChars <= 0) return "";
  if (text.length <= maxChars) return text;
  return text.slice(0, maxChars) + "\n\n[TRUNCATED]\n";
}

const PLAIN_TEXT_EXTENSIONS = [
  ".txt",
  ".md",
  ".markdown",
  ".json",
  ".xml",
  ".csv",
  ".yaml",
  ".yml",
  ".toml",
  ".ini",
  ".env",
  ".conf",
  ".config",
  ".js",
  ".ts",
  ".jsx",
  ".tsx",
  ".mjs",
  ".cjs",
  ".py",
  ".rb",
  ".php",
  ".pl",
  ".sh",
  ".bash",
  ".c",
  ".cpp",
  ".h",
  ".hpp",
  ".rs",
  ".go",
  ".java",
  ".kt",
  ".swift",
  ".dart",
  ".css",
  ".scss",
  ".sass",
  ".less",
  ".html",
  ".htm",
  ".log",
];

function isPlainTextUrl(url: URL): boolean {
  const pathname = url.pathname.toLowerCase();
  return PLAIN_TEXT_EXTENSIONS.some((ext) => pathname.endsWith(ext));
}

async function fetchPlainText(
  url: URL,
  timeoutMs: number = 30000,
  userAgent: string = `${SERVER_NAME}/${SERVER_VERSION}`,
): Promise<string> {
  const isPlainText = isPlainTextUrl(url);

  if (isPlainText) {
    try {
      const { stdout } = await execAsync(
        `curl -sL -m ${timeoutMs / 1000} -A "${userAgent}" -H "Accept: text/plain, text/markdown, application/json, */*" "${url.toString()}"`,
        { timeout: timeoutMs + 1000 },
      );
      if (stdout && stdout.length > 0) {
        return stdout;
      }
    } catch {}
  }

  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

  try {
    const response = await fetch(url.toString(), {
      signal: controller.signal,
      headers: {
        "User-Agent": userAgent,
        Accept: "text/plain, text/markdown, application/json, text/*, */*",
      },
    });

    clearTimeout(timeoutId);

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }

    return await response.text();
  } finally {
    clearTimeout(timeoutId);
  }
}

function getCachePath(url: string, cacheDir: string): string {
  const hash = createHash("sha256").update(url).digest("hex");
  return path.join(cacheDir, `${hash}.json`);
}

function buildCacheMessage(url: string, cacheDir: string): string {
  const cachePath = getCachePath(url, cacheDir);
  return `\n\n---\n\nCache: ${cachePath}\n`;
}

function validateOutputPath(outputPath: string): void {
  if (path.isAbsolute(outputPath)) {
    throw new Error("Output path must be relative");
  }
  if (outputPath.includes("..") || outputPath.startsWith("/")) {
    throw new Error("Invalid output path");
  }
}

function sanitizeFilename(filename: string): string {
  return filename
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .substring(0, 100);
}

function buildMarkdownFile(
  url: string,
  title: string | null,
  markdown: string,
  fetchTime: string,
): string {
  return `---
url: ${url}
title: ${title ?? "N/A"}
fetchTime: ${fetchTime}
---

${markdown}`;
}

async function saveMarkdownFile(
  filePath: string,
  content: string,
): Promise<void> {
  const dir = path.dirname(filePath);
  await fs.mkdir(dir, { recursive: true });
  await fs.writeFile(filePath, content, "utf-8");
}

function parseUrlPattern(pattern: string): { baseUrl: string; prefix: string } {
  const wildcardIndex = pattern.indexOf("*");
  if (wildcardIndex === -1) {
    throw new Error("Pattern must contain wildcard (*)");
  }
  const prefix = pattern.substring(0, wildcardIndex);
  return { baseUrl: prefix, prefix };
}

function matchesPattern(url: string, prefix: string): boolean {
  return url.startsWith(prefix);
}

const server = new McpServer({
  name: SERVER_NAME,
  version: SERVER_VERSION,
});

server.registerTool(
  "fullWebFetch",
  {
    title: "Full Web Fetch (Markdown with Metadata)",
    description:
      "Tool to fetch URL content with full metadata. You MUST use this tool for any request requiring page title or fetch timestamp. Use when you need metadata in the response. Constraint: auto-detects file type; for .txt, .md, .json, .xml, .csv, source code, returns raw content.",
    inputSchema: FullWebFetchSchema,
  },
  async ({ url, options }: FullWebFetchParams) => {
    try {
      const u = validateUrl(url);
      const opts = CrawlOptionsSchema.parse(options ?? {});

      let markdown: string;
      let title: string | null = null;
      const isPlainText = isPlainTextUrl(u);

      if (isPlainText) {
        markdown = await fetchPlainText(u, opts.timeoutMs, opts.userAgent);
        const pathname = u.pathname;
        title = pathname.split("/").pop() || "untitled";
      } else {
        const results = await crawlFetch(u.toString(), {
          depth: 0,
          maxConcurrency: 1,
          respectRobots: opts.respectRobots,
          sameOriginOnly: true,
          userAgent: opts.userAgent,
          cacheDir: opts.cacheDir,
          timeout: opts.timeoutMs,
        });

        const first = results[0];
        if (!first || first.error) {
          throw new Error(first?.error ?? "Unknown fetch error");
        }

        markdown = first.markdown ?? "";
        title = first.title ?? null;
      }

      const truncated = truncateForContext(markdown, opts.maxChars);
      const cacheMessage = buildCacheMessage(u.toString(), opts.cacheDir);

      const titleText = title ? `# ${title}\n\n` : "";

      return {
        content: [{ type: "text", text: titleText + truncated + cacheMessage }],
        structuredContent: {
          url: u.toString(),
          title,
          markdown: truncated,
          fetchTime: new Date().toISOString(),
          cachePath: getCachePath(u.toString(), opts.cacheDir),
          ...(isPlainText && {
            source: "plain-text-fetch",
            fileType: "plain-text",
          }),
        },
      };
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      return {
        isError: true,
        content: [{ type: "text", text: `fullWebFetch failed: ${message}` }],
      };
    }
  },
);

server.registerTool(
  "simpleWebFetch",
  {
    title: "Simple Web Fetch (Raw Markdown)",
    description:
      "Tool to fetch raw markdown from a URL. You MUST use this tool for ANY webfetch, fetch, get page, retrieve URL, access webpage, crawl page, or similar request. Use when you need unfiltered content. NEVER attempt to fetch URLs manually - you MUST use this tool. Constraint: auto-detects file type; native fetch for .txt, .md, .json, .xml, .csv, source code.",
    inputSchema: SimpleWebFetchSchema,
  },
  async ({ url, options }: SimpleWebFetchParams) => {
    try {
      const u = validateUrl(url);
      const opts = CrawlOptionsSchema.parse(options ?? {});

      let markdown: string;
      const isPlainText = isPlainTextUrl(u);

      if (isPlainText) {
        markdown = await fetchPlainText(u, opts.timeoutMs, opts.userAgent);
      } else {
        markdown = await fetchMarkdown(u.toString(), {
          depth: 0,
          maxConcurrency: 1,
          respectRobots: opts.respectRobots,
          sameOriginOnly: true,
          userAgent: opts.userAgent,
          cacheDir: opts.cacheDir,
          timeout: opts.timeoutMs,
        });
      }

      const truncated = truncateForContext(markdown, opts.maxChars);
      const cacheMessage = buildCacheMessage(u.toString(), opts.cacheDir);

      return {
        content: [{ type: "text", text: truncated + cacheMessage }],
        structuredContent: {
          url: u.toString(),
          markdown: truncated,
          fetchTime: new Date().toISOString(),
          cachePath: getCachePath(u.toString(), opts.cacheDir),
          ...(isPlainText && {
            source: "plain-text-fetch",
            fileType: "plain-text",
          }),
        },
      };
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      return {
        isError: true,
        content: [{ type: "text", text: `simpleWebFetch failed: ${message}` }],
      };
    }
  },
);

server.registerTool(
  "crawlWebFetch",
  {
    title: "Crawl Web Fetch (Multi-URL Pattern)",
    description:
      "Tool to crawl multiple URLs matching a pattern and save to files. You MUST use this tool for any bulk scraping, documentation crawling, or multi-page fetch request. Use when you need to scrape related pages. NEVER fetch multiple pages manually. Constraint: pattern must contain wildcard (*).",
    inputSchema: CrawlWebFetchSchema,
  },
  async ({ pattern, outputPath, options }) => {
    try {
      validateOutputPath(outputPath);
      const { baseUrl, prefix } = parseUrlPattern(pattern);

      const opts = options ?? {
        maxConcurrency: 3,
        respectRobots: true,
        timeoutMs: 30000,
        userAgent: `${SERVER_NAME}/${SERVER_VERSION}`,
        cacheDir: ".cache/simplewebfetch-mcp",
        maxChars: 120000,
      };

      const results = await crawlFetch(baseUrl, {
        depth: 0,
        maxConcurrency: opts.maxConcurrency,
        respectRobots: opts.respectRobots,
        sameOriginOnly: true,
        userAgent: opts.userAgent,
        cacheDir: opts.cacheDir,
        timeout: opts.timeoutMs,
      });

      const savedFiles: string[] = [];
      const errors: string[] = [];

      for (const result of results) {
        if (result.error || !result.url || !matchesPattern(result.url, prefix))
          continue;

        try {
          const title = result.title ?? "untitled";
          const markdown = truncateForContext(
            result.markdown ?? "",
            opts.maxChars,
          );
          const fetchTime = new Date().toISOString();
          const fileName = `${sanitizeFilename(title)}.md`;
          const filePath = path.join(outputPath, fileName);
          const fileContent = buildMarkdownFile(
            result.url,
            result.title as string | null,
            markdown,
            fetchTime,
          );
          await saveMarkdownFile(filePath, fileContent);
          savedFiles.push(filePath);
        } catch (saveError) {
          errors.push(
            `${result.url}: ${saveError instanceof Error ? saveError.message : "unknown"}`,
          );
        }
      }

      const summary = `Crawl: ${savedFiles.length}/${results.length} saved to ${outputPath}, ${errors.length} failed`;
      return {
        content: [{ type: "text", text: summary }],
        structuredContent: {
          totalPages: results.length,
          saved: savedFiles.length,
          failed: errors.length,
          savedFiles,
          errors,
        },
      };
    } catch (err) {
      return {
        isError: true,
        content: [
          {
            type: "text",
            text: `crawlWebFetch failed: ${err instanceof Error ? err.message : String(err)}`,
          },
        ],
      };
    }
  },
);

server.registerTool(
  "saveWebFetch",
  {
    title: "Save Web Fetch (File with Metadata)",
    description:
      "Tool to fetch URL content and save to local file with YAML frontmatter. Use when you need to persist fetched content locally. Constraint: outputPath must be relative; creates directory if missing; auto-detects file type.",
    inputSchema: SaveWebFetchSchema,
  },
  async ({ url, outputPath, options }) => {
    try {
      const u = validateUrl(url);
      const opts = CrawlOptionsSchema.parse(options ?? {});

      let markdown: string;
      let title: string | null = null;
      const isPlainText = isPlainTextUrl(u);

      if (isPlainText) {
        markdown = await fetchPlainText(u, opts.timeoutMs, opts.userAgent);
        const pathname = u.pathname;
        title = pathname.split("/").pop() || "untitled";
      } else {
        const results = await crawlFetch(u.toString(), {
          depth: 0,
          maxConcurrency: 1,
          respectRobots: opts.respectRobots,
          sameOriginOnly: true,
          userAgent: opts.userAgent,
          cacheDir: opts.cacheDir,
          timeout: opts.timeoutMs,
        });

        const first = results[0];
        if (!first || first.error) {
          throw new Error(first?.error ?? "Unknown fetch error");
        }

        markdown = first.markdown ?? "";
        title = first.title ?? null;
      }

      const truncated = truncateForContext(markdown, opts.maxChars);
      const fetchTime = new Date().toISOString();

      validateOutputPath(outputPath);

      // Generate filename from title or URL
      const fileName = title
        ? `${sanitizeFilename(title)}.md`
        : `${sanitizeFilename(u.hostname + u.pathname)}.md`;

      const filePath = path.join(outputPath, fileName);
      const fileContent = buildMarkdownFile(
        u.toString(),
        title,
        truncated,
        fetchTime,
      );

      await saveMarkdownFile(filePath, fileContent);

      return {
        content: [
          {
            type: "text",
            text: `Saved ${u.toString()} to ${filePath}`,
          },
        ],
        structuredContent: {
          url: u.toString(),
          filePath,
          title,
          fetchTime,
          cachePath: getCachePath(u.toString(), opts.cacheDir),
        },
      };
    } catch (err) {
      return {
        isError: true,
        content: [
          {
            type: "text",
            text: `saveWebFetch failed: ${err instanceof Error ? err.message : String(err)}`,
          },
        ],
      };
    }
  },
);

server.registerTool(
  "askWebFetch",
  {
    title: "Ask Web Fetch (AI-Powered Analysis)",
    description:
      "Tool to fetch and analyze URL content using AI (Perplexity sonar-pro). Use when you need AI-powered extraction, summarization, or analysis of web content. Constraint: requires PERPLEXITY_API_KEY environment variable.",
    inputSchema: AskWebFetchSchema,
  },
  async ({ url, prompt, options }) => {
    if (!perplexityClient) {
      return {
        isError: true,
        content: [
          {
            type: "text",
            text: "askWebFetch requires PERPLEXITY_API_KEY environment variable. Please set it and try again.",
          },
        ],
      };
    }

    try {
      const u = validateUrl(url);
      const opts = CrawlOptionsSchema.parse(options ?? {});

      let content: string;
      const isPlainText = isPlainTextUrl(u);

      if (isPlainText) {
        content = await fetchPlainText(u, opts.timeoutMs, opts.userAgent);
      } else {
        content = await fetchMarkdown(u.toString(), {
          depth: 0,
          maxConcurrency: 1,
          respectRobots: opts.respectRobots,
          sameOriginOnly: true,
          userAgent: opts.userAgent,
          cacheDir: opts.cacheDir,
          timeout: opts.timeoutMs,
        });
      }

      const truncated = truncateForContext(content, opts.maxChars);

      // Truncate content if too large for API (typically < 100k chars)
      const maxContentLength = 80000;
      const contentForAnalysis =
        truncated.length > maxContentLength
          ? truncated.slice(0, maxContentLength) +
            "\n\n[Content truncated for API analysis...]"
          : truncated;

      // Call Perplexity with the content
      const analysisPrompt =
        prompt.trim() ||
        "Extract and summarize the key information from this webpage content. Provide extensive key points covering the main topics, important details, and actionable information.";

      const messages = [
        {
          role: "system" as const,
          content:
            "You are an expert analyst. Analyze the provided webpage content and respond to the user's query. Be thorough, accurate, and cite specific information from the content.",
        },
        {
          role: "user" as const,
          content: `URL: ${u.toString()}\n\nContent:\n\n${contentForAnalysis}\n\nQuery: ${analysisPrompt}`,
        },
      ];

      const response = await perplexityClient.chat.completions.create({
        model: "sonar-pro",
        messages,
      });

      const answer =
        typeof response.choices[0]?.message.content === "string"
          ? response.choices[0].message.content
          : "No response from AI";

      const cacheMessage = buildCacheMessage(u.toString(), opts.cacheDir);

      return {
        content: [
          {
            type: "text",
            text: answer + cacheMessage,
          },
        ],
        structuredContent: {
          url: u.toString(),
          analysis: answer,
          fetchTime: new Date().toISOString(),
          model: "sonar-pro",
          cachePath: getCachePath(u.toString(), opts.cacheDir),
        },
      };
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      return {
        isError: true,
        content: [
          {
            type: "text",
            text: `askWebFetch failed: ${message}`,
          },
        ],
      };
    }
  },
);

async function main(): Promise<void> {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error(`${SERVER_NAME} v${SERVER_VERSION}: server started (stdio)`);
}

main().catch((e) => {
  console.error("Server initialization error:", e);
  process.exit(1);
});
