# MCP LLM Orchestrator

MCP server integrating research capacities through multiple LLM providers with cost optimization and multimodal support.

## Goals

| Priority | Goal                                      | Implementation                                                   |
| -------- | ----------------------------------------- | ---------------------------------------------------------------- |
| **1st**  | Integrate research capacities through LLM | Unified interface to multiple LLM providers (Perplexity, Gemini) |
| **2nd**  | Research capacity from Perplexity         | Web-grounded answers with citations via Perplexity Sonar models  |
| **3rd**  | Visual capacities                         | Image/video analysis via Gemini's multimodal models              |

## Cost Optimization Principles

Every interaction is designed to minimize cost:

- **Model selection**: Flash models for simple tasks, Pro for complex reasoning
- **Caching**: 30-minute LRU cache reduces redundant API calls
- **Cost tracking**: All calls log usage metrics to stderr
- **Batching**: Multi-query search support reduces round trips

## Architecture

```
src/
├── index.ts           # Entry point, registers all tools
└── tools/
    ├── shared.ts      # Shared types, constants, cache, cost logic
    ├── gemini.ts      # Gemini-specific tools (3 tools)
    └── perplexity.ts  # Perplexity-specific tools (4 tools)
```

## Tools

### Gemini Tools

| Tool               | Description                                       | Cost Tier |
| ------------------ | ------------------------------------------------- | --------- |
| `ask_gemini_flash` | Fast, cost-effective responses with web grounding | $         |
| `ask_gemini_pro`   | Complex reasoning with web grounding              | $$$       |
| `analyze_media`    | Image/video analysis (multimodal)                 | $ (Flash) |

### Perplexity Tools

| Tool                           | Description                          | Cost Tier |
| ------------------------------ | ------------------------------------ | --------- |
| `ask_perplexity`               | Web-grounded text answers            | $$        |
| `search_perplexity`            | Ranked web search results            | $$        |
| `ask_perplexity_with_image`    | Visual analysis with web grounding   | $$        |
| `ask_perplexity_with_document` | Document analysis with web grounding | $$        |

## Models

### Gemini

| Model                        | Input ($/1M) | Output ($/1M) | Use Case                   |
| ---------------------------- | ------------ | ------------- | -------------------------- |
| `gemini-3-flash-preview`     | $0.50        | $3.00         | Fast, simple queries       |
| `gemini-3-pro-image-preview` | $2.00        | $12.00        | Complex reasoning + search |

### Perplexity

| Model                 | Input ($/1M) | Output ($/1M) | Use Case            |
| --------------------- | ------------ | ------------- | ------------------- |
| `sonar`               | $5.00        | $15.00        | Basic web search    |
| `sonar-pro`           | $10.00       | $25.00        | Advanced web search |
| `sonar-reasoning-pro` | $20.00       | $40.00        | Deep analysis       |
| `sonar-deep-research` | $30.00       | $60.00        | Exhaustive reports  |

## Cost Tracking

All API calls log cost metrics to stderr:

```json
{
  "model": "gemini-3-flash-preview",
  "inputTokens": 150,
  "outputTokens": 45,
  "totalTokens": 195,
  "estimatedCostUsd": 0.00019,
  "cacheHit": false,
  "timestamp": 1234567890
}
```

## Setup

```bash
cd Custom_MCP/mcp-llm-orchestrator
pnpm install
pnpm build
```

### Environment Variables

```bash
# Perplexity API (optional)
PERPLEXITY_API_KEY=your_key_here

# Google Gemini API (optional)
GOOGLE_API_KEY=your_key_here
```

## Usage

### Development

```bash
pnpm dev
```

### Build

```bash
pnpm build
```

### Test

```bash
pnpm test
```

Or run tests manually:

```bash
# List all tools
npx @modelcontextprotocol/inspector --cli "node dist/index.js" --method tools/list

# Test ask_gemini_flash
npx @modelcontextprotocol/inspector --cli "node dist/index.js" \
  --method tools/call --tool-name ask_gemini_flash \
  --tool-arg 'query="What is the capital of France?"'
```

## Claude Desktop Integration

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "llm-orchestrator": {
      "command": "node",
      "args": ["/absolute/path/to/mcp-llm-orchestrator/dist/index.js"],
      "env": {
        "PERPLEXITY_API_KEY": "your_perplexity_key",
        "GOOGLE_API_KEY": "your_gemini_key"
      }
    }
  }
}
```

## License

ISC
