# Security Patterns Reference

Security patterns, authentication, and data protection for backend development.

---

## Input Validation

### Never Trust User Input

**WHY**: SQL injection, XSS, command injection are real threats.

```typescript
// BAD: Direct string concatenation (SQL injection risk)
const query = `SELECT * FROM users WHERE name = '${userName}'`

// GOOD: Parameterized query
const query = 'SELECT * FROM users WHERE name = $1'
await db.query(query, [userName])
```

### Schema Validation with Zod

```typescript
import { z } from 'zod'

const CreateUserSchema = z.object({
  email: z.string().email(),
  password: z.string().min(12).regex(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/),
  age: z.number().min(18).max(120)
})

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const validated = CreateUserSchema.parse(body)
    // Safe to use validated data
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json({
        success: false,
        error: 'Invalid input',
        details: error.errors
      }, { status: 400 })
    }
  }
}
```

### Sanitize Output

```typescript
import DOMPurify from 'dompurify'

export function sanitizeHTML(html: string): string {
  return DOMPurify.sanitize(html, {
    ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'a'],
    ALLOWED_ATTR: ['href']
  })
}
```

---

## Password Security

### Hashing with bcrypt

**WHY**: Hashing prevents password exposure even if DB is compromised.

```typescript
import bcrypt from 'bcrypt'

async function hashPassword(password: string): Promise<string> {
  const saltRounds = 10
  return bcrypt.hash(password, saltRounds)
}

async function verifyPassword(password: string, hash: string): Promise<boolean> {
  return bcrypt.compare(password, hash)
}

// Usage
const hashedPassword = await hashPassword(userPassword)
const isValid = await verifyPassword(inputPassword, hashedPassword)
```

### Password Requirements

```typescript
const PasswordSchema = z.string()
  .min(12, 'Password must be at least 12 characters')
  .regex(
    /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/,
    'Password must contain uppercase, lowercase, number, and special character'
  )
```

---

## Authentication Patterns

### JWT Token Management

```typescript
import jwt from 'jsonwebtoken'

interface JWTPayload {
  userId: string
  email: string
  role: string
  iat?: number
  exp?: number
}

export function generateToken(payload: JWTPayload): string {
  return jwt.sign(payload, process.env.JWT_SECRET!, {
    expiresIn: '1h'
  })
}

export function verifyToken(token: string): JWTPayload {
  try {
    return jwt.verify(token, process.env.JWT_SECRET!) as JWTPayload
  } catch (error) {
    throw new UnauthorizedError('Invalid token')
  }
}
```

### Token Refresh Pattern

```typescript
interface TokenPair {
  accessToken: string
  refreshToken: string
}

export function generateTokenPair(user: User): TokenPair {
  const accessToken = jwt.sign(
    { userId: user.id, role: user.role },
    process.env.JWT_SECRET!,
    { expiresIn: '15m' }
  )

  const refreshToken = jwt.sign(
    { userId: user.id },
    process.env.REFRESH_SECRET!,
    { expiresIn: '7d' }
  )

  return { accessToken, refreshToken }
}
```

---

## Authorization Patterns

### Role-Based Access Control (RBAC)

```typescript
type Role = 'admin' | 'moderator' | 'user'

type Permission = 'read' | 'write' | 'delete' | 'admin'

const rolePermissions: Record<Role, Permission[]> = {
  admin: ['read', 'write', 'delete', 'admin'],
  moderator: ['read', 'write', 'delete'],
  user: ['read', 'write']
}

export function hasPermission(user: User, permission: Permission): boolean {
  return rolePermissions[user.role].includes(permission)
}

export function requirePermission(permission: Permission) {
  return (handler: (req: NextRequest, user: User) => Promise<Response>) => {
    return async (req, user) => {
      if (!hasPermission(user, permission)) {
        throw new ForbiddenError('Insufficient permissions')
      }
      return handler(req, user)
    }
  }
}
```

### Resource-Based Access Control

```typescript
async function canAccessMarket(user: User, marketId: string): Promise<boolean> {
  const market = await db.market.findUnique({
    where: { id: marketId }
  })

  if (!market) return false

  // Admin can access all
  if (user.role === 'admin') return true

  // Users can only access their own markets
  if (market.creatorId === user.id) return true

  return false
}
```

---

## API Security

### Rate Limiting

```typescript
class RateLimiter {
  private requests = new Map<string, number[]>()

  checkLimit(identifier: string, maxRequests: number, windowMs: number): boolean {
    const now = Date.now()
    const requests = this.requests.get(identifier) || []
    const recentRequests = requests.filter(time => now - time < windowMs)

    if (recentRequests.length >= maxRequests) {
      return false // Rate limit exceeded
    }

    recentRequests.push(now)
    this.requests.set(identifier, recentRequests)
    return true
  }
}

const limiter = new RateLimiter()

export async function GET(request: NextRequest) {
  const ip = request.headers.get('x-forwarded-for') || 'unknown'

  if (!limiter.checkLimit(ip, 100, 60000)) {
    return NextResponse.json({
      error: 'Rate limit exceeded'
    }, { status: 429 })
  }

  // Continue with request
}
```

