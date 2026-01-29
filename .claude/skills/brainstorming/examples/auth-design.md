# Design: User Authentication

## Architecture Decision

**Selected**: Supabase Auth with custom claims

**Alternative Considered**: Auth0

- Auth0 pros: Enterprise features, SSO
- Auth0 cons: More expensive, less flexible

**Alternative Considered**: Custom JWT

- Custom pros: Full control
- Custom cons: Security burden, maintenance

## Component Structure

```
src/
├── auth/
│   ├── auth-service.ts      # OAuth flow, session management
│   ├── token-service.ts     # JWT generation, validation
│   ├── claims.ts            # Custom claims types
│   └── middleware.ts        # Express middleware for protected routes
├── users/
│   ├── user-model.ts        # User entity
│   └── user-repository.ts   # Database operations
└── config/
    └── supabase.ts          # Supabase client config
```

## Key Design Points

### Session Management

- Access token: 15 min expiry
- Refresh token: 7 day expiry (rotated on use)
- Session stored in HTTP-only cookie

### Custom Claims

```typescript
interface CustomClaims {
  role: "admin" | "editor" | "viewer";
  permissions: string[];
  organizationId: string;
}
```

### Protected Routes Middleware

```typescript
function requireAuth(req, res, next) {
  const token = req.cookies.access_token;
  if (!token) return res.status(401).json({ error: "Unauthorized" });

  try {
    const claims = validateToken(token);
    req.user = claims;
    next();
  } catch {
    return res.status(401).json({ error: "Invalid token" });
  }
}
```
