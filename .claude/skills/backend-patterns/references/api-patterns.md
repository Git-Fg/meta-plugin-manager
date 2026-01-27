# API Patterns Reference

API design, routing, and HTTP patterns for backend development.

---

## RESTful API Design

### Resource Naming Conventions

**Use nouns for resources, not verbs**:
```
✅ GOOD
GET    /api/users
GET    /api/users/:id
POST   /api/users
PUT    /api/users/:id
PATCH  /api/users/:id
DELETE /api/users/:id

❌ BAD
GET    /api/getUsers
POST   /api/createUser
POST   /api/users/:id/update
```

### URL Hierarchy

```
/api/v1/resource/sub-resource

Examples:
/api/v1/markets                    # All markets
/api/v1/markets/:id                # Specific market
/api/v1/markets/:id/positions       # Positions for a market
/api/v1/users/:id/orders           # Orders for a user
```

### Query Parameters

**Common query parameters**:
- `filter` - Filter results (e.g., `?status=active`)
- `sort` - Sort field (e.g., `?sort=createdAt`)
- `order` - Sort direction (e.g., `?order=asc` or `?order=desc`)
- `limit` - Results per page (e.g., `?limit=20`)
- `offset` - Pagination offset (e.g., `?offset=0`)
- `page` - Page number (alternative to offset)
- `search` - Full-text search (e.g., `?search=query`)

**Example**:
```
GET /api/markets?status=active&sort=volume&order=desc&limit=20&offset=0
```

---

## HTTP Status Codes

### Successful Responses

| Code | Meaning | Usage |
|------|---------|-------|
| 200 | OK | GET, PUT, PATCH success |
| 201 | Created | POST created resource successfully |
| 204 | No Content | DELETE success, PUT with no return data |

### Client Errors

| Code | Meaning | Usage |
|------|---------|-------|
| 400 | Bad Request | Invalid input, validation failure |
| 401 | Unauthorized | Missing or invalid authentication |
| 403 | Forbidden | Authenticated but insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Resource already exists, version conflict |
| 422 | Unprocessable Entity | Well-formed but semantic errors |
| 429 | Too Many Requests | Rate limit exceeded |

### Server Errors

| Code | Meaning | Usage |
|------|---------|-------|
| 500 | Internal Server Error | Unexpected server error |
| 502 | Bad Gateway | Upstream service error |
| 503 | Service Unavailable | Service temporarily down |

---

## API Route Patterns

### Next.js App Router API Routes

```typescript
// app/api/markets/route.ts
import { NextRequest, NextResponse } from 'next/server'

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const limit = Number(searchParams.get('limit') || '10')

  const markets = await db.markets.findMany({
    take: limit,
    orderBy: { createdAt: 'desc' }
  })

  return NextResponse.json({
    success: true,
    data: markets,
    meta: { count: markets.length, limit }
  })
}

export async function POST(request: NextRequest) {
  const body = await request.json()

  try {
    const validated = CreateMarketSchema.parse(body)
    const market = await db.markets.create({ data: validated })

    return NextResponse.json({
      success: true,
      data: market
    }, { status: 201 })
  } catch (error) {
    return errorHandler(error)
  }
}
```

### Dynamic Route Handlers

```typescript
// app/api/markets/[id]/route.ts
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const market = await db.markets.findUnique({
    where: { id: params.id }
  })

  if (!market) {
    return NextResponse.json({
      success: false,
      error: 'Market not found'
    }, { status: 404 })
  }

  return NextResponse.json({
    success: true,
    data: market
  })
}

export async function PATCH(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const body = await request.json()

  const market = await db.markets.update({
    where: { id: params.id },
    data: body
  })

  return NextResponse.json({
    success: true,
    data: market
  })
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  await db.markets.delete({
    where: { id: params.id }
  })

  return new NextResponse(null, { status: 204 })
}
```

---

## Middleware Patterns

### Authentication Middleware

```typescript
import { NextRequest, NextResponse } from 'next/server'

export async function withAuth(
  handler: (request: NextRequest, user: User) => Promise<NextResponse>
) {
  return async (request: NextRequest) => {
    const token = request.headers.get('authorization')?.replace('Bearer ', '')

    if (!token) {
      return NextResponse.json({
        success: false,
        error: 'Unauthorized'
      }, { status: 401 })
    }

    try {
      const user = await verifyToken(token)
      return handler(request, user)
    } catch (error) {
      return NextResponse.json({
        success: false,
        error: 'Invalid token'
      }, { status: 401 })
    }
  }
}

// Usage
export const GET = withAuth(async (request, user) => {
  return NextResponse.json({
    success: true,
    data: { user }
  })
})
```

### Role-Based Middleware

