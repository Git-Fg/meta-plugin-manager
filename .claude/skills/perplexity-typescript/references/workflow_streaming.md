# Streaming Patterns

## Navigation

| If you need...         | Read...                            |
| :--------------------- | :--------------------------------- |
| Basic streaming        | ## WORKFLOW: Basic Streaming       |
| Chunk structure        | ## WORKFLOW: Chunk Structure       |
| Accumulating responses | ## WORKFLOW: Accumulating Response |
| Aborting streams       | ## WORKFLOW: Aborting Stream       |
| Timeout handling       | ## WORKFLOW: Stream with Timeout   |

## Critical Read

<critical_read>
FIRST: Scan the navigation table above for your streaming workflow.
KEY PATTERN: Async iteration for incremental response handling.
COMMON MISTAKE: Forgetting to handle the `finishReason`—stream may not be complete.
REMEMBER: This reference contains the full source truth—read it, don't rely on summaries elsewhere.
</critical_read>

## WORKFLOW: Basic Streaming

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

## WORKFLOW: Chunk Structure

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

## WORKFLOW: Accumulating Response

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

## WORKFLOW: Aborting Stream

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

## WORKFLOW: Stream with Timeout

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

---

## Absolute Constraints

<critical_constraint>
MANDATORY: Check `finishReason` to know when stream is complete—don't assume more chunks coming.
MANDATORY: Always call `controller.abort()` to terminate—orphaned streams consume resources.
MANDATORY: Handle AbortError when aborting streams—expected behavior, not an exception.
FORBIDDEN: Summary sections—create spoilers that let agents skip reading the actual content.
</critical_constraint>