### CORS Configuration

```typescript
// next.config.js
module.exports = {
  async headers() {
    return [
      {
        source: process.env.ALLOWED_ORIGIN,
        headers: [
          { key: 'Access-Control-Allow-Credentials', value: 'true' },
          { key: 'Access-Control-Allow-Origin', value: process.env.ALLOWED_ORIGIN },
          { key: 'Access-Control-Allow-Methods', value: 'GET,POST,PUT,DELETE,OPTIONS' },
          { key: 'Access-Control-Allow-Headers', value: 'Content-Type,Authorization' },
        ],
      },
    ]
  },
}
```

---

## Data Protection

### Environment Variables

```typescript
// .env.local (never commit this)
DATABASE_URL=postgresql://user:pass@host:5432/db
JWT_SECRET=your-secret-key-here
API_KEY=sk-1234567890

// .env.example (safe to commit)
DATABASE_URL=postgresql://user:pass@host:5432/db
JWT_SECRET=your-secret-key-here
API_KEY=sk-1234567890
```

### Secrets Management

```typescript
// Use environment variables, never hardcode secrets
const dbUrl = process.env.DATABASE_URL
if (!dbUrl) {
  throw new Error('DATABASE_URL environment variable is required')
}
```

### Sensitive Data Logging

```typescript
// BAD: Logs sensitive data
console.log('User login:', { email, password, apiKey })

// GOOD: Logs only non-sensitive data
console.log('User login:', { email, userId })

// BETTER: Don't log emails at all for PII
console.log('User login:', { userId })
```

---

## SQL Injection Prevention

### Parameterized Queries

```typescript
// BAD: SQL injection vulnerability
const name = req.body.name
const query = `SELECT * FROM users WHERE name = '${name}'`
await db.$queryRaw(query)

// GOOD: Parameterized query
const name = req.body.name
const query = 'SELECT * FROM users WHERE name = $1'
await db.$queryRaw(query, [name])

// GOOD: Prisma (automatically parameterized)
const users = await prisma.user.findMany({
  where: { name: req.body.name }
})
```

---

## XSS Prevention

### Output Encoding

```typescript
import DOMPurify from 'dompurify'

function renderUserInput(input: string): string {
  // Sanitize HTML to prevent XSS
  return DOMPurify.sanitize(input, {
    ALLOWED_TAGS: ['b', 'i', 'em', 'strong'],
    ALLOWED_ATTR: []
  })
}
```

### Content Security Policy

```typescript
// next.config.js
const ContentSecurityPolicy = `
  default-src 'self';
  script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net;
  style-src 'self' 'unsafe-inline';
  img-src 'self' data: https:;
  font-src 'self' data:;
`

module.exports = {
  async headers() {
    return [
      {
        source: '/:path*',
        headers: {
          'Content-Security-Policy': ContentSecurityPolicy.replace(/\s{2,}/g, ' ').trim()
        }
      }
    ]
  }
}
```

---

## Security Best Practices Checklist

Before considering code secure:

- [ ] All input is validated (use Zod/Joi)
- [ ] Passwords are hashed (bcrypt/argon2)
- [ ] JWT secrets are in environment variables
- [ ] SQL injection prevented (parameterized queries)
- [ ] XSS prevented (output encoding)
- [ ] CORS configured correctly
- [ ] Rate limiting implemented
- [ ] Sensitive data never logged
- [ ] HTTPS enforced in production
- [ ] Security headers configured (CSP, HSTS, etc.)

---

## Security Headers

### Required Security Headers

```typescript
// next.config.js
const securityHeaders = [
  {
    key: 'X-DNS-Prefetch-Control',
    value: 'on'
  },
  {
    key: 'Strict-Transport-Security',
    value: 'max-age=63072000; includeSubDomains; preload'
  },
  {
    key: 'X-Frame-Options',
    value: 'DENY'  // Prevent clickjacking
  },
  {
    key: 'X-Content-Type-Options',
    value: 'nosniff'
  },
  {
    key: 'X-XSS-Protection',
    value: '1; mode=block'
  },
  {
    key: 'Referrer-Policy',
    value: 'strict-origin-when-cross-origin'
  },
  {
    key: 'Permissions-Policy',
    value: 'camera=(), microphone=(), geolocation=()'
  }
]

module.exports = {
  async headers() {
    return [
      {
        source: '/:path*',
        headers: securityHeaders
      }
    ]
  }
}
```
