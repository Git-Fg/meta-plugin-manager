# Streaming Patterns

Guide to streaming responses from Perplexity Chat Completions API.

## Basic Streaming

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

## Chunk Structure

```ts
interface StreamChunk {
  id: string;
  object: "chat.completion.chunk";
  created: number;
  model: string;
  choices: Array<{
    index: number;
    delta: {
      role?: string;
      content?: string;
    };
    finishReason?: string;
  }>;
}
```

## Accumulating Response

```ts
let fullText = "";

const stream = await client.chat.completions.create({
  messages: [{ role: "user", content: "Write a story" }],
  model: "sonar",
  stream: true,
});

for await (const chunk of stream) {
  const content = chunk.choices[0]?.delta?.content;
  if (content) {
    fullText += content;
    // Send to client/UI incrementally
    process.stdout.write(content);
  }
}

console.log("\n\nFull response:", fullText);
```

## Aborting Stream

```ts
const stream = await client.chat.completions.create({
  messages: [{ role: "user", content: "Write a long story" }],
  model: "sonar",
  stream: true,
});

let characterCount = 0;
const maxCharacters = 5000;

for await (const chunk of stream) {
  const content = chunk.choices[0]?.delta?.content;
  if (content) {
    characterCount += content.length;
    if (characterCount >= maxCharacters) {
      stream.controller.abort();
      break;
    }
  }
}
```

## Stream with Timeout

```ts
const stream = await client.chat.completions.create({
  messages: [{ role: "user", content: "Explain everything" }],
  model: "sonar",
  stream: true,
});

const timeout = setTimeout(() => {
  stream.controller.abort();
}, 30000); // 30 second timeout

try {
  for await (const chunk of stream) {
    console.log(chunk.choices[0]?.delta?.content);
  }
} catch (err) {
  if (err.name === "AbortError") {
    console.log("Stream aborted due to timeout");
  }
} finally {
  clearTimeout(timeout);
}
```

## Streaming Considerations

| Scenario                             | Recommendation         |
| ------------------------------------ | ---------------------- |
| UI typewriter effect                 | Use streaming          |
| Need full response before processing | Use non-streaming      |
| May abort early based on content     | Use streaming          |
| High-latency environment             | Use streaming          |
| Batch processing                     | Use non-streaming      |
| Rate-limited API                     | Consider non-streaming |
