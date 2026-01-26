---
name: auth-skill
description: Comprehensive authentication patterns for MCP servers, API integrations, and security best practices
---

# Authentication Skill

## What This Does

Provides expert-level guidance for implementing secure authentication in Claude Code components, MCP servers, and API integrations. Covers OAuth 2.0 flows, token-based authentication, security hardening, and practical troubleshooting.

## When to Use

Use when working with:
- Setting up OAuth 2.0 or OAuth 1.0a flows
- Implementing token-based authentication (JWT, API keys, bearer tokens)
- Hardening authentication security
- Debugging authentication failures
- Designing secure auth patterns for MCP servers
- API integration authentication

## Core Authentication Patterns

### Pattern 1: OAuth 2.0 Authorization Code Flow

Use for user authentication in web applications and MCP servers requiring user consent.

**Setup Steps:**
1. Register your application with the OAuth provider
2. Configure redirect URIs
3. Implement authorization endpoint redirect
4. Exchange authorization code for access token
5. Store tokens securely

**Example Implementation:**
```javascript
// Step 1: Redirect to authorization URL
const authUrl = `https://provider.com/oauth/authorize?
  response_type=code&
  client_id=${CLIENT_ID}&
  redirect_uri=${encodeURIComponent(REDIRECT_URI)}&
  scope=${encodeURIComponent(SCOPE)}&
  state=${CSRF_TOKEN}`;

// Step 2: Exchange code for token (server-side)
const tokenResponse = await fetch('https://provider.com/oauth/token', {
  method: 'POST',
  headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
  body: new URLSearchParams({
    grant_type: 'authorization_code',
    client_id: CLIENT_ID,
    client_secret: CLIENT_SECRET,
    code: authorizationCode,
    redirect_uri: REDIRECT_URI
  })
});
const tokens = await tokenResponse.json();
```

**Best Practices:**
- Always validate `state` parameter to prevent CSRF
- Use HTTPS for all OAuth communications
- Store refresh tokens securely (encrypted at rest)
- Implement token rotation for sensitive applications
- Use PKCE (Proof Key for Code Exchange) for public clients

### Pattern 2: Client Credentials Flow

Use for server-to-server authentication without user context.

**Setup Steps:**
1. Register application with OAuth provider
2. Obtain client ID and client secret
3. Request access token using client credentials
4. Use token for API calls

**Example Implementation:**
```javascript
const tokenResponse = await fetch('https://api.provider.com/oauth/token', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Basic ' + Buffer.from(`${CLIENT_ID}:${CLIENT_SECRET}`).toString('base64')
  },
  body: new URLSearchParams({
    grant_type: 'client_credentials',
    scope: 'api:read api:write'
  })
});

const { access_token, expires_in } = await tokenResponse.json();

// Use token for API calls
const apiResponse = await fetch('https://api.provider.com/data', {
  headers: { 'Authorization': `Bearer ${access_token}` }
});
```

**When to Use:**
- Machine-to-machine communication
- Backend service authentication
- No user consent required
- API-to-API calls

### Pattern 3: JWT Token Authentication

Use for stateless authentication with embedded user data.

**Token Structure:**
```javascript
const token = {
  header: {
    alg: "HS256",
    typ: "JWT"
  },
  payload: {
    sub: "user123",
    iss: "your-app",
    aud: "your-api",
    exp: 1234567890,
    iat: 1234567890,
    role: "admin"
  },
  signature: "base64url-encoded-hmac"
};
```

**Verification Example:**
```javascript
function verifyJWT(token, secret) {
  try {
    const [header, payload, signature] = token.split('.');

    // Verify signature
    const expectedSignature = crypto
      .createHmac('sha256', secret)
      .update(`${header}.${payload}`)
      .digest('base64url');

    if (signature !== expectedSignature) {
      throw new Error('Invalid signature');
    }

    // Check expiration
    const { exp, iat } = JSON.parse(Buffer.from(payload, 'base64url').toString());
    if (Date.now() >= exp * 1000) {
      throw new Error('Token expired');
    }

    return JSON.parse(Buffer.from(payload, 'base64url').toString());
  } catch (error) {
    throw new Error(`JWT verification failed: ${error.message}`);
  }
}
```

