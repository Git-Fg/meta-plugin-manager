---
name: security
description: "Comprehensive security patterns, authentication, authorization, and data protection. Use when: implementing security features, reviewing code for vulnerabilities, handling sensitive data, creating APIs, or need OWASP best practices guidance."
user-invocable: true
---

# Security Meta-Skill

Comprehensive security patterns covering authentication, authorization, input validation, data protection, and OWASP Top 10 vulnerabilities. Apply these patterns to prevent common security vulnerabilities.

---

## Quick Navigation

| If you need... | MANDATORY READ... | File |
|----------------|-------------------|------|
| Authentication patterns | WHEN IMPLEMENTING AUTH | `references/authentication.md` |
| Input validation | WHEN HANDLING USER INPUT | `references/input-validation.md` |
| Data protection | WHEN DEALING WITH SENSITIVE DATA | `references/data-protection.md` |
| API security | WHEN BUILDING APIS | `references/api-security.md` |
| Security headers | WHEN CONFIGURING WEB APPS | `references/security-headers.md` |

---

## Core Security Principles

### 1. Never Trust User Input (CRITICAL)

**WHY**: SQL injection, XSS, command injection are real threats that compromise entire systems.

**✅ GOOD - Parameterized queries:**
```typescript
const query = 'SELECT * FROM users WHERE email = $1';
await db.query(query, [userEmail]);
```

**❌ BAD - String concatenation (SQL injection risk):**
```typescript
const query = `SELECT * FROM users WHERE email = '${userEmail}'`;
await db.query(query);
```

### 2. Defense in Depth

**WHY**: No single security measure is perfect. Layer multiple defenses.

**Layers:**
1. **Input validation** - Sanitize at entry point
2. **Authentication** - Verify user identity
3. **Authorization** - Check permissions
4. **Output encoding** - Prevent XSS
5. **Rate limiting** - Prevent abuse
6. **Audit logging** - Track security events

### 3. Principle of Least Privilege

**WHY**: Minimize damage if account is compromised.

**Apply to:**
- User permissions (only what they need)
- API keys (minimal scope)
- Database access (restricted tables)
- Service accounts (limited capabilities)

### 4. Fail Securely

**WHY**: Handle errors without revealing sensitive information.

**❌ BAD:**
```typescript
if (!user) {
  return res.status(400).json({ error: 'Invalid username OR password' });
  // Reveals which field is wrong
}
```

**✅ GOOD:**
```typescript
if (!user || !verifyPassword(password, user.hash)) {
  return res.status(401).json({ error: 'Invalid credentials' });
  // Generic error message
}
```

---

## Authentication Patterns

### JWT Token Management

**Requirements:**
- Use strong secrets (256-bit minimum)
- Set appropriate expiration times
- Validate signature and expiration
- Store securely (httpOnly cookies)

```typescript
import jwt from 'jsonwebtoken';

interface JWTPayload {
  userId: string;
  email: string;
  role: string;
  iat?: number;
  exp?: number;
}

export function generateToken(payload: JWTPayload): string {
  return jwt.sign(payload, process.env.JWT_SECRET!, {
    expiresIn: '1h',  // Short expiration
    algorithm: 'HS256'
  });
}

export function verifyToken(token: string): JWTPayload {
  try {
    return jwt.verify(token, process.env.JWT_SECRET!) as JWTPayload;
  } catch (error) {
    throw new UnauthorizedError('Invalid token');
  }
}
```

### Password Security

**Requirements:**
- Hash with bcrypt (min 12 rounds) or Argon2
- Never store plaintext passwords
- Enforce strong password policies
- Use salt (bcrypt does this automatically)

```typescript
import bcrypt from 'bcrypt';

async function hashPassword(password: string): Promise<string> {
  const saltRounds = 12;  // Minimum 12 rounds
  return bcrypt.hash(password, saltRounds);
}

async function verifyPassword(password: string, hash: string): Promise<boolean> {
  return bcrypt.compare(password, hash);
}

// Password validation
const PasswordSchema = z.string()
  .min(12, 'Password must be at least 12 characters')
  .regex(
    /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/,
    'Password must contain uppercase, lowercase, number, and special character'
  );
```

### Token Refresh Pattern

**Secure refresh token implementation:**

```typescript
interface TokenPair {
  accessToken: string;
  refreshToken: string;
}

export function generateTokenPair(user: User): TokenPair {
  const accessToken = jwt.sign(
    { userId: user.id, role: user.role },
    process.env.JWT_SECRET!,
    { expiresIn: '15m' }  // Short access token
  );

  const refreshToken = jwt.sign(
    { userId: user.id, type: 'refresh' },
    process.env.REFRESH_SECRET!,
    { expiresIn: '7d' }  // Longer refresh token
  );

  return { accessToken, refreshToken };
}
```

---

## Authorization Patterns

### Role-Based Access Control (RBAC)

**Implementation:**

