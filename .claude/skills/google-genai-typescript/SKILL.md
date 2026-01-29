---
name: google-genai-typescript
description: "Integrate Google GenAI SDK (@google/genai) for Gemini models in TypeScript projects. Use when building Gemini integrations, Vertex AI support, multimodal capabilities, or agent workflows. Includes SDK setup, error handling, streaming, and 2026 best practices. Not for non-TypeScript projects, Python SDK usage, or non-Gemini model integrations."
---

# Google GenAI TypeScript Development

<mission_control>
<objective>Enable optimal usage of the Google GenAI SDK (@google/genai) in TypeScript projects, covering installation, API capabilities, and 2026 best practices</objective>
<success_criteria>Claude can create production-ready Google GenAI integrations with proper error handling, streaming, multimodal support, and best practices</success_criteria>
</mission_control>

## The Path to High-Value Google GenAI Integrations

### 1. Start with the Right Client Foundation

Proper client setup determines your entire integration architecture. Choose between API key (simple) and Vertex AI (enterprise) based on your scale needs. Vertex AI provides organization-level security and billing, while API keys work well for prototypes and smaller applications.

**Why this matters:** The client configuration controls authentication, billing, and access patterns. Getting this right first prevents refactoring later.

### 2. Match API Choice to Use Case

Each API serves distinct interaction patterns:

- **Models API** for single requests and simple streaming
- **Chats API** for multi-turn conversations with local state
- **Interactions API** for server-side agents with long-running tasks
- **Files API** for large media attachments (PDFs, images, videos)
- **Caches API** for cost optimization with repeated large prompts
- **Live API** for real-time sessions with audio/video I/O

**Why this matters:** Using the correct API reduces code complexity and improves performance. Chats manage conversation history automatically. Interactions handle agent state server-side. Files avoid base64 bloat.

### 3. Use Streaming for Interactive Experiences

Streaming responses (`generateContentStream`) provide immediate feedback and better user perception. The time-to-first-token is typically milliseconds, compared to waiting for complete responses.

**Why this matters:** Users perceive streaming as faster even when total time is similar. The progressive display creates engagement and allows early termination if the response goes off-track.

### 4. Leverage Structured Outputs for Reliable Parsing

Combine `responseMimeType: "application/json"` with `responseSchema` to force JSON output matching your types. This eliminates fragile regex parsing and reduces retry loops.

**Why this matters:** Type-safe integrations require predictable output formats. Structured outputs guarantee parseable results, reducing post-processing and error handling complexity.

### 5. Handle Errors by Type, Not Message

The SDK throws typed `ApiError` subclasses. Use `instanceof` checks to distinguish between authentication failures (401), rate limits (429), and server errors (500+). Each error type requires different handling strategies.

**Why this matters:** Error messages change between versions. Error types remain stable. Type-based handling ensures your integration survives SDK updates without breaking.

### 6. Prefer Tools Over Prompt Engineering

Function calling, Google Search grounding, and code execution provide reliable capabilities that prompt engineering cannot match. These tools have structured inputs/outputs and verifiable results.

**Why this matters:** Prompt-based workarounds are fragile and model-dependent. Tools provide stable interfaces that work across model versions and reduce prompt complexity.

### 7. Optimize Cost with Caching and File Uploads

Use `ai.caches` for repeated large system prompts. Use `ai.files` for large media attachments. Caching reduces token costs by 90%+ for cached content. File uploads avoid repeated base64 encoding.

**Why this matters:** Large prompts multiply quickly in multi-turn conversations. Caching the stable portion (system instructions, context) dramatically reduces per-request costs.

### 8. Configure Model Behavior Judiciously

Avoid setting `maxOutputTokens`, `topP`, `topK` unless you have specific requirements. Avoid changing safety settings unless policy requires it. Default settings work well for most use cases.

**Why this matters:** Unnecessary configuration reduces model performance and creates maintenance burden. Default settings are tuned for general use cases. Override only when measurement shows benefit.

---

## Quick Start

**Install SDK:** `bun add @google/genai@latest`

**Set up client:** Initialize `GoogleGenAI` with API key

**Make request:** `ai.models.generateContent()`

**Why:** Google's GenAI SDK provides Gemini models with multimodal support—Vertex AI for enterprise scale.

For Vertex AI (enterprise):

```ts
const ai = new GoogleGenAI({
  vertexai: true,
  project: process.env.GOOGLE_CLOUD_PROJECT,
  location: process.env.GOOGLE_CLOUD_LOCATION,
});
```

## Operational Patterns

This skill uses these standard patterns:

- **Tracking**: Maintain visible progress for GenAI integration tasks
- **Web Fetch**: Fetch current API documentation when needed
- **Navigation**: Use LSP for TypeScript code structure understanding

## Navigation

| If you need...        | Read...                                     |
| :-------------------- | :------------------------------------------ |
| Install SDK           | ## Quick Start → Install SDK                |
| Set up client         | ## Quick Start → Set up client              |
| Make request          | ## Quick Start → Make request               |
| Core API capabilities | ## Core API Capabilities                    |
| Models API            | ## Core API Capabilities → Models API       |
| Vertex AI setup       | ## Quick Start → For Vertex AI (enterprise) |

