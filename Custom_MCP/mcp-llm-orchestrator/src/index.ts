import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { registerGeminiTools } from "./tools/gemini.js";
import { registerPerplexityTools } from "./tools/perplexity.js";

const server = new McpServer({
  name: "mcp-llm-orchestrator",
  version: "1.2.0",
});

registerGeminiTools(server);
registerPerplexityTools(server);

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("MCP LLM Orchestrator v1.2.0 started");
}

main().catch((error) => {
  console.error("Server error:", error);
  process.exit(1);
});
