#!/usr/bin/env node

/**
 * Test Suite for simpleWebFetch MCP Server
 *
 * Uses @modelcontextprotocol/sdk to programmatically test the server.
 * Tests all 5 tools: fullWebFetch, simpleWebFetch, saveWebFetch, crawlWebFetch, askWebFetch
 *
 * Run with: npx tsx src/test-suite.ts
 */

import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";
import { spawn } from "child_process";
import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Test configuration
const SERVER_PATH = path.join(__dirname, "../dist/server.js");
const SERVER_TIMEOUT = 10000;
const TEST_TIMEOUT = 30000;

interface TestResult {
  name: string;
  passed: boolean;
  error?: string;
  duration: number;
}

interface TestSuite {
  name: string;
  tests: TestResult[];
}

// Color helpers
const green = (s: string) => `\x1b[32m${s}\x1b[0m`;
const red = (s: string) => `\x1b[31m${s}\x1b[0m`;
const yellow = (s: string) => `\x1b[33m${s}\x1b[0m`;
const blue = (s: string) => `\x1b[34m${s}\x1b[0m`;

class MCPTestSuite {
  private server: ReturnType<typeof spawn> | null = null;
  private transport: StdioClientTransport | null = null;
  private client: Client | null = null;
  private results: TestSuite[] = [];

  async startServer(): Promise<void> {
    console.log(blue("\n🚀 Starting MCP server..."));

    // Check if built
    try {
      await fs.access(SERVER_PATH);
    } catch {
      throw new Error(`Server not built. Run 'pnpm build' first.`);
    }

    return new Promise((resolve, reject) => {
      const timeout = setTimeout(() => {
        reject(new Error("Server startup timeout"));
      }, SERVER_TIMEOUT);

      this.server = spawn("node", [SERVER_PATH], {
        stdio: ["pipe", "pipe", "pipe"],
      });

      this.server.stderr?.on("data", (data) => {
        const msg = data.toString();
        if (msg.includes("server started")) {
          clearTimeout(timeout);
          console.log(green("✓ Server started"));
          resolve();
        }
      });

      this.server.on("error", (err) => {
        clearTimeout(timeout);
        reject(err);
      });

      this.server.on("exit", (code) => {
        if (code !== null && code !== 0) {
          clearTimeout(timeout);
          reject(new Error(`Server exited with code ${code}`));
        }
      });
    });
  }

  async connect(): Promise<void> {
    console.log(blue("🔌 Connecting to MCP server..."));

    this.transport = new StdioClientTransport({
      command: "node",
      args: [SERVER_PATH],
    });

    this.client = new Client({
      name: "test-client",
      version: "1.0.0",
    });

    await this.client.connect(this.transport);
    console.log(green("✓ Connected"));
  }

  async listTools(): Promise<string[]> {
    if (!this.client) throw new Error("Not connected");
    const result = await this.client.listTools();
    return result.tools.map((t: { name: string }) => t.name);
  }

  async callTool<T = unknown>(
    name: string,
    args: Record<string, unknown> = {},
  ): Promise<{
    content: Array<{ type: string; text: string }>;
    isError?: boolean;
    structuredContent?: T;
  }> {
    if (!this.client) throw new Error("Not connected");
    return this.client.callTool({ name, arguments: args }) as Promise<{
      content: Array<{ type: string; text: string }>;
      isError?: boolean;
      structuredContent?: T;
    }>;
  }

  async runTest<T>(
    suiteName: string,
    testName: string,
    testFn: () => Promise<T>,
    validate: (result: T) => boolean,
  ): Promise<TestResult> {
    const start = Date.now();
    console.log(`  Testing: ${testName}...`);

    try {
      const result = await testFn();
      const passed = validate(result);
      const duration = Date.now() - start;

      console.log(
        passed
          ? green(`    ✓ PASS (${duration}ms)`)
          : red(`    ✗ FAIL (${duration}ms)`),
      );

      return { name: testName, passed, duration };
    } catch (error) {
      const duration = Date.now() - start;
      const message = error instanceof Error ? error.message : String(error);
      console.log(red(`    ✗ FAIL (${duration}ms): ${message}`));

      return { name: testName, passed: false, error: message, duration };
    }
  }

