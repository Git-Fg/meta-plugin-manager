# API Reference

Complete API surface for the Perplexity Node.js SDK.

## Client Constructor

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

## Search API

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

## Chat Completions API

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

## Content API

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

## Responses API

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

## Async Chat API

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

## Error Types

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