## Core API Capabilities

### Models API

Generate content with text, images, audio, video, and documents:

```ts
const response = await ai.models.generateContent({
  model: "gemini-3-flash-preview",
  contents: "Explain AI in a few sentences.",
});

console.log(response.text);
```

**Streaming support (recommended for interactive UX):**

```ts
const stream = await ai.models.generateContentStream({
  model: "gemini-3-flash-preview",
  contents: "Write a short poem.",
});

for await (const chunk of stream) {
  process.stdout.write(chunk.text);
}
```

### Chat API

Multi-turn conversations with local state:

```ts
const chat = ai.chats.create({ model: "gemini-3-flash-preview" });

let response = await chat.sendMessage({
  message: "I have a cat named Whiskers.",
});
console.log(response.text);

response = await chat.sendMessage({ message: "What is the name of my pet?" });
console.log(response.text);
```

### Interactions API

Server-side stateful agents with long-running tasks:

```ts
const interaction = await ai.interactions.create({
  model: "gemini-2.5-flash",
  input: "Research the history of Google TPUs.",
  agent: "deep-research-pro-preview-12-2025",
  background: true, // Long-running task
});
```

### Files API

Upload large files (PDFs, images, videos) to avoid repeated base64:

```ts
const file = await ai.files.upload({ path: "/path/to/document.pdf" });
```

### Caches API

Cache large prompt prefixes for cost optimization:

```ts
const cache = await ai.caches.create({
  contents: [...largeSystemPrompt],
});
```

### Live API

Real-time sessions with text/audio/video I/O:

```ts
const session = await ai.live.connect({
  model: "gemini-2.5-flash-live",
});
```

### Batches API

Async workloads with operation polling:

```ts
const operation = await ai.models.generateVideos({
  /* ... */
});

while (!operation.done) {
  operation = await ai.operations.getVideosOperation({ operation });
}
```

## Configuration Options

### Error Handling

Error types thrown as `ApiError` subclasses:

| Status | Error Type            |
| ------ | --------------------- |
| 400    | BadRequestError       |
| 401    | AuthenticationError   |
| 403    | PermissionDeniedError |
| 429    | RateLimitError        |
| >=500  | InternalServerError   |

Handle errors:

```ts
try {
  const response = await ai.models.generateContent({
    /* ... */
  });
} catch (err) {
  if (err instanceof ApiError) {
    console.error(err.status, err.name, err.message);
  }
}
```

### Client Options

```ts
interface ClientOptions {
  apiKey?: string;
  vertexai?: boolean;
  project?: string;
  location?: string;
  apiVersion?: string; // 'v1', 'v1alpha', default: uses beta
  baseUrl?: string;
  timeout?: number;
  httpOptions?: {
    proxy?: string;
  };
  logger?: Logger;
  logLevel?: "debug" | "info" | "warn" | "error" | "off";
}
```

## Advanced Features

### Structured Outputs (JSON Schema)

```ts
const response = await ai.models.generateContent({
  model: "gemini-3-flash-preview",
  contents: "List cookie recipes.",
  config: {
    responseMimeType: "application/json",
    responseSchema: {
      type: Type.ARRAY,
      items: {
        type: Type.OBJECT,
        properties: {
          recipeName: { type: Type.STRING },
          ingredients: { type: Type.ARRAY, items: { type: Type.STRING } },
        },
      },
    },
  },
});

const recipes = JSON.parse(response.text);
```

### Thinking/Reasoning (Gemini 2.5 & 3)

**Gemini 3:**

```ts
const response = await ai.models.generateContent({
  model: "gemini-3-pro-preview",
  contents: "Solve this complex problem.",
  config: {
    thinkingConfig: {
      thinkingLevel: "LOW", // MINIMAL, LOW, MEDIUM, HIGH
    },
  },
});
```

**Gemini 2.5:**

```ts
const response = await ai.models.generateContent({
  model: "gemini-2.5-pro",
  contents: "Solve this complex problem.",
  config: {
    thinkingConfig: {
      thinkingBudget: 1024, // Min 128 for pro, 0 to disable if allowed
    },
  },
});
```

### Tools and Grounding

**Function Calling:**

```ts
const response = await ai.models.generateContent({
  model: "gemini-3-flash-preview",
  contents: "Dim the lights.",
  config: {
    tools: [
      {
        functionDeclarations: [
          {
            name: "controlLight",
            parameters: {
              type: Type.OBJECT,
              properties: {
                brightness: { type: Type.NUMBER },
                colorTemperature: { type: Type.STRING },
              },
            },
          },
        ],
      },
    ],
  },
});
```

**Google Search Grounding:**

```ts
const response = await ai.models.generateContent({
  model: "gemini-3-flash-preview",
  contents: "What was the score of the latest game?",
  config: {
    tools: [{ googleSearch: {} }],
  },
});

const metadata = response.candidates?.[0]?.groundingMetadata;
```

### Media Generation

**Image Generation:**

