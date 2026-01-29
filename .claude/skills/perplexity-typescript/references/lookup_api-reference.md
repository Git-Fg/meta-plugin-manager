# API Reference

## Navigation

| If you need...          | Read...                            |
| :---------------------- | :--------------------------------- |
| Client configuration    | ## REFERENCE: Client Constructor   |
| Search API interface    | ## REFERENCE: Search API           |
| Chat completions API    | ## REFERENCE: Chat Completions API |
| Content API interface   | ## REFERENCE: Content API          |
| Responses API interface | ## REFERENCE: Responses API        |
| Async chat API          | ## REFERENCE: Async Chat API       |
| Error types             | ## REFERENCE: Error Types          |

## Critical Read

<critical_read>
FIRST: Scan the navigation table above for the API section you need.
KEY PATTERN: TypeScript interfaces for Perplexity SDK methods.
COMMON MISTAKE: Using incorrect parameter names—check the exact interface definitions.
REMEMBER: This reference contains the full source truth—read it, don't rely on summaries elsewhere.
</critical_read>

## REFERENCE: Client Constructor

```ts
interface PerplexityOptions {
  apiKey?: string;
  baseURL?: string;
  timeout?: number; // milliseconds
  maxRetries?: number;
  fetch?: typeof fetch;
  fetchOptions?: {
    proxy?: string;
    [key: string]: unknown;
  };
  logLevel?: "debug" | "info" | "warn" | "error" | "off";
  logger?: Logger;
}

class Perplexity {
  constructor(options: PerplexityOptions);
}
```

## REFERENCE: Search API

### client.search.create

```ts
interface SearchCreateParams {
  query: string | string[];
  maxResults?: number;
  searchDomainFilter?: string[];
  searchRecencyFilter?: "day" | "week" | "month" | "year";
  searchAfterDateFilter?: string; // MM/DD/YYYY
  searchBeforeDateFilter?: string;
  searchMode?: "web" | "academic";
  userLocationFilter?: {
    latitude: number;
    longitude: number;
    radius: number; // km
  };
}

interface SearchResult {
  title: string;
  url: string;
  description: string;
  domain: string;
  publishedDate?: string;
}

interface SearchCreateResponse {
  results: SearchResult[];
  searchId: string;
}
```

## REFERENCE: Chat Completions API

### client.chat.completions.create

```ts
interface ChatCompletionCreateParams {
  messages: Array<{
    role: "user" | "assistant" | "system";
    content: string;
  }>;
  model: "sonar" | "sonar-pro" | string;
  stream?: boolean;
  temperature?: number;
  maxTokens?: number;
}

interface ChatCompletionResponse {
  content: string;
  id: string;
  model: string;
  usage?: {
    promptTokens: number;
    completionTokens: number;
    totalTokens: number;
  };
}
```

## REFERENCE: Content API

### client.content.create

```ts
interface ContentCreateParams {
  urls: string[];
}

interface ContentCreateResponse {
  contents: Array<{
    url: string;
    title: string;
    text: string;
    summary?: string;
  }>;
}
```

## REFERENCE: Responses API

### client.responses.create

```ts
interface ResponsesCreateParams {
  input: InputItem[];
  model?: string;
  tools?: FunctionTool[];
  maxOutputTokens?: number;
  temperature?: number;
}

interface FunctionTool {
  type: "function";
  function: {
    name: string;
    description?: string;
    parameters?: Record<string, unknown>;
  };
}

interface ResponseCreateResponse {
  output: OutputItem[];
  usage?: ResponsesUsage;
}
```

## REFERENCE: Async Chat API

### client.async.chat.completions

```ts
interface AsyncChatCreateParams {
  messages: Array<{
    role: "user" | "assistant" | "system";
    content: string;
  }>;
  model: string;
  stream?: boolean;
}

interface CompletionListResponse {
  data: Array<{
    id: string;
    status: string;
    createdAt: string;
  }>;
}

interface CompletionGetResponse {
  id: string;
  status: "pending" | "completed" | "failed";
  result?: ChatCompletionResponse;
}
```

## REFERENCE: Error Types

```ts
class APIError extends Error {
  status: number;
  name: string;
  headers: Record<string, string>;
}

class BadRequestError extends APIError {}
class AuthenticationError extends APIError {}
class PermissionDeniedError extends APIError {}
class NotFoundError extends APIError {}
class UnprocessableEntityError extends APIError {}
class RateLimitError extends APIError {}
class InternalServerError extends APIError {}
class APIConnectionError extends Error {}
class APIConnectionTimeoutError extends APIError {}
```

---

## Absolute Constraints

<critical_constraint>
MANDATORY: Use exact interface parameter names—TypeScript will fail at compile time if incorrect.
MANDATORY: Handle APIError and its subclasses for proper error reporting.
MANDATORY: Check rate limits when making multiple requests.
FORBIDDEN: Summary sections—create spoilers that let agents skip reading the actual content.
</critical_constraint>