**Security Best Practices:**
- Set appropriate expiration times (short-lived tokens preferred)
- Use strong signing algorithms (HS256 minimum, RS256 for production)
- Include only necessary claims in payload
- Implement token revocation strategy
- Validate audience (`aud`) and issuer (`iss`)

### Pattern 4: API Key Authentication

Simple authentication for internal services or low-security APIs.

**Implementation:**
```javascript
// Option 1: Header-based
const apiKey = 'your-api-key-here';
const response = await fetch('https://api.example.com/data', {
  headers: { 'X-API-Key': apiKey }
});

// Option 2: Query parameter (less secure)
const response = await fetch(`https://api.example.com/data?api_key=${apiKey}`);

// Option 3: Basic Auth for credentials
const credentials = Buffer.from(`${username}:${password}`).toString('base64');
const response = await fetch('https://api.example.com/data', {
  headers: { 'Authorization': `Basic ${credentials}` }
});
```

**When to Use:**
- Internal API communication
- Service-to-service authentication
- Low-risk data access
- Simple integration requirements

**Security Considerations:**
- Rotate API keys regularly
- Use environment variables for key storage
- Implement rate limiting per API key
- Consider key scoping (limited permissions)
- Never expose keys in client-side code

### Pattern 5: MCP Server Authentication

Secure authentication patterns for Model Context Protocol servers.

**Server-Side Implementation:**
```javascript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';

const server = new Server({
  name: "authenticated-server",
  version: "1.0.0"
}, {
  capabilities: {
    tools: {}
  }
});

// Add authentication middleware
server.use(async (request, response, next) => {
  const authHeader = request.headers.authorization;

  if (!authHeader) {
    return response.error({
      code: -32000,
      message: "Missing authorization header"
    });
  }

  try {
    const token = extractToken(authHeader);
    const user = await verifyToken(token);

    // Attach user to request context
    request.user = user;
    next();
  } catch (error) {
    return response.error({
      code: -32001,
      message: "Invalid authentication"
    });
  }
});

// Token verification helper
async function verifyToken(token) {
  // Implement your token verification logic
  const decoded = jwt.verify(token, JWT_SECRET);
  return decoded.user;
}
```

**Client-Side Usage:**
```javascript
import { Client } from '@modelcontextprotocol/sdk/client/index.js';

const client = new Client({
  name: "auth-client",
  version: "1.0.0"
}, {
  capabilities: { tools: {} }
});