```typescript
type Role = 'admin' | 'moderator' | 'user';
type Permission = 'read' | 'write' | 'delete' | 'admin';

const rolePermissions: Record<Role, Permission[]> = {
  admin: ['read', 'write', 'delete', 'admin'],
  moderator: ['read', 'write', 'delete'],
  user: ['read', 'write']
};

export function hasPermission(user: User, permission: Permission): boolean {
  return rolePermissions[user.role].includes(permission);
}

// Decorator for route protection
export function requirePermission(permission: Permission) {
  return (handler: (req: NextRequest, user: User) => Promise<Response>) => {
    return async (req, user) => {
      if (!hasPermission(user, permission)) {
        throw new ForbiddenError('Insufficient permissions');
      }
      return handler(req, user);
    };
  };
}

// Usage
export async function DELETE(request: NextRequest, user: User) {
  requirePermission('delete')(async (req, user) => {
    // Protected logic
  })(request, user);
}
```

### Resource-Based Access Control

**Example:**

```typescript
async function canAccessResource(user: User, resourceId: string): Promise<boolean> {
  const resource = await db.resource.findUnique({
    where: { id: resourceId }
  });

  if (!resource) return false;

  // Admin can access all
  if (user.role === 'admin') return true;

  // Owner can access
  if (resource.ownerId === user.id) return true;

  // Check explicit permissions
  const permission = await db.permission.findUnique({
    where: {
      resourceId_userId: {
        resourceId,
        userId: user.id
      }
    }
  });

  return permission !== null;
}
```

---

## Input Validation

### Schema Validation with Zod

**Validate all inputs:**

```typescript
import { z } from 'zod';

const CreateUserSchema = z.object({
  email: z.string().email('Invalid email format'),
  password: z.string()
    .min(12, 'Password must be at least 12 characters')
    .regex(
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/,
      'Password must contain uppercase, lowercase, number, and special character'
    ),
  age: z.number().min(18).max(120)
});

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const validated = CreateUserSchema.parse(body);

    // Safe to use validated data
    await createUser(validated);

    return NextResponse.json({ success: true });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json({
        success: false,
        error: 'Invalid input',
        details: error.errors
      }, { status: 400 });
    }

    return NextResponse.json({
      success: false,
      error: 'Internal server error'
    }, { status: 500 });
  }
}
```

### Sanitize Output

**Prevent XSS attacks:**

```typescript
import DOMPurify from 'dompurify';

export function sanitizeHTML(html: string): string {
  return DOMPurify.sanitize(html, {
    ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'a'],
    ALLOWED_ATTR: ['href']
  });
}

// For React
import sanitizeHtml from 'sanitize-html';

<div
  dangerouslySetInnerHTML={{
    __html: sanitizeHtml(userInput, {
      allowedTags: ['b', 'i', 'em', 'strong'],
      allowedAttributes: {}
    })
  }}
/>
```

---

## API Security

### Rate Limiting

**Prevent abuse:**

```typescript
class RateLimiter {
  private requests = new Map<string, number[]>();

  checkLimit(identifier: string, maxRequests: number, windowMs: number): boolean {
    const now = Date.now();
    const requests = this.requests.get(identifier) || [];

    // Remove old requests outside window
    const recentRequests = requests.filter(
      time => now - time < windowMs
    );

    if (recentRequests.length >= maxRequests) {
      return false;  // Rate limit exceeded
    }

    recentRequests.push(now);
    this.requests.set(identifier, recentRequests);
    return true;
  }
}

const limiter = new RateLimiter();

export async function POST(request: NextRequest) {
  const ip = request.headers.get('x-forwarded-for') || 'unknown';

  if (!limiter.checkLimit(ip, 100, 60000)) {  // 100 requests per minute
    return NextResponse.json({
      error: 'Rate limit exceeded'
    }, { status: 429 });
  }

  // Continue with request
}
```

### CORS Configuration

**Restrict origins:**

```typescript
// next.config.js
module.exports = {
  async headers() {
    return [
      {
        source: '/api/:path*',
        headers: [
          {
            key: 'Access-Control-Allow-Origin',
            value: process.env.ALLOWED_ORIGINS || 'https://yourdomain.com'
          },
          {
            key: 'Access-Control-Allow-Credentials',
            value: 'true'
          },
          {
            key: 'Access-Control-Allow-Methods',
            value: 'GET,POST,PUT,DELETE,OPTIONS'
          },
          {
            key: 'Access-Control-Allow-Headers',
            value: 'Content-Type,Authorization'
          }
        ]
      }
    ];
  }
};
```

---

## Data Protection

### Environment Variables

**Never commit secrets:**

```typescript
// .env.local (never commit)
DATABASE_URL=postgresql://user:password@host:5432/db
JWT_SECRET=your-256-bit-secret-key
API_KEY=sk-1234567890abcdef

// .env.example (safe to commit)
DATABASE_URL=postgresql://user:password@host:5432/db
JWT_SECRET=your-secret-key-here
API_KEY=your-api-key-here
```

