---
name: backend-patterns
description: Backend architecture patterns, API design, database optimization, and server-side best practices for Node.js, Express, and Next.js API routes.
---

# Backend Development Patterns

Backend architecture patterns and best practices for scalable server-side applications.

---

## Quick Navigation

| If you are... | MANDATORY READ WHEN... | File |
|---------------|------------------------|------|
| Designing APIs | CREATING APIS | `references/api-patterns.md` |
| Working with databases | DATABASE OPERATIONS | `references/database-patterns.md` |
| Handling errors | ERROR HANDLING | `references/error-patterns.md` |
| Managing security | SECURITY PATTERNS | `references/security-patterns.md` |

---

## RESTful API Design Principles

### Resource-Based URLs

**WHY**: Predictable, self-documenting, follows HTTP semantics.

```
GET    /api/markets                 # List resources
GET    /api/markets/:id             # Get single resource
POST   /api/markets                 # Create resource
PUT    /api/markets/:id             # Replace resource
PATCH  /api/markets/:id             # Update resource (partial)
DELETE /api/markets/:id             # Delete resource
```

**Query parameters for filtering**:
```
GET /api/markets?status=active&sort=volume&limit=20&offset=0
```

### Consistent Response Format

**WHY**: Predictable client handling, easier error management.

```typescript
interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
  meta?: {
    total: number
    page: number
    limit: number
  }
}
```

---

## Architecture Patterns

### Repository Pattern

**WHY**: Separates data access logic, enables testing, supports swapping implementations.

```typescript
interface MarketRepository {
  findAll(filters?: MarketFilters): Promise<Market[]>
  findById(id: string): Promise<Market | null>
  create(data: CreateMarketDto): Promise<Market>
  update(id: string, data: UpdateMarketDto): Promise<Market>
  delete(id: string): Promise<void>
}

class SupabaseMarketRepository implements MarketRepository {
  async findAll(filters?: MarketFilters): Promise<Market[]> {
    let query = supabase.from('markets').select('*')

    if (filters?.status) {
      query = query.eq('status', filters.status)
    }

    const { data, error } = await query
    if (error) throw new Error(error.message)
    return data
  }

  // Other methods...
}
```

### Service Layer Pattern

**WHY**: Encapsulates business logic, keeps controllers lean.

```typescript
class MarketService {
  constructor(private marketRepo: MarketRepository) {}

  async searchMarkets(query: string): Promise<Market[]> {
    // Business logic here
    const embedding = await generateEmbedding(query)
    const results = await this.vectorSearch(embedding)
    return this.marketRepo.findByIds(results.map(r => r.id))
  }

  private async vectorSearch(embedding: number[]): Promise<string[]> {
    // Private implementation
  }
}
```

---

## Database Patterns

### Query Optimization

**WHY**: Reduces latency, lowers database load, improves UX.

**✅ GOOD**: Select only needed columns
```typescript
const { data } = await supabase
  .from('markets')
  .select('id, name, status, volume')
  .eq('status', 'active')
  .order('volume', { ascending: false })
  .limit(10)
```

**❌ BAD**: Select everything
```typescript
const { data } = await supabase
  .from('markets')
  .select('*')  // Wastes bandwidth, slows query
```

### N+1 Query Prevention

**WHY**: N+1 queries kill performance. 1 query + N queries = N+1.

**❌ BAD**: N queries inside loop
```typescript
const markets = await getMarkets()
for (const market of markets) {
  market.creator = await getUser(market.creator_id)  // N queries!
}
```

**✅ GOOD**: Batch fetch
```typescript
const markets = await getMarkets()
const creatorIds = markets.map(m => m.creator_id)
const creators = await getUsers(creatorIds)  // 1 query
const creatorMap = new Map(creators.map(c => [c.id, c]))

markets.forEach(market => {
  market.creator = creatorMap.get(market.creator_id)
})
```

### Transaction Pattern

**WHY**: Ensures data consistency, atomic operations.

