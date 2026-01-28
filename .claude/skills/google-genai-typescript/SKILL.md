# Google GenAI TypeScript Development

<mission_control>
<objective>Enable optimal usage of the Google GenAI SDK (@google/genai) in TypeScript projects, covering installation, API capabilities, and 2026 best practices</objective>
<success_criteria>Claude can create production-ready Google GenAI integrations with proper error handling, streaming, multimodal support, and best practices</success_criteria>
</mission_control>

<trigger>When writing TypeScript code that integrates with Google's GenAI SDK for Gemini models, including Vertex AI support, multimodal capabilities, or agent workflows</trigger>

## Quick Start

Install the SDK with Bun:

```bash
bun add @google/genai@latest
```

Basic client setup for Gemini Developer API:

```ts
import { GoogleGenAI } from "@google/genai";

const ai = new GoogleGenAI({
  apiKey: process.env.GEMINI_API_KEY,
});
```

For Vertex AI (enterprise):

```ts
const ai = new GoogleGenAI({
  vertexai: true,
  project: process.env.GOOGLE_CLOUD_PROJECT,
  location: process.env.GOOGLE_CLOUD_LOCATION,
});
```

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

<freshness_gate>
<purpose>Validate URL freshness before trusting documentation</purpose>

<rule>

**Freshness Gate:** Before trusting any code snippets from a URL:

1. Fetch the URL and check for last-updated metadata (Last-Modified header, date in content, or commit history)
2. If content is > 6 months old, search for a more recent version before using the code
3. Prefer npm package version checks and CHANGELOG over README URLs for SDK changes
4. Document the freshness check result in the session

</rule>

<exception>

Skip freshness check when:

- Checking npm package version (timestamp IS the version)
- Official SDK changelog confirms API stability
- Versioned documentation URLs (e.g., /v1/, /2026/)

</exception>

<freshness_check>

```bash
# Check npm package version and date
npm view @google/genai time

# Check GitHub file last commit
gh api repos/googleapis/js-genai/commits?path=README.md --jq '.[0].commit.author.date'
```

</freshness_check>

</freshness_gate>

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

**NEVER copy documentation from URLs.** Instead: fetch the URL, identify current API syntax, apply directly to local files. Do not store documentation in the session.

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
MANDATORY: Use ai.chats for simple conversations, ai.interactions for agents
MANDATORY: Handle errors with instanceof checks before accessing properties
MANDATORY: Use responseMimeType + responseSchema for structured outputs
No exceptions. Production code requires proper error handling and security practices.
</critical_constraint>
