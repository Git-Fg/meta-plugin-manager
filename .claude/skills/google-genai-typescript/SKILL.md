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

## Official Documentation URLs

Fetch from these URLs when verifying or in doubt:

| Purpose                 | URL                                                                      |
| ----------------------- | ------------------------------------------------------------------------ |
| SDK Repository          | https://github.com/googleapis/js-genai                                   |
| SDK README              | https://github.com/googleapis/js-genai/blob/main/README.md               |
| Codegen Instructions    | https://github.com/googleapis/js-genai/blob/main/codegen_instructions.md |
| npm Package             | https://www.npmjs.com/package/@google/genai                              |
| Generated API Reference | https://googleapis.github.io/js-genai/                                   |
| Gemini API Quickstart   | https://ai.google.dev/gemini-api/docs/quickstart                         |
| Gemini API Reference    | https://ai.google.dev/api                                                |
| Vertex AI SDK Overview  | https://docs.cloud.google.com/vertex-ai/generative-ai/docs/sdks/overview |

**Verification workflow:**

1. Check npm for latest version before installation
2. Fetch codegen_instructions.md for official patterns
3. Consult API reference for type definitions
4. Review Gemini API docs for model updates and capabilities

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