await client.connect(serverUrl, {
  // Pass authentication token
  authToken: process.env.MCP_AUTH_TOKEN
});
```

## Security Hardening Checklist

### Token Security
- [ ] Tokens encrypted at rest
- [ ] Short expiration times (15 minutes for access tokens)
- [ ] Refresh tokens rotated on use
- [ ] Token scope minimized to required permissions
- [ ] Invalid tokens logged and monitored

### Transport Security
- [ ] All auth endpoints use HTTPS (TLS 1.2+)
- [ ] HSTS headers implemented
- [ ] Certificate pinning for high-security scenarios
- [ ] No credentials in URLs or query parameters

### Storage Security
- [ ] Secrets in environment variables, not code
- [ ] Encryption at rest for stored tokens
- [ ] Key rotation policy implemented
- [ ] Access logging for secret usage
- [ ] Secure key derivation for stored secrets

### Application Security
- [ ] CSRF protection for state-changing operations
- [ ] Rate limiting on authentication endpoints
- [ ] Account lockout after failed attempts
- [ ] Secure session management
- [ ] Input validation on all auth parameters

### Monitoring & Auditing
- [ ] Failed authentication attempts logged
- [ ] Unusual access patterns detected
- [ ] Token usage analytics
- [ ] Security incident response plan
- [ ] Regular security audits

## Troubleshooting Authentication

### Common OAuth Errors

**"Invalid redirect_uri"**
- Verify redirect URI exactly matches registered URI (including protocol)
- Check for trailing slashes or query parameters
- Ensure URI is properly URL-encoded
- Confirm URI is in provider's allowed list

**"Invalid client_id"**
- Verify client_id is correct and active
- Check if client application is approved/suspended
- Ensure client_id isn't accidentally swapped with client_secret
- Confirm environment (dev/staging/prod) matches registration

**"Invalid authorization code"**
- Code already exchanged (one-time use only)
- Code expired (typically 10-15 minutes)
- Code tampered with (signature mismatch)
- Redirect URI in exchange request differs from original request

**"Invalid_grant"**
- Authorization code expired or already used
- Refresh token revoked or expired
- Grant type mismatch (code vs refresh_token)
- Client authentication failed

**"access_denied"**
- User denied authorization
- Scope too restrictive for requested resources
- Account lacks required permissions
- Application not approved by user/organization

### Token Troubleshooting

**"Token expired"**
- Check `exp` claim in JWT payload
- Implement automatic token refresh
- Verify clock synchronization (NTP)
- Refresh token may also be expired

**"Invalid signature"**
- Verify using correct secret/public key
- Check algorithm matches (HS256 vs RS256)
- Ensure token not truncated or modified
- Verify base64url encoding

**"Invalid audience"**
- Check `aud` claim matches your API identifier
- Multiple audiences: verify all specified
- Verify issuer (`iss`) matches expected value
- Check token was issued for your application

### Debugging Steps

1. **Enable debug logging:**
```javascript
process.env.DEBUG = 'oauth:*';
```

2. **Log token details (redact sensitive data):**
```javascript
function logToken(token) {
  const parts = token.split('.');
  const header = JSON.parse(Buffer.from(parts[0], 'base64url').toString());
  const payload = JSON.parse(Buffer.from(parts[1], 'base64url').toString());

  console.log('Token Header:', header);
  console.log('Token Payload (redacted):', {
    ...payload,
    sub: payload.sub ? '***' : undefined,
    exp: payload.exp ? new Date(payload.exp * 1000) : undefined
  });
}
```

3. **Verify flow sequence:**
```javascript
// Log each step of authentication flow
console.log('Step 1: Authorization request');
console.log('Step 2: User redirected back with code');
console.log('Step 3: Token exchange request');
console.log('Step 4: Token received and verified');
```

4. **Test with known-good tools:**
```javascript
// Use jwt.io to decode and verify JWT tokens
// Use OAuth 2.0 debugger tools
// Test with curl commands
```

### MCP-Specific Issues

**"Connection refused during auth"**
- Verify server is listening on correct port
- Check authentication middleware properly configured
- Ensure client sends auth header format: `Bearer <token>`
- Verify token hasn't expired before connection attempt

**"Tool call unauthorized"**
- User context not properly attached to request
- Token verified but permissions not checked
- Tool requires additional authentication beyond MCP auth
- Role-based access control blocking tool usage

**Resolution Steps:**
```javascript
// Verify user context in MCP handler
server.tool('my-tool', async (request) => {
  if (!request.user) {
    throw new Error('User context not available - auth middleware failed');
  }

  if (!request.user.permissions.includes('tool:my-tool')) {
    throw new Error('Insufficient permissions for this tool');
  }

  // Proceed with tool execution
});
```

## Quick Reference

### OAuth Grant Types
| Grant Type | Use Case | User Context |
|------------|----------|--------------|
| Authorization Code | Web apps, user consent | Yes |
| Client Credentials | Server-to-server | No |
| Refresh Token | Token renewal | No |
| Device Code | Limited input devices | Yes |
| Password | Legacy/trusted apps | Yes |

### Token Types
| Token | Use | Expiration |
|-------|-----|------------|
| Access Token | API calls | Short (15 min) |
| Refresh Token | Get new access tokens | Long (days) |
| ID Token | User identity | Short (15 min) |
| JWT | Custom tokens | Configurable |

### Security Headers
```http
Authorization: Bearer <token>
X-API-Key: <key>
Content-Type: application/x-www-form-urlencoded
Accept: application/json
```

### Essential Environment Variables
```
OAUTH_CLIENT_ID=your-client-id
OAUTH_CLIENT_SECRET=your-client-secret
OAUTH_REDIRECT_URI=https://your-app.com/callback
JWT_SECRET=your-secret-key
MCP_AUTH_TOKEN=your-mcp-token
API_KEY=your-api-key
```

## Integration Examples

### Full OAuth Flow with React Frontend

```javascript
// auth.js - Authentication service
class AuthService {
  constructor() {
    this.clientId = process.env.REACT_APP_OAUTH_CLIENT_ID;
    this.redirectUri = `${window.location.origin}/callback`;
    this.scope = 'openid profile email';
  }