```ts
const response = await ai.models.generateContent({
  model: "gemini-2.5-flash-image",
  contents: "Create a nano banana dish in a fancy restaurant.",
});
```

**Video Generation (Veo):**

```ts
let operation = await ai.models.generateVideos({
  model: "veo-3.0-fast-generate-001",
  prompt: "Panning wide shot of a kitten.",
  config: { aspectRatio: "16:9" },
});
```

## Best Practices

### Security

- Never hardcode API keys—use environment variables
- For browser apps, route requests through your server

### Performance

- Use `generateContentStream` for interactive applications
- Use `ai.caches` for repeated large prompts
- Use `ai.files` for large media attachments
- Monitor `Usage` metadata for cost tracking

### Feature Usage

- Use `responseMimeType + responseSchema` for structured outputs
- Use tools (functionCalling, googleSearch, codeExecution) instead of prompt hacks
- Use `ai.chats` for simple conversations
- Use `ai.interactions` for agents and long-running workflows

### Configuration Discipline

- Avoid setting `maxOutputTokens`, `topP`, `topK` unless explicitly needed
- Avoid changing safety settings unless policy requires it

## Runtime Support

| Runtime            | Supported |
| ------------------ | --------- |
| Node.js 20+        | Yes       |
| Bun 1.0+           | Yes       |
| Deno 1.28+         | Yes       |
| Cloudflare Workers | Yes       |
| Vercel Edge        | Yes       |

## Relevance Heuristic

**Freshness Gate:** Before trusting any code snippets from a URL:

1. Fetch the URL and check for last-updated metadata (Last-Modified header, date in content, or commit history)
2. If content is > 6 months old, search for a more recent version before using the code
3. Prefer npm package version checks and CHANGELOG over README URLs for SDK changes
4. Document the freshness check result in the session

**Skip freshness check when:**

- Checking npm package version (timestamp IS the version)
- Official SDK changelog confirms API stability
- Versioned documentation URLs (e.g., /v1/, /2026/)

**Freshness Check Commands:**

```bash
# Check npm package version and date
npm view @google/genai time

# Check GitHub file last commit
gh api repos/googleapis/js-genai/commits?path=README.md --jq '.[0].commit.author.date'
```

**Protocol: Check Principles → Freshness Gate → Fetch Instance → Extract Delta → Dispose**

Before fetching any URL:

1. **Check Principles** - This skill covers installation, SDK usage, configuration, error handling, and best practices. The patterns here are stable.

2. **Freshness Gate** - Verify URL is < 6 months old. If older:
   - For SDK docs: Check npm view for package release date
   - For README changes: Check GitHub commit history
   - Search for updated version before trusting snippets

3. **Fetch Instance Only When**:
   - npm package shows new version with breaking changes
   - SDK API signature differs from documented patterns
   - New model names or capabilities not yet covered
   - Vertex AI configuration has changed

4. **Extract Delta** - Keep only what this skill doesn't cover:
   - Version-specific migration notes
   - New API methods not in examples
   - Updated model pricing or limits
   - Region-specific Vertex AI endpoints

5. **Dispose Context** - Remove fetched content after extracting delta

**Delta Pattern**: Fetch the URL, identify current API syntax, apply directly to local files. Store patterns, not documentation. Documentation becomes stale; patterns remain actionable.

**When NOT to fetch:**

- Basic SDK initialization (covered with examples)
- Error handling patterns (covered in tables)
- Streaming usage (covered with examples)
- Configuration options (covered in interfaces)
- Structured outputs (covered with examples)

**Instance Resources** (fetch only when needed, after freshness gate):

| Trigger              | URL                                                                      |
| -------------------- | ------------------------------------------------------------------------ |
| Version verification | https://www.npmjs.com/package/@google/genai                              |
| SDK API changes      | https://github.com/googleapis/js-genai/blob/main/README.md               |
| Model updates        | https://ai.google.dev/gemini-api/docs/quickstart                         |
| Vertex AI config     | https://docs.cloud.google.com/vertex-ai/generative-ai/docs/sdks/overview |

**Workflow:** Freshness check → Verify npm version → Consult skill patterns → Fetch instance docs only if behavior differs → Extract delta → Dispose

---

## Dynamic Sourcing

**Syntax Source**: This skill focuses on *patterns* and *philosophy*. For raw SDK syntax (installation, API methods, model config):

1. **Fetch**: `https://www.npmjs.com/package/@google/genai`
2. **Extract**: The specific API methods or configuration you need
3. **Discard**: Do not retain the fetch in context

**Additional Sources** (when needed):

- SDK API changes → `https://github.com/googleapis/js-genai/blob/main/README.md`
- Model updates → `https://ai.google.dev/gemini-api/docs/quickstart`
- Vertex AI config → `https://docs.cloud.google.com/vertex-ai/generative-ai/docs/sdks/overview`

---

<critical_constraint>
**Portability Invariant:** This skill must work in a project with ZERO .claude/rules/ access. All patterns and examples are self-contained.

**Security Boundary:** Never hardcode API keys in code. Use environment variables or secure secret management. For browser applications, route requests through a server to protect API keys.
</critical_constraint>
