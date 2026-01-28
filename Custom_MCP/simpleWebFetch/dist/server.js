#!/usr/bin/env node
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { fetch as crawlFetch, fetchMarkdown } from "@just-every/crawl";
import fs from 'fs/promises';
import path from 'path';
import { createHash } from 'crypto';
const SERVER_NAME = "simplewebfetch-mcp-server";
const SERVER_VERSION = "1.0.0";
const CrawlOptionsSchema = z.object({
    respectRobots: z.boolean().optional().default(true),
    timeoutMs: z.number().int().positive().max(60000).optional().default(30000),
    userAgent: z.string().optional().default(`${SERVER_NAME}/${SERVER_VERSION}`),
    cacheDir: z.string().optional().default(".cache/simplewebfetch-mcp"),
    maxChars: z.number().int().positive().max(500000).optional().default(120000)
}).strict();
const FullWebFetchSchema = z.object({
    url: z.string().url().describe("http(s) URL to fetch"),
    options: CrawlOptionsSchema.optional()
});
const SimpleWebFetchSchema = z.object({
    url: z.string().url().describe("http(s) URL to fetch"),
    options: CrawlOptionsSchema.optional()
});
const SaveWebFetchSchema = z.object({
    url: z.string().url().describe("http(s) URL to fetch"),
    outputPath: z.string().min(1).describe("Relative path or file path (e.g., 'docs/folder/' or 'docs/file.md')"),
    options: CrawlOptionsSchema.optional()
});
const CrawlWebFetchSchema = z.object({
    pattern: z.string().describe("URL pattern to match (e.g., 'https://example.com/docs/*')"),
    outputPath: z.string().min(1).describe("Relative path to save crawled files"),
    options: z.object({
        maxConcurrency: z.number().int().positive().max(10).default(3),
        respectRobots: z.boolean().optional().default(true),
        timeoutMs: z.number().int().positive().max(60000).optional().default(30000),
        userAgent: z.string().optional().default(`${SERVER_NAME}/${SERVER_VERSION}`),
        cacheDir: z.string().optional().default(".cache/simplewebfetch-mcp"),
        maxChars: z.number().int().positive().max(500000).optional().default(120000)
    }).optional()
});
const AskWebFetchSchema = z.object({
    url: z.string().url().describe("http(s) URL to fetch and analyze"),
    prompt: z.string().optional().describe("Custom prompt to ask about the content. If not provided, will ask for extensive key points summary"),
    model: z.string().optional().default("z-ai/glm-4.5-air:free").describe("OpenRouter model to use for analysis"),
    options: CrawlOptionsSchema.optional()
});
const WebFetchSchema = z.object({
    url: z.string().url().describe("http(s) URL to fetch"),
    includeMetadata: z.boolean().optional().default(false).describe("Include page title and metadata in the response. When false, returns clean markdown only for minimal context pollution. When true, includes page title as markdown header."),
    options: CrawlOptionsSchema.optional()
});
function isPrivateHost(hostname) {
    const h = hostname.toLowerCase();
    if (h === "localhost" || h.endsWith(".localhost"))
        return true;
    if (h === "127.0.0.1" || h === "::1")
        return true;
    if (h.startsWith("10."))
        return true;
    if (h.startsWith("192.168."))
        return true;
    if (h.startsWith("172.")) {
        const parts = h.split(".");
        const second = Number(parts[1] ?? "0");
        if (second >= 16 && second <= 31)
            return true;
    }
    return false;
}
function validateUrl(input) {
    let url;
    try {
        url = new URL(input);
    }
    catch {
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
function truncateForContext(text, maxChars) {
    if (maxChars <= 0)
        return "";
    if (text.length <= maxChars)
        return text;
    return text.slice(0, maxChars) + "\n\n[TRUNCATED]\n";
}
// Plain text file extensions that should use native fetch
const PLAIN_TEXT_EXTENSIONS = [
    // Documents
    '.txt', '.md', '.markdown',
    // Data formats
    '.json', '.xml', '.csv', '.yaml', '.yml', '.toml', '.ini',
    // Config files
    '.env', '.conf', '.config',
    // Source code
    '.js', '.ts', '.jsx', '.tsx', '.mjs', '.cjs',
    '.py', '.rb', '.php', '.pl', '.sh', '.bash',
    '.c', '.cpp', '.h', '.hpp', '.rs', '.go',
    '.java', '.kt', '.swift', '.dart',
    '.css', '.scss', '.sass', '.less',
    '.html', '.htm',
    // Logs
    '.log'
];
function isPlainTextUrl(url) {
    const pathname = url.pathname.toLowerCase();
    return PLAIN_TEXT_EXTENSIONS.some(ext => pathname.endsWith(ext));
}
async function fetchPlainText(url, timeoutMs = 30000, userAgent = `${SERVER_NAME}/${SERVER_VERSION}`) {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), timeoutMs);
    try {
        const response = await fetch(url.toString(), {
            signal: controller.signal,
            headers: {
                'User-Agent': userAgent,
                'Accept': 'text/plain, text/markdown, application/json, text/*, */*'
            }
        });
        clearTimeout(timeoutId);
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        // Get content type for encoding detection
        const contentType = response.headers.get('content-type') || 'text/plain';
        const charsetMatch = contentType.match(/charset=([^;]+)/i);
        const encoding = charsetMatch ? charsetMatch[1].toLowerCase().trim() : 'utf-8';
        // Get text content
        const content = await response.text();
        return { content, encoding, mimeType: contentType };
    }
    catch (err) {
        clearTimeout(timeoutId);
        throw err;
    }
}
// Generate cache file path for a URL (matches @just-every/crawl pattern)
function getCachePath(url, cacheDir) {
    const hash = createHash('sha256').update(url).digest('hex');
    return path.join(cacheDir, `${hash}.json`);
}
// Build cache reference message
function buildCacheMessage(url, cacheDir) {
    const cachePath = getCachePath(url, cacheDir);
    return `\n\n---\n\n📦 **Cache**: The research has been saved in cache at \`${cachePath}\`\n\n💡 Make sure to carefully read if you missed any information, and re-read it as much as relevant for future operations.\n`;
}
function validateOutputPath(outputPath) {
    if (path.isAbsolute(outputPath)) {
        throw new Error("Output path must be relative, not absolute");
    }
    if (outputPath.includes("..")) {
        throw new Error("Output path cannot contain directory traversal (../)");
    }
    if (outputPath.startsWith("/")) {
        throw new Error("Output path cannot start with /");
    }
}
function sanitizeFilename(filename) {
    return filename
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, "-")
        .replace(/^-+|-+$/g, "")
        .substring(0, 100);
}
function buildMarkdownFile(url, title, markdown, fetchTime) {
    const frontmatter = [
        "---",
        `url: ${url}`,
        `title: ${title ?? "N/A"}`,
        `fetchTime: ${fetchTime}`,
        "---",
        "",
        markdown
    ].join("\n");
    return frontmatter;
}
async function saveMarkdownFile(filePath, content) {
    const dir = path.dirname(filePath);
    await fs.mkdir(dir, { recursive: true });
    await fs.writeFile(filePath, content, "utf-8");
}
function parseUrlPattern(pattern) {
    const wildcardIndex = pattern.indexOf("*");
    if (wildcardIndex === -1) {
        throw new Error("Pattern must contain a wildcard (*) character");
    }
    const baseUrl = pattern.substring(0, wildcardIndex);
    const prefix = pattern.substring(0, wildcardIndex);
    return { baseUrl, prefix };
}
function matchesPattern(url, prefix) {
    return url.startsWith(prefix);
}
async function callOpenRouter(content, prompt, model = "z-ai/glm-4.5-air:free", siteUrl, siteName) {
    const apiKey = process.env.OPENROUTER_API_KEY;
    if (!apiKey) {
        throw new Error("OPENROUTER_API_KEY environment variable is not set. Please set it in your .mcp.json configuration file or environment.");
    }
    const messages = [
        {
            role: "user",
            content: `${prompt}\n\nContent to analyze:\n\n${content}`
        }
    ];
    const headers = {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json"
    };
    if (siteUrl) {
        headers["HTTP-Referer"] = siteUrl;
    }
    if (siteName) {
        headers["X-Title"] = siteName;
    }
    const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
        method: "POST",
        headers,
        body: JSON.stringify({
            model,
            messages
        })
    });
    if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`OpenRouter API error (${response.status}): ${errorText}`);
    }
    const data = await response.json();
    if (!data.choices || data.choices.length === 0) {
        throw new Error("No response from OpenRouter API");
    }
    return data.choices[0].message.content;
}
const server = new McpServer({
    name: SERVER_NAME,
    version: SERVER_VERSION
});
server.registerTool("fullWebFetch", {
    title: "Full Web Fetch (Markdown)",
    description: "Fetch a single URL and return the complete extracted Markdown content. This tool retrieves the full page content converted to clean Markdown format, including title and metadata when available. For .txt, .md, .json, .xml, .csv, and source code files, returns raw content directly with filename as title.",
    inputSchema: FullWebFetchSchema
}, async ({ url, options }) => {
    try {
        const u = validateUrl(url);
        const opts = CrawlOptionsSchema.parse(options ?? {});
        let markdown;
        let title = null;
        const isPlainText = isPlainTextUrl(u);
        if (isPlainText) {
            // Use native fetch for plain text files
            const result = await fetchPlainText(u, opts.timeoutMs, opts.userAgent);
            markdown = result.content;
            // Use filename as title for plain text files
            const pathname = u.pathname;
            const filename = pathname.split('/').pop() || 'untitled';
            title = filename;
        }
        else {
            // Use crawl library for HTML pages
            const results = await crawlFetch(u.toString(), {
                depth: 0,
                maxConcurrency: 1,
                respectRobots: opts.respectRobots,
                sameOriginOnly: true,
                userAgent: opts.userAgent,
                cacheDir: opts.cacheDir,
                timeout: opts.timeoutMs
            });
            const first = results[0];
            if (!first || first.error) {
                throw new Error(first?.error ?? "Unknown fetch error");
            }
            markdown = first.markdown ?? "";
            title = first.title ?? null;
        }
        const truncated = truncateForContext(markdown, opts.maxChars);
        const cachePath = getCachePath(u.toString(), opts.cacheDir);
        const cacheMessage = buildCacheMessage(u.toString(), opts.cacheDir);
        const structuredContent = {
            url: u.toString(),
            title,
            markdown: truncated,
            fetchTime: new Date().toISOString(),
            cachePath,
            ...(isPlainText && { source: 'plain-text-fetch', fileType: 'plain-text' })
        };
        const titleText = title ? `# ${title}\n\n` : "";
        return {
            content: [{ type: "text", text: titleText + truncated + cacheMessage }],
            structuredContent
        };
    }
    catch (err) {
        const message = err instanceof Error ? err.message : String(err);
        return {
            isError: true,
            content: [{ type: "text", text: `fullWebFetch failed: ${message}` }]
        };
    }
});
server.registerTool("simpleWebFetch", {
    title: "Simple Web Fetch (Markdown)",
    description: "MANDATORY USE when needing to simply obtain the full context from a URL. Fetch a URL and return the extracted markdown content. This tool retrieves the complete page content converted to clean Markdown format without any AI processing or filtering. Use this tool when you need the raw, unfiltered markdown content from a webpage for context, analysis, or further processing. Returns: url, complete markdown content, and fetch timestamp. For .txt, .md, .json, .xml, .csv, and source code files, returns raw content directly using native fetch.",
    inputSchema: SimpleWebFetchSchema
}, async ({ url, options }) => {
    try {
        const u = validateUrl(url);
        const opts = CrawlOptionsSchema.parse(options ?? {});
        let markdown;
        const isPlainText = isPlainTextUrl(u);
        if (isPlainText) {
            // Use native fetch for plain text files
            const result = await fetchPlainText(u, opts.timeoutMs, opts.userAgent);
            markdown = result.content;
        }
        else {
            // Use crawl library for HTML pages
            markdown = await fetchMarkdown(u.toString(), {
                depth: 0,
                maxConcurrency: 1,
                respectRobots: opts.respectRobots,
                sameOriginOnly: true,
                userAgent: opts.userAgent,
                cacheDir: opts.cacheDir,
                timeout: opts.timeoutMs
            });
        }
        const truncated = truncateForContext(markdown, opts.maxChars);
        const cachePath = getCachePath(u.toString(), opts.cacheDir);
        const cacheMessage = buildCacheMessage(u.toString(), opts.cacheDir);
        const structuredContent = {
            url: u.toString(),
            markdown: truncated,
            fetchTime: new Date().toISOString(),
            cachePath,
            ...(isPlainText && { source: 'plain-text-fetch', fileType: 'plain-text' })
        };
        return {
            content: [{ type: "text", text: truncated + cacheMessage }],
            structuredContent
        };
    }
    catch (err) {
        const message = err instanceof Error ? err.message : String(err);
        return {
            isError: true,
            content: [{ type: "text", text: `simpleWebFetch failed: ${message}` }]
        };
    }
});
server.registerTool("saveWebFetch", {
    title: "Save Web Fetch (Markdown to File)",
    description: "Fetch a URL and save the extracted markdown content to a local file. Includes YAML frontmatter metadata. For .txt, .md, .json, .xml, .csv, and source code files, saves raw content directly.",
    inputSchema: SaveWebFetchSchema
}, async ({ url, outputPath, options }) => {
    try {
        const u = validateUrl(url);
        validateOutputPath(outputPath);
        const opts = CrawlOptionsSchema.parse(options ?? {});
        let markdown;
        let title = null;
        const isPlainText = isPlainTextUrl(u);
        if (isPlainText) {
            // Use native fetch for plain text files
            const result = await fetchPlainText(u, opts.timeoutMs, opts.userAgent);
            markdown = result.content;
            // Use filename as title for plain text files
            const pathname = u.pathname;
            title = pathname.split('/').pop() || 'untitled';
        }
        else {
            // Use crawl library for HTML pages
            const results = await crawlFetch(u.toString(), {
                depth: 0,
                maxConcurrency: 1,
                respectRobots: opts.respectRobots,
                sameOriginOnly: true,
                userAgent: opts.userAgent,
                cacheDir: opts.cacheDir,
                timeout: opts.timeoutMs
            });
            const first = results[0];
            if (!first || first.error) {
                throw new Error(first?.error ?? "Unknown fetch error");
            }
            markdown = first.markdown ?? "";
            title = first.title ?? null;
        }
        const content = truncateForContext(markdown, opts.maxChars);
        const fetchTime = new Date().toISOString();
        let filePath;
        const hasExtension = path.extname(outputPath) !== "";
        if (hasExtension) {
            filePath = outputPath;
        }
        else {
            const titleText = title ?? "untitled";
            const fileName = `${sanitizeFilename(titleText)}.md`;
            filePath = path.join(outputPath, fileName);
        }
        const fileContent = buildMarkdownFile(u.toString(), title, content, fetchTime);
        await saveMarkdownFile(filePath, fileContent);
        const stats = await fs.stat(filePath);
        const structuredContent = {
            filePath,
            url: u.toString(),
            title,
            fileSize: stats.size,
            fetchTime,
            ...(isPlainText && { source: 'plain-text-fetch', fileType: 'plain-text' })
        };
        const summary = `Successfully saved "${title || 'untitled'}" to ${filePath} (${stats.size} bytes)`;
        return {
            content: [{ type: "text", text: summary }],
            structuredContent
        };
    }
    catch (err) {
        const message = err instanceof Error ? err.message : String(err);
        return {
            isError: true,
            content: [{ type: "text", text: `saveWebFetch failed: ${message}` }]
        };
    }
});
server.registerTool("crawlWebFetch", {
    title: "Crawl Web Fetch (Multi-URL)",
    description: "Crawl multiple URLs matching a pattern and save all results to a directory. Uses wildcard pattern matching.",
    inputSchema: CrawlWebFetchSchema
}, async ({ pattern, outputPath, options }) => {
    try {
        validateOutputPath(outputPath);
        const { baseUrl, prefix } = parseUrlPattern(pattern);
        const opts = options ?? {
            maxConcurrency: 3,
            respectRobots: true,
            timeoutMs: 30000,
            userAgent: `${SERVER_NAME}/${SERVER_VERSION}`,
            cacheDir: ".cache/simplewebfetch-mcp",
            maxChars: 120000
        };
        const results = await crawlFetch(baseUrl, {
            depth: 0,
            maxConcurrency: opts.maxConcurrency,
            respectRobots: opts.respectRobots,
            sameOriginOnly: true,
            userAgent: opts.userAgent,
            cacheDir: opts.cacheDir,
            timeout: opts.timeoutMs
        });
        const savedFiles = [];
        const errors = [];
        for (const result of results) {
            if (result.error) {
                errors.push(`${result.url}: ${result.error}`);
                continue;
            }
            if (!result.url || !matchesPattern(result.url, prefix)) {
                continue;
            }
            try {
                const title = result.title ?? "untitled";
                const markdown = truncateForContext(result.markdown ?? "", opts.maxChars);
                const fetchTime = new Date().toISOString();
                const fileName = `${sanitizeFilename(title)}.md`;
                const filePath = path.join(outputPath, fileName);
                const fileContent = buildMarkdownFile(result.url, result.title || null, markdown, fetchTime);
                await saveMarkdownFile(filePath, fileContent);
                savedFiles.push(filePath);
            }
            catch (saveError) {
                const errorMessage = saveError instanceof Error ? saveError.message : String(saveError);
                errors.push(`${result.url}: ${errorMessage}`);
            }
        }
        const structuredContent = {
            totalPages: results.length,
            successfullySaved: savedFiles.length,
            failed: errors.length,
            savedFiles,
            errors: errors.length > 0 ? errors : undefined
        };
        const summary = `Crawl complete: ${savedFiles.length} files saved to ${outputPath}, ${errors.length} failed out of ${results.length} total pages`;
        return {
            content: [{ type: "text", text: summary }],
            structuredContent
        };
    }
    catch (err) {
        const message = err instanceof Error ? err.message : String(err);
        return {
            isError: true,
            content: [{ type: "text", text: `crawlWebFetch failed: ${message}` }]
        };
    }
});
server.registerTool("askWebFetch", {
    title: "Ask Web Fetch (AI-Powered Content Analysis)",
    description: "Fetch a URL and use OpenRouter AI to analyze the content based on a prompt. Requires OPENROUTER_API_KEY environment variable. If no prompt is provided, will default to extracting extensive key points. For .txt, .md, .json, .xml, .csv, and source code files, analyzes raw content directly.",
    inputSchema: AskWebFetchSchema
}, async ({ url, prompt, model, options }) => {
    try {
        const u = validateUrl(url);
        const opts = CrawlOptionsSchema.parse(options ?? {});
        let content;
        const isPlainText = isPlainTextUrl(u);
        if (isPlainText) {
            // Use native fetch for plain text files
            const result = await fetchPlainText(u, opts.timeoutMs, opts.userAgent);
            content = result.content;
        }
        else {
            // Use crawl library for HTML pages
            content = await fetchMarkdown(u.toString(), {
                depth: 0,
                maxConcurrency: 1,
                respectRobots: opts.respectRobots,
                sameOriginOnly: true,
                userAgent: opts.userAgent,
                cacheDir: opts.cacheDir,
                timeout: opts.timeoutMs
            });
        }
        const truncated = truncateForContext(content, opts.maxChars);
        const defaultPrompt = "Please extract and summarize the extensive key points from this content. Provide a comprehensive analysis including main topics, important details, and actionable insights.";
        const finalPrompt = prompt || defaultPrompt;
        const siteUrl = process.env.SITE_URL || process.env.HTTP_REFERER;
        const siteName = process.env.SITE_NAME || process.env.X_TITLE || SERVER_NAME;
        const analysis = await callOpenRouter(truncated, finalPrompt, model, siteUrl, siteName);
        const structuredContent = {
            url: u.toString(),
            model,
            prompt: finalPrompt,
            analysis,
            fetchTime: new Date().toISOString(),
            ...(isPlainText && { source: 'plain-text-fetch', fileType: 'plain-text' })
        };
        return {
            content: [{ type: "text", text: analysis }],
            structuredContent
        };
    }
    catch (err) {
        const message = err instanceof Error ? err.message : String(err);
        return {
            isError: true,
            content: [{ type: "text", text: `askWebFetch failed: ${message}` }]
        };
    }
});
server.registerTool("webFetch", {
    title: "Web Fetch (Unified)",
    description: "UNIFIED TOOL for optimal web fetching. Fetches a URL and returns clean markdown content. Use includeMetadata=false for minimal context pollution (recommended for LLM context). Use includeMetadata=true when you need the page title. This tool optimally combines the functionality of simpleWebFetch and fullWebFetch. For .txt, .md, .json, .xml, .csv, and source code files, returns raw content directly.",
    inputSchema: WebFetchSchema
}, async ({ url, includeMetadata, options }) => {
    try {
        const u = validateUrl(url);
        const opts = CrawlOptionsSchema.parse(options ?? {});
        let markdown;
        let title = null;
        const isPlainText = isPlainTextUrl(u);
        if (isPlainText) {
            // Use native fetch for plain text files
            const result = await fetchPlainText(u, opts.timeoutMs, opts.userAgent);
            markdown = result.content;
            // Use filename as title for plain text files when metadata requested
            if (includeMetadata) {
                const pathname = u.pathname;
                title = pathname.split('/').pop() || 'untitled';
            }
        }
        else if (includeMetadata) {
            // Use crawl library with metadata for HTML pages
            const results = await crawlFetch(u.toString(), {
                depth: 0,
                maxConcurrency: 1,
                respectRobots: opts.respectRobots,
                sameOriginOnly: true,
                userAgent: opts.userAgent,
                cacheDir: opts.cacheDir,
                timeout: opts.timeoutMs
            });
            const first = results[0];
            if (!first || first.error) {
                throw new Error(first?.error ?? "Unknown fetch error");
            }
            markdown = first.markdown ?? "";
            title = first.title ?? null;
        }
        else {
            // Use simple markdown fetch for HTML without metadata
            markdown = await fetchMarkdown(u.toString(), {
                depth: 0,
                maxConcurrency: 1,
                respectRobots: opts.respectRobots,
                sameOriginOnly: true,
                userAgent: opts.userAgent,
                cacheDir: opts.cacheDir,
                timeout: opts.timeoutMs
            });
        }
        const truncated = truncateForContext(markdown, opts.maxChars);
        const structuredContent = {
            url: u.toString(),
            title,
            markdown: truncated,
            fetchTime: new Date().toISOString(),
            ...(isPlainText && { source: 'plain-text-fetch', fileType: 'plain-text' })
        };
        const contentText = includeMetadata && title
            ? `# ${title}\n\n${truncated}`
            : truncated;
        return {
            content: [{ type: "text", text: contentText }],
            structuredContent
        };
    }
    catch (err) {
        const message = err instanceof Error ? err.message : String(err);
        return {
            isError: true,
            content: [{ type: "text", text: `webFetch failed: ${message}` }]
        };
    }
});
async function main() {
    const transport = new StdioServerTransport();
    await server.connect(transport);
    console.error(`${SERVER_NAME} v${SERVER_VERSION}: server started (stdio)`);
}
main().catch((e) => {
    console.error("Server initialization error:", e);
    process.exit(1);
});
//# sourceMappingURL=server.js.map