  // Start OAuth flow
  login() {
    const state = this.generateState();
    const codeVerifier = this.generateCodeVerifier();

    sessionStorage.setItem('oauth_state', state);
    sessionStorage.setItem('oauth_code_verifier', codeVerifier);

    const authUrl = `https://auth.provider.com/oauth/authorize?
      response_type=code&
      client_id=${this.clientId}&
      redirect_uri=${encodeURIComponent(this.redirectUri)}&
      scope=${encodeURIComponent(this.scope)}&
      state=${state}&
      code_challenge=${this.generateCodeChallenge(codeVerifier)}&
      code_challenge_method=S256`;

    window.location.href = authUrl;
  }

  // Handle callback
  async handleCallback(url) {
    const params = new URLSearchParams(new URL(url).search);
    const code = params.get('code');
    const state = params.get('state');

    // Verify state
    if (state !== sessionStorage.getItem('oauth_state')) {
      throw new Error('State mismatch - possible CSRF attack');
    }

    // Exchange code for tokens
    const response = await fetch('https://auth.provider.com/oauth/token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        grant_type: 'authorization_code',
        client_id: this.clientId,
        code: code,
        redirect_uri: this.redirectUri,
        code_verifier: sessionStorage.getItem('oauth_code_verifier')
      })
    });

    const tokens = await response.json();
    this.storeTokens(tokens);
  }

  storeTokens(tokens) {
    // Store access token (short-term)
    localStorage.setItem('access_token', tokens.access_token);

    // Store refresh token securely
    if (tokens.refresh_token) {
      localStorage.setItem('refresh_token', tokens.refresh_token);
    }

    // Set expiration
    const expiresAt = Date.now() + (tokens.expires_in * 1000);
    localStorage.setItem('token_expires_at', expiresAt.toString());
  }

  async getValidAccessToken() {
    const expiresAt = parseInt(localStorage.getItem('token_expires_at') || '0');
    const now = Date.now();

    // Token valid
    if (now < expiresAt) {
      return localStorage.getItem('access_token');
    }

    // Token expired, try refresh
    const refreshToken = localStorage.getItem('refresh_token');
    if (!refreshToken) {
      throw new Error('No refresh token available');
    }

    return await this.refreshAccessToken(refreshToken);
  }
}
```

### Express.js Middleware

```javascript
// auth-middleware.js
const jwt = require('jsonwebtoken');

function authenticateJWT(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Missing or invalid authorization header' });
  }

  const token = authHeader.substring(7);

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(403).json({ error: 'Invalid or expired token' });
  }
}

function requireRole(role) {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ error: 'Not authenticated' });
    }

    if (!req.user.roles || !req.user.roles.includes(role)) {
      return res.status(403).json({ error: `Requires role: ${role}` });
    }

    next();
  };
}

// Usage
app.get('/api/admin', authenticateJWT, requireRole('admin'), (req, res) => {
  res.json({ data: 'Admin only content' });
});
```

## Key Takeaways

1. **Choose the right flow**: OAuth 2.0 has multiple grant types for different scenarios
2. **Security first**: Always use HTTPS, validate state, and implement proper token handling
3. **Token management**: Implement refresh logic and handle token expiration gracefully
4. **Monitor authentication**: Log failures and unusual patterns
5. **Follow the principle of least privilege**: Request only necessary scopes and permissions
6. **Test thoroughly**: Verify flows work in all scenarios before production deployment

Remember: Authentication is the first line of defense. Take time to implement it correctly.