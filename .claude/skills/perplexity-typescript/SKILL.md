# Perplexity TypeScript Development

<mission_control>
<objective>Enable optimal usage of the Perplexity Node.js SDK in TypeScript projects, covering installation, API capabilities, and 2026 best practices</objective>
<success_criteria>Claude can create production-ready Perplexity integrations with proper error handling, streaming, and best practices</success_criteria>
</mission_control>

<trigger>When writing TypeScript code that integrates with Perplexity's Search, Chat Completions, Content, or Responses APIs</trigger>

## Quick Start

Install the Perplexity SDK with Bun:

```bash
bun add @perplexity-ai/perplexity_ai@latest
```

Basic client setup:

```ts
import Perplexity from "@perplexity-ai/perplexity_ai";

const client = new Perplexity({
  apiKey: process.env["PERPLEXITY_API_KEY"],
});
```

## Core API Capabilities

### Search API

Perform real-time web searches with rich filters:

```ts
const search = await client.search.create({
  query: "artificial intelligence trends 2025",
  maxResults: 5,
});

for (const result of search.results) {
  console.log(`${result.title}: ${result.url}`);
}
```

**Key features:**

- Multi-query search (up to 5 queries in single request)
- Domain filtering (`searchDomainFilter`)
- Date/recency filtering (`searchRecencyFilter`, `searchAfterDateFilter`, `searchBeforeDateFilter`)
- Academic mode (`searchMode: 'academic'`)
- Location-based search (`userLocationFilter`)

### Chat Completions API

Call grounded models with live web search:

```ts
const response = await client.chat.completions.create({
  messages: [
    { role: "user", content: "Tell me about the latest developments in AI" },
  ],
  model: "sonar",
});

console.log(response.content);
```

**Streaming support:**

```ts
const stream = await client.chat.completions.create({
  messages: [{ role: "user", content: "Explain quantum computing" }],
  model: "sonar",
  stream: true,
});

for await (const chunk of stream) {
  console.log(chunk);
}
```

Abort streaming with `stream.controller.abort()`.

### Content API

Parse URLs into structured content:

```ts
const content = await client.content.create({
  urls: ["https://example.com/article"],
});
```

### Responses API

Higher-level agentic responses with structured outputs:

```ts
const response = await client.responses.create({
  // ...input items, tools, options
});
```

### Async Chat Completions

Background job processing:

```ts
// Create async completion
const job = await client.async.chat.completions.create({ ... });

// List all async completions
const jobs = await client.async.chat.completions.list();

// Get specific result
const result = await client.async.chat.completions.get(apiRequest, { ... });
```

## Client Configuration

### Error Handling

Error types thrown as `APIError` subclasses:

| Status | Error Type               |
| ------ | ------------------------ |
| 400    | BadRequestError          |
| 401    | AuthenticationError      |
| 403    | PermissionDeniedError    |
| 404    | NotFoundError            |
| 422    | UnprocessableEntityError |
| 429    | RateLimitError           |
| >=500  | InternalServerError      |
| N/A    | APIConnectionError       |

Handle errors:

```ts
try {
  const search = await client.search.create({ query: "AI", maxResults: 5 });
} catch (err) {
  if (err instanceof Perplexity.APIError) {
    console.log(err.status, err.name, err.headers);
  }
}
```

### Retries

Automatic retry with exponential backoff (default: 2 retries):

```ts
// Global
const client = new Perplexity({ maxRetries: 0 });

// Per-request
await client.search.create({ query: "AI" }, { maxRetries: 5 });
```

Retries on: connection errors, 408, 409, 429, >=500.

### Timeouts

Default: 15 minutes. Configure globally or per-request:

```ts
const client = new Perplexity({ timeout: 20_000 }); // 20 seconds
await client.search.create({ query: "AI" }, { timeout: 5_000 });
```

### Logging

Controlled via `PERPLEXITY_LOG` env or `logLevel` option:

| Level | Output                                           |
| ----- | ------------------------------------------------ |
| debug | All requests/responses (includes headers/bodies) |
| info  | Info, warnings, errors                           |
| warn  | Warnings and errors (default)                    |
| error | Only errors                                      |
| off   | Disable logging                                  |

```ts
const client = new Perplexity({ logLevel: "debug" });
```

**Custom logger integration:**

```ts
import pino from "pino";
const logger = pino();

const client = new Perplexity({
  logger: logger.child({ name: "Perplexity" }),
  logLevel: "debug",
});
```