```typescript
async function createMarketWithPosition(
  marketData: CreateMarketDto,
  positionData: CreatePositionDto
): Promise<void> {
  const { error } = await supabase.rpc('create_market_with_position', {
    market_data: marketData,
    position_data: positionData
  })

  if (error) throw new Error('Transaction failed')
}
```

---

## Caching Strategies

### Redis Caching Layer

**WHY**: Reduces database load, faster responses.

```typescript
class CachedMarketRepository implements MarketRepository {
  constructor(
    private baseRepo: MarketRepository,
    private redis: RedisClient
  ) {}

  async findById(id: string): Promise<Market | null> {
    // Check cache first
    const cached = await this.redis.get(`market:${id}`)
    if (cached) {
      return JSON.parse(cached)
    }

    // Cache miss - fetch from database
    const market = await this.baseRepo.findById(id)
    if (market) {
      await this.redis.setex(`market:${id}`, 300, JSON.stringify(market))
    }

    return market
  }

  async invalidateCache(id: string): Promise<void> {
    await this.redis.del(`market:${id}`)
  }
}
```

### Cache-Aside Pattern

**WHY**: Simple, effective, handles cache failures gracefully.

```typescript
async function getMarketWithCache(id: string): Promise<Market> {
  // Try cache
  const cached = await redis.get(`market:${id}`)
  if (cached) return JSON.parse(cached)

  // Cache miss - fetch from DB
  const market = await db.markets.findUnique({ where: { id } })
  if (!market) throw new Error('Market not found')

  // Update cache
  await redis.setex(`market:${id}`, 300, JSON.stringify(market))
  return market
}
```

---

## Error Handling Patterns

### Centralized Error Handler

**WHY**: Consistent error responses, DRY principle.

```typescript
class ApiError extends Error {
  constructor(
    public statusCode: number,
    public message: string,
    public isOperational = true
  ) {
    super(message)
    Object.setPrototypeOf(this, ApiError.prototype)
  }
}

export function errorHandler(error: unknown): Response {
  if (error instanceof ApiError) {
    return NextResponse.json({
      success: false,
      error: error.message
    }, { status: error.statusCode })
  }

  if (error instanceof z.ZodError) {
    return NextResponse.json({
      success: false,
      error: 'Validation failed',
      details: error.errors
    }, { status: 400 })
  }

  console.error('Unexpected error:', error)
  return NextResponse.json({
    success: false,
    error: 'Internal server error'
  }, { status: 500 })
}
```

### Retry with Exponential Backoff

**WHY**: Handles transient failures, prevents overwhelming services.

```typescript
async function fetchWithRetry<T>(
  fn: () => Promise<T>,
  maxRetries = 3
): Promise<T> {
  let lastError: Error

  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn()
    } catch (error) {
      lastError = error as Error
      if (i < maxRetries - 1) {
        // Exponential backoff: 1s, 2s, 4s
        const delay = Math.pow(2, i) * 1000
        await new Promise(resolve => setTimeout(resolve, delay))
      }
    }
  }

  throw lastError!
}
```

---

## Authentication & Authorization

### JWT Token Validation

**WHY**: Stateless authentication, scalable.

```typescript
interface JWTPayload {
  userId: string
  email: string
  role: 'admin' | 'user'
}

export function verifyToken(token: string): JWTPayload {
  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET!) as JWTPayload
    return payload
  } catch (error) {
    throw new ApiError(401, 'Invalid token')
  }
}

export async function requireAuth(request: Request): Promise<JWTPayload> {
  const token = request.headers.get('authorization')?.replace('Bearer ', '')
  if (!token) {
    throw new ApiError(401, 'Missing authorization token')
  }
  return verifyToken(token)
}
```

### Role-Based Access Control (RBAC)

**WHY**: Enforces permissions, security by default.

