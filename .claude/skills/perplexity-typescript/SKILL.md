---
name: perplexity-typescript
description: "Integrate Perplexity AI APIs in TypeScript projects. Use when building Perplexity Search, Chat Completions, Content, or Responses API integrations. Includes SDK setup, error handling, streaming patterns, and 2026 best practices. Not for non-TypeScript projects, server-side rendering with secrets, or manual API calls without SDK."
---

# Perplexity TypeScript Development

<mission_control>
<objective>Enable optimal usage of the Perplexity Node.js SDK in TypeScript projects, covering installation, API capabilities, and 2026 best practices</objective>
<success_criteria>Claude can create production-ready Perplexity integrations with proper error handling, streaming, and best practices</success_criteria>
</mission_control>

<trigger>When writing TypeScript code that integrates with Perplexity's Search, Chat Completions, Content, or Responses APIs</trigger>

<Guiding_Principles>

## The Path to High-Quality Perplexity Integration Success

### 1. Environment-First Security

API keys in environment variables protect credentials across all deployment environments. Environment-specific configuration enables seamless development-to-production transitions without exposing secrets.

### 2. Streaming for Responsiveness

Streaming delivers real-time responses to users, while non-streaming suits batch processing. This choice optimizes user experience for the use case.

### 3. Error Type Safety

Instanceof checks ensure type-safe error handling. Typed error access prevents runtime errors and enables precise error responses.

### 4. Retry Resilience

Exponential backoff with automatic retries handles transient failures gracefully. Rate limit awareness prevents request throttling.

### 5. Query Precision

Specific, well-constructed queries yield relevant results. Multi-query searches enable comprehensive research across multiple angles.

### 6. Production Logging Discipline

Warn/error levels in production reduce log volume. Debug logging reserved for troubleshooting prevents performance impact.

</Guiding_Principles>

## Quick Start

**Install SDK:** `bun add @perplexity-ai/perplexity_ai@latest`

**Set up client:** Initialize with API key from environment

**Make search:** `client.search.create({ query, maxResults })`

**Why:** Perplexity provides web-grounded answers with citations—ideal for research and fact-checking.

## Navigation

| If you need...     | Read...                                     |
| :----------------- | :------------------------------------------ |
| Install SDK        | ## Quick Start                              |
| Set up client      | ## Quick Start                              |
| Make search        | ## Core API Capabilities → Search API       |
| Chat completions   | ## Core API Capabilities → Chat Completions |
| API reference      | `references/lookup_api-reference.md`        |
| Search filters     | `references/pattern_search-filters.md`      |
| Streaming patterns | `references/workflow_streaming.md`          |

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

---

## Dynamic Sourcing Protocol

<fetch_protocol>
**CONDITIONAL FETCH**: For API questions, fetch from:

- https://docs.perplexity.ai (model capabilities, latest features)

This skill contains Seed System-specific Perplexity integration patterns. Version-specific API details should be fetched when needed.
</fetch_protocol>

---

## References

**Official Documentation**:

- Complete SDK API → https://github.com/perplexityai/perplexity-node/blob/main/api.md
- Model capabilities → https://docs.perplexity.ai
- Package version → https://www.npmjs.com/package/@perplexity-ai/perplexity_ai

**Local References**:

| If you need...           | Read...                      |
| ------------------------ | ---------------------------- |
| Seed System patterns     | references/api-reference.md  |
| Search filter examples   | references/search-filters.md |
| Streaming implementation | references/streaming.md      |

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
**Portability Invariant:** This skill works in projects with ZERO `.claude/rules/` access. All patterns and principles are self-contained.

**Security Boundary:** API keys MUST use environment variables—never hardcoded values. Client-side TypeScript MUST use backend proxy for secrets.
</critical_constraint>