```typescript
export function requirePermission(permission: Permission) {
  return (
    handler: (request: NextRequest, user: User) => Promise<NextResponse>
  ) => {
    return async (request: NextRequest) => {
      const user = await requireAuth(request)

      if (!hasPermission(user, permission)) {
        return NextResponse.json({
          success: false,
          error: 'Insufficient permissions'
        }, { status: 403 })
      }

      return handler(request, user)
    }
  }
}

// Usage
export const DELETE = requirePermission('delete')(async (request, user) => {
  const { id } = await request.json()
  await db.markets.delete({ where: { id } })
  return new NextResponse(null, { status: 204 })
})
```

---

## Input Validation Patterns

### Zod Schema Validation

```typescript
import { z } from 'zod'

const CreateMarketSchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().min(1).max(2000),
  endDate: z.string().datetime(),
  categories: z.array(z.string()).min(1)
})

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const validated = CreateMarketSchema.parse(body)
    // Process validated data
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json({
        success: false,
        error: 'Validation failed',
        details: error.errors
      }, { status: 400 })
    }
  }
}
```

### Custom Validation

```typescript
function validateMarket(data: unknown): { valid: boolean; errors?: string[] } {
  const errors: string[] = []

  if (!data || typeof data !== 'object') {
    return { valid: false, errors: ['Invalid data'] }
  }

  const { name, description, endDate } = data as Record<string, unknown>

  if (!name || typeof name !== 'string' || name.length > 200) {
    errors.push('Name must be a string under 200 characters')
  }

  if (!description || typeof description !== 'string' || description.length > 2000) {
    errors.push('Description must be a string under 2000 characters')
  }

  if (endDate) {
    const date = new Date(endDate)
    if (isNaN(date.getTime())) {
      errors.push('Invalid end date')
    }
  }

  return { valid: errors.length === 0, errors: errors.length > 0 ? errors : undefined }
}
```

---

## Response Formatting

### Success Response

```typescript
return NextResponse.json({
  success: true,
  data: result,
  meta: {
    total: result.length,
    page: 1,
    limit: 20
  }
})
```

### Error Response

```typescript
return NextResponse.json({
  success: false,
  error: 'Market not found'
}, { status: 404 })
```

### Validation Error Response

```typescript
return NextResponse.json({
  success: false,
  error: 'Validation failed',
  details: [
    { field: 'name', message: 'Name is required' },
    { field: 'email', message: 'Invalid email format' }
  ]
}, { status: 400 })
```

---

## Pagination Patterns

### Offset-Based Pagination

```typescript
export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const limit = Number(searchParams.get('limit') || '20')
  const offset = Number(searchParams.get('offset') || '0')

  const [markets, total] = await Promise.all([
    db.markets.findMany({
      take: limit,
      skip: offset,
      orderBy: { createdAt: 'desc' }
    }),
    db.markets.count()
  ])

  return NextResponse.json({
    success: true,
    data: markets,
    meta: {
      total,
      limit,
      offset,
      hasMore: offset + markets.length < total
    }
  })
}
```

### Cursor-Based Pagination

```typescript
export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const cursor = searchParams.get('cursor')
  const limit = Number(searchParams.get('limit') || '20')

  const markets = await db.markets.findMany({
    take: limit + 1,
    ...(cursor && {
      skip: 1,  // Skip the cursor itself
      cursor: { id: cursor }
    },
    orderBy: { createdAt: 'desc' }
  })

  const hasMore = markets.length > limit
  const data = hasMore ? markets.slice(0, -1) : markets
  const nextCursor = hasMore ? data[data.length - 1].id : null

  return NextResponse.json({
    success: true,
    data,
    meta: {
      nextCursor,
      hasMore
    }
  })
}
```

---

## API Versioning

### URL-Based Versioning

```
/api/v1/markets  # Version 1
/api/v2/markets  # Version 2
```

### Header-Based Versioning

```typescript
export async function GET(request: NextRequest) {
  const version = request.headers.get('API-Version') || 'v1'

  switch (version) {
    case 'v1':
      return handleV1Request(request)
    case 'v2':
      return handleV2Request(request)
    default:
      return NextResponse.json({
        error: 'Unsupported API version'
      }, { status: 400 })
  }
}
```

---

## CORS Configuration

### Next.js CORS Setup

```typescript
// next.config.js
module.exports = {
  async headers() {
    return [
      {
        source: '/api/:path*',
        headers: [
          { key: 'Access-Control-Allow-Credentials', value: 'true' },
          { key: 'Access-Control-Allow-Origin', value: process.env.ALLOWED_ORIGIN || '*' },
          { key: 'Access-Control-Allow-Methods', value: 'GET,OPTIONS,PATCH,DELETE,POST,PUT' },
          { key: 'Access-Control-Allow-Headers', value: 'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version' },
        ],
      },
    ]
  },
}
```

### OPTIONS Handler

```typescript
export async function OPTIONS(request: NextRequest) {
  return new NextResponse(null, {
    status: 204,
    headers: {
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      'Access-Control-Max-Age': '86400',
    },
  })
}
```