  async cleanup(): Promise<void> {
    if (this.client) {
      await this.client.close();
      this.client = null;
    }
    if (this.transport) {
      await this.transport.close();
      this.transport = null;
    }
    if (this.server) {
      this.server.kill();
      this.server = null;
    }
  }

  // ============ TEST SUITES ============

  async runConnectionTests(): Promise<void> {
    const suite: TestSuite = { name: "Connection & Discovery", tests: [] };

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Server starts and responds",
        async () => {
          await this.startServer();
          await this.connect();
          return true;
        },
        (r) => r === true,
      ),
    );

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Lists all 5 tools",
        async () => this.listTools(),
        (tools) => {
          const expected = [
            "fullWebFetch",
            "simpleWebFetch",
            "saveWebFetch",
            "crawlWebFetch",
            "askWebFetch",
          ];
          return expected.every((t) => tools.includes(t));
        },
      ),
    );

    this.results.push(suite);
  }

  async runFullWebFetchTests(): Promise<void> {
    const suite: TestSuite = { name: "fullWebFetch", tests: [] };

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Fetches markdown content with metadata",
        async () =>
          this.callTool("fullWebFetch", { url: "https://example.com" }),
        (r) => {
          if (r.isError) throw new Error("Tool returned error");
          const sc = r.structuredContent as Record<string, unknown> | null;
          return (
            r.content.length > 0 &&
            sc != null &&
            "url" in sc &&
            "title" in sc &&
            "fetchTime" in sc
          );
        },
      ),
    );

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Returns plain text for .md files",
        async () =>
          this.callTool("fullWebFetch", {
            url: "https://raw.githubusercontent.com/README.md",
          }),
        (r) => {
          if (r.isError) throw new Error("Tool returned error");
          const sc = r.structuredContent as { source?: string } | null;
          return sc != null && sc.source === "plain-text-fetch";
        },
      ),
    );

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Rejects invalid URL",
        async () => this.callTool("fullWebFetch", { url: "not-a-url" }),
        (r) => r.isError === true,
      ),
    );

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Rejects localhost URLs",
        async () =>
          this.callTool("fullWebFetch", { url: "http://localhost:8080" }),
        (r) => r.isError === true,
      ),
    );

    this.results.push(suite);
  }

  async runSimpleWebFetchTests(): Promise<void> {
    const suite: TestSuite = { name: "simpleWebFetch", tests: [] };

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Fetches raw markdown content",
        async () =>
          this.callTool("simpleWebFetch", { url: "https://example.com" }),
        (r) => {
          if (r.isError) throw new Error("Tool returned error");
          return r.content.length > 0 && !("title" in r.content[0]);
        },
      ),
    );

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Returns plain text for known extensions",
        async () =>
          this.callTool("simpleWebFetch", {
            url: "https://example.com/data.json",
          }),
        (r) => {
          if (r.isError) throw new Error("Tool returned error");
          const sc = r.structuredContent as { fileType?: string } | null;
          return sc != null && sc.fileType === "plain-text";
        },
      ),
    );

    this.results.push(suite);
  }

  async runSaveWebFetchTests(): Promise<void> {
    const testDir = "test-output-save";
    const cleanup = async () => {
      try {
        await fs.rm(testDir, { recursive: true, force: true });
      } catch {}
    };

    const suite: TestSuite = { name: "saveWebFetch", tests: [] };

    // Setup
    await cleanup();
    await fs.mkdir(testDir, { recursive: true });

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Saves to explicit filename",
        async () =>
          this.callTool("saveWebFetch", {
            url: "https://example.com",
            outputPath: `${testDir}/explicit-page.md`,
          }),
        (r) => {
          if (r.isError) throw new Error(JSON.stringify(r.content));
          const text = r.content.map((c) => c.text).join("");
          return text.includes("explicit-page.md");
        },
      ),
    );

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Generates filename from title",
        async () =>
          this.callTool("saveWebFetch", {
            url: "https://example.com",
            outputPath: testDir,
          }),
        (r) => {
          if (r.isError) throw new Error(JSON.stringify(r.content));
          const text = r.content.map((c) => c.text).join("");
          return text.includes(".md");
        },
      ),
    );

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Rejects absolute path",
        async () =>
          this.callTool("saveWebFetch", {
            url: "https://example.com",
            outputPath: "/absolute/path.md",
          }),
        (r) => r.isError === true,
      ),
    );

    // Cleanup
    await cleanup();

    this.results.push(suite);
  }

  async runCrawlWebFetchTests(): Promise<void> {
    const testDir = "test-output-crawl";
    const cleanup = async () => {
      try {
        await fs.rm(testDir, { recursive: true, force: true });
      } catch {}
    };

    const suite: TestSuite = { name: "crawlWebFetch", tests: [] };

    // Setup
    await cleanup();
    await fs.mkdir(testDir, { recursive: true });

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Crawls with wildcard pattern",
        async () =>
          this.callTool("crawlWebFetch", {
            pattern: "https://example.com/*",
            outputPath: testDir,
          }),
        (r) => {
          if (r.isError) throw new Error(JSON.stringify(r.content));
          const sc = r.structuredContent as {
            totalPages?: number;
            saved?: number;
            failed?: number;
          } | null;
          return (
            sc != null &&
            typeof sc.totalPages === "number" &&
            typeof sc.saved === "number" &&
            typeof sc.failed === "number"
          );
        },
      ),
    );

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Crawls direct URL (no wildcard)",
        async () =>
          this.callTool("crawlWebFetch", {
            pattern: "https://example.com/",
            outputPath: testDir,
          }),
        (r) => {
          if (r.isError) throw new Error(JSON.stringify(r.content));
          return r.structuredContent != null;
        },
      ),
    );

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Rejects invalid pattern",
        async () =>
          this.callTool("crawlWebFetch", {
            pattern: "not-a-url",
            outputPath: testDir,
          }),
        (r) => r.isError === true,
      ),
    );

    // Cleanup
    await cleanup();

    this.results.push(suite);
  }

  async runAskWebFetchTests(): Promise<void> {
    const suite: TestSuite = { name: "askWebFetch", tests: [] };

    suite.tests.push(
      await this.runTest(
        suite.name,
        "Returns error when PERPLEXITY_API_KEY not set",
        async () =>
          this.callTool("askWebFetch", {
            url: "https://example.com",
            prompt: "test",
          }),
        (r) =>
          r.isError === true &&
          r.content[0]?.text.includes("PERPLEXITY_API_KEY"),
      ),
    );

    this.results.push(suite);
  }

  printSummary(): void {
    console.log(blue("\n" + "=".repeat(60)));
    console.log(blue("📊 Test Summary"));
    console.log(blue("=".repeat(60)));

    let totalTests = 0;
    let passedTests = 0;

    for (const suite of this.results) {
      const suitePassed = suite.tests.filter((t) => t.passed).length;
      const suiteTotal = suite.tests.length;
      totalTests += suiteTotal;
      passedTests += suitePassed;

      const status = suitePassed === suiteTotal ? green("✓") : yellow("⚠");
      console.log(
        `${status} ${suite.name}: ${suitePassed}/${suiteTotal} passed`,
      );
    }

    const overallStatus =
      passedTests === totalTests ? green("ALL PASSED") : yellow("SOME FAILED");
    console.log(blue("\n" + "=".repeat(60)));
    console.log(
      blue(`🎯 Overall: ${passedTests}/${totalTests} - ${overallStatus}`),
    );
    console.log(blue("=".repeat(60) + "\n"));
  }

  async runAll(): Promise<boolean> {
    try {
      await this.runConnectionTests();
      await this.runFullWebFetchTests();
      await this.runSimpleWebFetchTests();
      await this.runSaveWebFetchTests();
      await this.runCrawlWebFetchTests();
      await this.runAskWebFetchTests();

      this.printSummary();
      return this.results.every((s) => s.tests.every((t) => t.passed));
    } finally {
      await this.cleanup();
    }
  }
}

// Main entry point
async function main() {
  console.log(blue("\n🧪 simpleWebFetch MCP Server Test Suite"));
  console.log(blue("=".repeat(60)));

  const suite = new MCPTestSuite();
  const success = await suite.runAll();

  process.exit(success ? 0 : 1);
}

main().catch((e) => {
  console.error(red("\n💥 Fatal error:"), e.message);
  process.exit(1);
});