### Custom Fetch & Proxies

```ts
// Custom fetch
const client = new Perplexity({ fetch: myFetch });

// Proxy (Bun)
const client = new Perplexity({
  fetchOptions: { proxy: "http://localhost:8888" },
});
```

### Raw Response Access

```ts
const { data, response } = await client.search
  .create({ query: "AI" })
  .withResponse();

console.log(response.headers.get("X-My-Header"));
```

## Best Practices

### Query Construction

- Use specific queries: "artificial intelligence medical diagnosis accuracy 2024" over "AI medical"
- Use multi-query for comprehensive research (up to 5 queries)
- Apply appropriate filters for precision

### Concurrency & Rate Limits

```ts
const queries = ["AI", "climate", "space"];
const results = await Promise.all(
  queries.map((q) => client.search.create({ query: q, maxResults: 5 })),
);
```

The SDK automatically retries 429 errors. For tight rate limits, add delays between batches.

### Environment-Specific Configuration

**User-facing apps:** Shorter timeouts (10-30s), rely on retries.

**Background jobs:** Longer timeouts, more retries, use async API.

### Production Logging

Use `warn` or `error` in production. Avoid `debug` unless troubleshooting (logs full bodies).

### Security

Never hardcode API keys. Use environment variables or secret managers.

## Runtime Support

| Runtime                                 | Supported |
| --------------------------------------- | --------- |
| Browser (Chrome, Firefox, Safari, Edge) | Yes       |
| Node.js 20+                             | Yes       |
| Deno 1.28+                              | Yes       |
| Bun 1.0+                                | Yes       |
| Cloudflare Workers                      | Yes       |
| Vercel Edge Runtime                     | Yes       |
| Jest 28+ (node env)                     | Yes       |
| Nitro 2.6+                              | Yes       |
| React Native                            | No        |

TypeScript >= 4.9 required.

## Official Documentation URLs

Fetch from these URLs when verifying or in doubt:

| Purpose                                 | URL                                                              |
| --------------------------------------- | ---------------------------------------------------------------- |
| SDK README (installation, quickstart)   | https://github.com/perplexityai/perplexity-node                  |
| API Reference (all methods & types)     | https://github.com/perplexityai/perplexity-node/blob/main/api.md |
| npm Package (latest version, changelog) | https://www.npmjs.com/package/@perplexity-ai/perplexity_ai       |
| General API Docs (models, pricing)      | https://docs.perplexity.ai                                       |
| SDK Quickstart Guide                    | https://docs.perplexity.ai/guides/perplexity-sdk                 |
| Search Best Practices                   | https://docs.perplexity.ai/guides/search-best-practices          |
| Search Filters Guide                    | https://docs.perplexity.ai/guides/search-api/filters             |

**Verification workflow:**

1. Check npm for latest version before installation
2. Fetch API reference for type definitions
3. Consult search best practices for query optimization
4. Review general docs for model updates and pricing

## References

| If you need...     | Read...                      |
| ------------------ | ---------------------------- |
| SDK API details    | references/api-reference.md  |
| Search filters     | references/search-filters.md |
| Streaming patterns | references/streaming.md      |

---

## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

**Core Principles:**

- Map, not Script: Provide boundaries and invariants; trust the Pilot to navigate
- Explain the Why: Rationale enables adaptation to edge cases
- Infinitive Voice: "Validate," "Create," "Carry"—not "You should"
- Carry genetic code: Ensure portability in isolation
- Place constraints at bottom: Exploit recency bias
- Start with high freedom: Constrain only when justified

**Portability Invariant:** Every component MUST work in a project with ZERO `.claude/rules/` access. Components carry their own "genetic code" for context fork isolation.

**Delta Standard:** Good Component = Expert Knowledge − What Claude Already Knows. Document only the knowledge delta—what Claude wouldn't already have.

**Recognition Questions:**

- "Would this work standalone?" → Fix by adding patterns and examples
- "Would Claude know this without being told?" → Delete zero-delta content
- "Did I read the actual file, or just grep?" → Verify before claiming

---

<critical_constraint>
MANDATORY: Verify package version before installation—check npm for latest
MANDATORY: Never hardcode API keys—use environment variables
MANDATORY: Use streaming for interactive UX, non-streaming for batch processing
MANDATORY: Handle RateLimitError with exponential backoff
MANDATORY: Verify errors with instanceof checks before accessing properties
No exceptions. Production code requires proper error handling and security practices.
</critical_constraint>