```typescript
type Permission = 'read' | 'write' | 'delete' | 'admin'

interface User {
  id: string
  role: 'admin' | 'moderator' | 'user'
}

const rolePermissions: Record<User['role'], Permission[]> = {
  admin: ['read', 'write', 'delete', 'admin'],
  moderator: ['read', 'write', 'delete'],
  user: ['read', 'write']
}

export function hasPermission(user: User, permission: Permission): boolean {
  return rolePermissions[user.role].includes(permission)
}

export function requirePermission(permission: Permission) {
  return (handler: (request: Request, user: User) => Promise<Response>) => {
    return async (request: Request) => {
      const user = await requireAuth(request)
      if (!hasPermission(user, permission)) {
        throw new ApiError(403, 'Insufficient permissions')
      }
      return handler(request, user)
    }
  }
}
```

---

## Rate Limiting

### In-Memory Rate Limiter

**WHY**: Protects endpoints from abuse, simple implementation.

```typescript
class RateLimiter {
  private requests = new Map<string, number[]>()

  async checkLimit(
    identifier: string,
    maxRequests: number,
    windowMs: number
  ): Promise<boolean> {
    const now = Date.now()
    const requests = this.requests.get(identifier) || []
    const recentRequests = requests.filter(time => now - time < windowMs)

    if (recentRequests.length >= maxRequests) {
      return false
    }

    recentRequests.push(now)
    this.requests.set(identifier, recentRequests)
    return true
  }
}

const limiter = new RateLimiter()

export async function GET(request: Request) {
  const ip = request.headers.get('x-forwarded-for') || 'unknown'
  const allowed = await limiter.checkLimit(ip, 100, 60000) // 100 req/min

  if (!allowed) {
    return NextResponse.json({
      error: 'Rate limit exceeded'
    }, { status: 429 })
  }

  // Continue with request
}
```

---

## Background Jobs & Queues

### Simple Queue Pattern

**WHY**: Offload heavy tasks, don't block responses.

```typescript
class JobQueue<T> {
  private queue: T[] = []
  private processing = false

  async add(job: T): Promise<void> {
    this.queue.push(job)
    if (!this.processing) {
      this.process()
    }
  }

  private async process(): Promise<void> {
    this.processing = true

    while (this.queue.length > 0) {
      const job = this.queue.shift()!

      try {
        await this.execute(job)
      } catch (error) {
        console.error('Job failed:', error)
      }
    }

    this.processing = false
  }

  private async execute(job: T): Promise<void> {
    // Job execution logic
  }
}
```

---

## Best Practices Summary

### API Design
- [ ] Resource-based URLs (nouns, not verbs)
- [ ] Consistent response format
- [ ] Query parameters for filtering/sorting/pagination
- [ ] Proper HTTP status codes
- [ ] API versioning (/api/v1/...)

### Database
- [ ] Select only needed columns
- [ ] Prevent N+1 queries with batch fetching
- [ ] Use transactions for multi-step operations
- [ ] Add indexes for common query patterns
- [ ] Use connection pooling

### Caching
- [ ] Cache frequently accessed data
- [ ] Set appropriate TTL (not too long, not too short)
- [ ] Invalidate cache on updates
- [ ] Handle cache failures gracefully

### Error Handling
- [ ] Custom error classes with status codes
- [ ] Centralized error handler
- [ ] Retry with exponential backoff for transient failures
- [ ] Log errors for debugging
- [ ] Never expose sensitive data in errors

### Security
- [ ] Validate all input (use Zod/Joi)
- [ ] Hash passwords (bcrypt/argon2)
- [ ] Use HTTPS in production
- [ ] Implement rate limiting
- [ ] Sanitize error messages
- [ ] Use parameterized queries (prevent SQL injection)

---

## Integration with Other Skills

This skill integrates with:
- `coding-standards` - General TypeScript/JavaScript patterns
- `frontend-patterns` - API integration from client side
- `verify` - Quality gate verification

**Recognition**: "Am I following backend WHY-based patterns?" → Every pattern should have a clear rationale (performance, security, scalability).
