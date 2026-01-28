# API Patterns Reference

<fetch_protocol>
**MANDATORY FETCH**: Before designing REST APIs, fetch from:

- https://restfulapi.net/ (REST principles and constraints)
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Status (HTTP status codes)

**CONDITIONAL FETCH**: Fetch https://swagger.io/docs/specification/ only when documenting APIs with OpenAPI.

This reference contains Seed System-specific implementation patterns and Next.js examples.
</fetch_protocol>

---

## Seed System API Conventions

### Response Format Standard

All API responses use consistent structure:

```typescript
// Success response
{
  success: true,
  data: T,
  meta?: {
    total?: number
    page?: number
    limit?: number
    nextCursor?: string
    hasMore?: boolean
  }
}

// Error response
{
  success: false,
  error: string,
  details?: Array<{
    field: string
    message: string
  }>
}
```

---

## Next.js App Router API Patterns

### Route Handler Structure

```typescript
// app/api/markets/route.ts
import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";

const CreateMarketSchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().min(1).max(2000),
  endDate: z.string().datetime(),
  categories: z.array(z.string()).min(1),
});

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const limit = Number(searchParams.get("limit") || "10");
  const offset = Number(searchParams.get("offset") || "0");

  const [markets, total] = await Promise.all([
    db.markets.findMany({
      take: limit,
      skip: offset,
      orderBy: { createdAt: "desc" },
    }),
    db.markets.count(),
  ]);

  return NextResponse.json({
    success: true,
    data: markets,
    meta: { total, limit, offset, hasMore: offset + markets.length < total },
  });
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const validated = CreateMarketSchema.parse(body);
    const market = await db.markets.create({ data: validated });

    return NextResponse.json(
      {
        success: true,
        data: market,
      },
      { status: 201 },
    );
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        {
          success: false,
          error: "Validation failed",
          details: error.errors.map(({ path, message }) => ({
            field: path.join("."),
            message,
          })),
        },
        { status: 400 },
      );
    }
    throw error;
  }
}
```

### Dynamic Route Handlers

```typescript
// app/api/markets/[id]/route.ts
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } },
) {
  const market = await db.markets.findUnique({
    where: { id: params.id },
  });

  if (!market) {
    return NextResponse.json(
      {
        success: false,
        error: "Market not found",
      },
      { status: 404 },
    );
  }

  return NextResponse.json({ success: true, data: market });
}

export async function PATCH(
  request: NextRequest,
  { params }: { params: { id: string } },
) {
  const body = await request.json();
  const market = await db.markets.update({
    where: { id: params.id },
    data: body,
  });

  return NextResponse.json({ success: true, data: market });
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } },
) {
  await db.markets.delete({ where: { id: params.id } });
  return new NextResponse(null, { status: 204 });
}
```

---

## Middleware Patterns

### Authentication Wrapper

```typescript
import { NextRequest, NextResponse } from "next/server";

export async function withAuth(
  handler: (request: NextRequest, user: User) => Promise<NextResponse>,
) {
  return async (request: NextRequest) => {
    const token = request.headers.get("authorization")?.replace("Bearer ", "");

    if (!token) {
      return NextResponse.json(
        {
          success: false,
          error: "Unauthorized",
        },
        { status: 401 },
      );
    }

    try {
      const user = await verifyToken(token);
      return handler(request, user);
    } catch {
      return NextResponse.json(
        {
          success: false,
          error: "Invalid token",
        },
        { status: 401 },
      );
    }
  };
}

// Usage
export const GET = withAuth(async (request, user) => {
  return NextResponse.json({ success: true, data: { user } });
});
```

### Role-Based Authorization

```typescript
export function requirePermission(permission: Permission) {
  return (
    handler: (request: NextRequest, user: User) => Promise<NextResponse>,
  ) => {
    return async (request: NextRequest) => {
      const user = await requireAuth(request);

      if (!hasPermission(user, permission)) {
        return NextResponse.json(
          {
            success: false,
            error: "Insufficient permissions",
          },
          { status: 403 },
        );
      }

      return handler(request, user);
    };
  };
}

// Usage
export const DELETE = requirePermission("delete")(async (request, user) => {
  const { id } = await request.json();
  await db.markets.delete({ where: { id } });
  return new NextResponse(null, { status: 204 });
});
```