### Sensitive Data Logging

**Never log sensitive data:**

```typescript
// ❌ BAD - Logs sensitive data
logger.info('User login', { email: user.email, password: user.password });

// ✅ GOOD - Logs only non-sensitive data
logger.info('User login', { userId: user.id, timestamp: new Date() });

// ✅ BETTER - Don't log PII at all
logger.info('Authentication attempt', { ip: request.ip });
```

### HTTPS Enforcement

**Always use HTTPS in production:**

```typescript
// next.config.js
const securityHeaders = [
  {
    key: 'Strict-Transport-Security',
    value: 'max-age=63072000; includeSubDomains; preload'
  }
];

module.exports = {
  async headers() {
    return [
      {
        source: '/:path*',
        headers: securityHeaders
      }
    ];
  }
};
```

---

## Security Headers

### Required Security Headers

**Configure in application:**

```typescript
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
];
```

### Content Security Policy (CSP)

**Prevent XSS:**

```typescript
const ContentSecurityPolicy = `
  default-src 'self';
  script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net;
  style-src 'self' 'unsafe-inline';
  img-src 'self' data: https:;
  font-src 'self' data:;
`;

// In next.config.js
module.exports = {
  async headers() {
    return [
      {
        source: '/:path*',
        headers: {
          'Content-Security-Policy': ContentSecurityPolicy.replace(/\s{2,}/g, ' ').trim()
        }
      }
    ];
  }
};
```

---

## OWASP Top 10 Prevention

### A01: Broken Access Control

**Prevention:**
- Implement RBAC properly
- Verify permissions on every request
- Don't rely on client-side checks
- Test authorization thoroughly

```typescript
// ✅ GOOD - Server-side authorization check
async function getUserData(request: Request, userId: string) {
  const requestingUser = await getUserFromToken(request);

  // Check if user can access this data
  if (requestingUser.id !== userId && requestingUser.role !== 'admin') {
    throw new ForbiddenError('Access denied');
  }

  return await db.user.findUnique({ where: { id: userId } });
}
```

### A02: Cryptographic Failures

**Prevention:**
- Use strong encryption (AES-256)
- Use proper key management
- Don't implement crypto yourself
- Use vetted libraries

```typescript
// ✅ GOOD - Use established libraries
import crypto from 'crypto';

function encrypt(text: string, key: string): string {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);
  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  return iv.toString('hex') + ':' + encrypted;
}
```

### A03: Injection

**Prevention:**
- Always use parameterized queries
- Validate and sanitize inputs
- Use ORMs that prevent injection
- Escape output

```typescript
// ✅ GOOD - Parameterized query
const query = 'SELECT * FROM users WHERE email = $1';
const result = await db.query(query, [userEmail]);

// ✅ GOOD - ORM (automatically parameterized)
const user = await prisma.user.findUnique({
  where: { email: userEmail }
});
```

### A04: Insecure Design

**Prevention:**
- Security by design
- Threat modeling
- Secure defaults
- Minimize attack surface

### A05: Security Misconfiguration

**Prevention:**
- Disable unnecessary features
- Keep dependencies updated
- Configure security headers
- Use principle of least privilege

### A06: Vulnerable Components

**Prevention:**
```bash
# Regularly audit dependencies
npm audit
npm audit fix

# Check for outdated packages
npm outdated
```

### A07: Authentication Failures

**Prevention:**
- Don't implement crypto yourself
- Use MFA where appropriate
- Secure session management
- Proper password policies

### A08: Software Integrity Failures

**Prevention:**
- Verify signatures on updates
- Use Subresource Integrity (SRI)
- Code signing
- Dependency pinning

### A09: Logging Failures

**Prevention:**
- Log security events
- Don't log sensitive data
- Monitor for anomalies
- Alert on suspicious activity

### A10: SSRF (Server-Side Request Forgery)

**Prevention:**
- Validate all URLs
- Use allowlists
- Filter private addresses
- Disable unused URL handlers

---

## Security Checklist

Before considering code secure:

- [ ] All input validated with schema validation
- [ ] Passwords hashed with bcrypt/Argon2 (min 12 rounds)
- [ ] JWT secrets in environment variables
- [ ] SQL injection prevented (parameterized queries)
- [ ] XSS prevented (output encoding)
- [ ] CORS configured correctly
- [ ] Rate limiting implemented
- [ ] Sensitive data never logged
- [ ] HTTPS enforced in production
- [ ] Security headers configured (CSP, HSTS, etc.)
- [ ] RBAC implemented correctly
- [ ] Authorization checked on every request
- [ ] Dependencies audited for vulnerabilities
- [ ] Proper error handling (no information leakage)
- [ ] Audit logging for security events

---

## Integration

This skill integrates with:
- `backend-patterns` - Backend-specific security patterns
- `coding-standards` - General coding security practices
- `api-design` - Secure API design patterns
- `database-patterns` - Secure database access patterns
