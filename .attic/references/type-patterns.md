# Type Patterns Reference

TypeScript and JavaScript type patterns and best practices.

---

## Type Safety Patterns

### Interface vs Type

**Use interface for**:
- Object shapes
- Class contracts
- Extensible types

```typescript
interface User {
  id: string
  name: string
  email: string
}

interface Admin extends User {
  permissions: string[]
}
```

**Use type for**:
- Unions
- Intersections
- Utility types
- Derived types

```typescript
type Status = 'active' | 'inactive' | 'pending'
type ID = string | number
type UserWithRole = User & { role: string }
```

### Utility Patterns

**Extract types from values**:
```typescript
const apiConfig = {
  baseUrl: 'https://api.example.com',
  timeout: 5000,
  retries: 3
} as const

type ApiConfig = typeof apiConfig
// { readonly baseUrl: string; readonly timeout: number; readonly retries: number }
```

**Pick and Omit**:
```typescript
type PublicUser = Pick<User, 'id' | 'name'>
type CreateUserInput = Omit<User, 'id'>
```

**Partial and Required**:
```typescript
type PartialUser = Partial<User>        // All fields optional
type RequiredUser = Required<User>      // All fields required
```

### Generic Patterns

**Generic functions**:
```typescript
function identity<T>(value: T): T {
  return value
}

function first<T>(items: T[]): T | undefined {
  return items[0]
}
```

**Generic with constraints**:
```typescript
function length<T extends { length: number }>(item: T): number {
  return item.length
}
```

### Discriminated Unions

**Pattern for type-safe state**:
```typescript
type State =
  | { status: 'loading' }
  | { status: 'success'; data: User }
  | { status: 'error'; error: Error }

function handleState(state: State) {
  switch (state.status) {
    case 'loading':
      // TypeScript knows there's no data/error
      break
    case 'success':
      // TypeScript knows state.data exists
      console.log(state.data)
      break
    case 'error':
      // TypeScript knows state.error exists
      console.error(state.error)
      break
  }
}
```

### Branding for Type Safety

**Prevent mixing similar types**:
```typescript
type UserId = string & { readonly __brand: 'UserId' }
type Email = string & { readonly __brand: 'Email' }

function createUserId(id: string): UserId {
  return id as UserId
}

function sendEmail(to: Email, message: string) {
  // ...
}

// Type error: can't pass UserId where Email expected
sendEmail(createUserId('123'), 'hello')
```

## Type Guards

### typeof guards

```typescript
function isString(value: unknown): value is string {
  return typeof value === 'string'
}

function process(value: unknown) {
  if (isString(value)) {
    // TypeScript knows value is string
    console.log(value.toUpperCase())
  }
}
```

### in guards

```typescript
interface Cat {
  meow(): void
}

interface Dog {
  bark(): void
}

function isCat(animal: Cat | Dog): animal is Cat {
  return 'meow' in animal
}
```

### instanceof guards

```typescript
class ValidationError extends Error {
  constructor(public field: string, message: string) {
    super(message)
  }
}

function isValidationError(error: unknown): error is ValidationError {
  return error instanceof ValidationError
}
```

## Type Inference Patterns

### Generic inference

```typescript
// TypeScript infers T from arguments
function createPair<T>(first: T, second: T): [T, T] {
  return [first, second]
}

const pair = createPair(1, 2) // [number, number]
```

### Return type inference

```typescript
// Use ReturnType to extract return type
function getUser() {
  return { id: '1', name: 'Alice' }
}

type User = ReturnType<typeof getUser>
```

## Async Type Patterns

### Promise types

```typescript
async function fetchData(): Promise<Data> {
  return { value: 42 }
}

// Awaited type (TypeScript 5.5+)
type ResolvedData = Awaited<Promise<Data>>
```

### Async function types

```typescript
type AsyncResult<T, E = Error> = Promise<Result<T, E>>

async function fetchUser(): AsyncResult<User> {
  return { success: true, data: { id: '1' } }
}
```

## Type Definitions for APIs

### Request/Response types

```typescript
interface CreateMarketRequest {
  name: string
  description: string
  endDate: string
}

interface MarketResponse {
  success: boolean
  data?: Market
  error?: string
}
```

### API client with types

```typescript
class ApiClient {
  async post<T>(url: string, body: unknown): Promise<T> {
    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body)
    })
    return response.json()
  }
}

const client = new ApiClient()
const market = await client.post<MarketResponse>('/api/markets', marketData)
```

## Zod Integration

### Runtime type validation

```typescript
import { z } from 'zod'

const MarketSchema = z.object({
  id: z.string(),
  name: z.string().min(1).max(200),
  status: z.enum(['active', 'inactive', 'closed'])
})

type Market = z.infer<typeof MarketSchema>

function validateMarket(data: unknown): Market {
  return MarketSchema.parse(data)
}
```

### Safe parsing

```typescript
function safeParse<T>(schema: z.ZodSchema<T>, data: unknown): T | null {
  const result = schema.safeParse(data)
  return result.success ? result.data : null
}
```