---

## Pagination Patterns

### Cursor-Based Pagination (Recommended)

```typescript
export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const cursor = searchParams.get('cursor')
  const limit = Number(searchParams.get('limit') || '20')

  const markets = await db.markets.findMany({
    take: limit + 1,
    ...(cursor && {
      skip: 1,
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
    meta: { nextCursor, hasMore }
  })
}
```

### Offset-Based Pagination

```typescript
export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const limit = Number(searchParams.get("limit") || "20");
  const offset = Number(searchParams.get("offset") || "0");

  const [markets, total] = await Promise.all([
    db.markets.findMany({
      take: limit,
      skip: offset,
      orderBy: { createdAt: "desc" },
    }),
    db.markets.count(),
  ]);

  return NextResponse.json({
    success: true,
    data: markets,
    meta: {
      total,
      limit,
      offset,
      hasMore: offset + markets.length < total,
    },
  });
}
```

---

## CORS Configuration

### Next.js Setup

```typescript
// next.config.js
module.exports = {
  async headers() {
    return [
      {
        source: "/api/:path*",
        headers: [
          { key: "Access-Control-Allow-Credentials", value: "true" },
          {
            key: "Access-Control-Allow-Origin",
            value: process.env.ALLOWED_ORIGIN || "*",
          },
          {
            key: "Access-Control-Allow-Methods",
            value: "GET,OPTIONS,PATCH,DELETE,POST,PUT",
          },
          {
            key: "Access-Control-Allow-Headers",
            value:
              "X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version",
          },
        ],
      },
    ];
  },
};
```

### OPTIONS Handler

```typescript
export async function OPTIONS(request: NextRequest) {
  return new NextResponse(null, {
    status: 204,
    headers: {
      "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type, Authorization",
      "Access-Control-Max-Age": "86400",
    },
  });
}
```

---

## Query Parameter Patterns

### Standard Query Params

```typescript
const {
  filter, // ?status=active
  sort, // ?sort=createdAt
  order, // ?order=asc|desc
  limit, // ?limit=20
  offset, // ?offset=0
  page, // ?page=1
  search, // ?search=query
} = Object.fromEntries(searchParams);
```

### Filtering Pattern

```typescript
// Build Prisma filter from query params
const buildFilter = (searchParams: URLSearchParams) => {
  const filter: any = {};

  if (searchParams.get("status")) {
    filter.status = searchParams.get("status");
  }

  if (searchParams.get("category")) {
    filter.category = { in: searchParams.get("category")?.split(",") };
  }

  if (searchParams.get("search")) {
    filter.OR = [
      { name: { contains: searchParams.get("search") } },
      { description: { contains: searchParams.get("search") } },
    ];
  }

  return filter;
};
```

---

## Error Handling Patterns

### Standardized Error Response

```typescript
function apiError(error: unknown, status = 500) {
  console.error("API Error:", error);

  return NextResponse.json(
    {
      success: false,
      error: error instanceof Error ? error.message : "Unknown error",
    },
    { status },
  );
}

// Usage
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    // Process...
  } catch (error) {
    return apiError(error, 400);
  }
}
```

### Validation Error Format

```typescript
if (error instanceof z.ZodError) {
  return NextResponse.json(
    {
      success: false,
      error: "Validation failed",
      details: error.errors.map(({ path, message }) => ({
        field: path.join("."),
        message,
      })),
    },
    { status: 400 },
  );
}
```

---

<critical_constraint>
MANDATORY: Fetch https://restfulapi.net/ for REST principles before designing APIs
MANDATORY: Fetch https://developer.mozilla.org/en-US/docs/Web/HTTP/Status for status codes
MANDATORY: Use consistent response format (success/data/meta or success/error/details)
MANDATORY: Return 204 No Content for DELETE with no body
MANDATORY: Validate all input with Zod schemas
No exceptions. Follow Seed System conventions for consistency.
</critical_constraint>
