# API Patterns Reference

API design, backend patterns, and error handling best practices.

---

## RESTful API Design

### Resource-Based URLs

```
GET    /api/markets                 # List resources
GET    /api/markets/:id             # Get single resource
POST   /api/markets                 # Create resource
PUT    /api/markets/:id             # Replace resource
PATCH  /api/markets/:id             # Update resource
DELETE /api/markets/:id             # Delete resource
```

### Query Parameters for Filtering

```
GET /api/markets?status=active&sort=volume&limit=20&offset=0
```

**Common query parameters**:
- `filter` - Filter results
- `sort` - Sort field
- `order` - asc/desc
- `limit` - Results per page
- `offset` - Pagination offset
- `search` - Full-text search

### Response Format Convention

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

// Success response
return NextResponse.json({
  success: true,
  data: markets,
  meta: { total: 100, page: 1, limit: 10 }
})

// Error response
return NextResponse.json({
  success: false,
  error: 'Invalid request'
}, { status: 400 })
```

## Repository Pattern

### Abstract Data Access

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

    if (filters?.limit) {
      query = query.limit(filters.limit)
    }

    const { data, error } = await query
    if (error) throw new Error(error.message)
    return data
  }

  // Other methods...
}
```

### Service Layer Pattern

```typescript
class MarketService {
  constructor(private marketRepo: MarketRepository) {}

  async searchMarkets(query: string, limit: number = 10): Promise<Market[]> {
    // Business logic
    const embedding = await generateEmbedding(query)
    const results = await this.vectorSearch(embedding, limit)

    // Fetch full data
    const markets = await this.marketRepo.findByIds(
      results.map(r => r.id)
    )

    // Sort by similarity
    return markets.sort((a, b) => {
      const scoreA = results.find(r => r.id === a.id)?.score || 0
      const scoreB = results.find(r => r.id === b.id)?.score || 0
      return scoreA - scoreB
    })
  }

  private async vectorSearch(embedding: number[], limit: number) {
    // Vector search implementation
  }
}
```

## Database Patterns

### Query Optimization

**✅ GOOD**: Select only needed columns
```typescript
const { data } = await supabase
  .from('markets')
  .select('id, name, status')
  .eq('status', 'active')
  .order('volume', { ascending: false })
  .limit(10)
```

**❌ BAD**: Select everything
```typescript
const { data } = await supabase
  .from('markets')
  .select('*')  // Wastes bandwidth, slows queries
```

### N+1 Query Prevention

**❌ BAD**: N+1 query problem
```typescript
const markets = await getMarkets()
for (const market of markets) {
  market.creator = await getUser(market.creator_id)  // N queries
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

```typescript
async function createMarketWithPosition(
  marketData: CreateMarketDto,
  positionData: CreatePositionDto
) {
  // Use Supabase transaction
  const { data, error } = await supabase.rpc('create_market_with_position', {
    market_data: marketData,
    position_data: positionData
  })

  if (error) throw new Error('Transaction failed')
  return data
}
```

## Caching Strategies

### Redis Caching Layer

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

## Error Handling Patterns

### Centralized Error Handler

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
        const delay = Math.pow(2, i) * 1000
        await new Promise(resolve => setTimeout(resolve, delay))
      }
    }
  }

  throw lastError!
}
```

## Authentication & Authorization

### JWT Token Validation

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

### Role-Based Access Control

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

## Rate Limiting

### Simple In-Memory Rate Limiter

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
```

## API Route Example (Next.js)

```typescript
import { NextRequest, NextResponse } from 'next/server'
import { z } from 'zod'

const CreateMarketSchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().min(1).max(2000),
  endDate: z.string().datetime()
})

export async function POST(request: NextRequest) {
  try {
    // Validate request body
    const body = await request.json()
    const validated = CreateMarketSchema.parse(body)

    // Create market
    const market = await createMarket(validated)

    return NextResponse.json({
      success: true,
      data: market
    })
  } catch (error) {
    return errorHandler(error)
  }
}
```
