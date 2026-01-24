# Skill Types

Three skill types for different use cases. Choose based on invocation and autonomy needs.

## Type 1: Auto-Discoverable (Default)

### Characteristics
- **Who can invoke**: Claude OR user
- **Discovery**: Automatic via description matching
- **Invocation**: `/skill-name` or automatic
- **Use for**: Domain knowledge, patterns, conventions

### When to Use

**Use auto-discoverable when**:
- Providing domain expertise
- Sharing project conventions
- Teaching patterns or standards
- Enhancing general knowledge

**Examples**:
- API design patterns
- Database conventions
- Testing approaches
- Coding standards
- Architecture guidelines

### Example: Auto-Discoverable

```yaml
---
name: api-conventions
description: "RESTful API design patterns for this codebase. Use when writing endpoints, modifying existing endpoints, or reviewing API changes."
---

# API Conventions

## Our Standards

**Base URL**: `/api/v1/{resource}`

**Resource Names**: Plural (users, posts, comments)

**Methods**:
- GET /api/v1/users - List all users
- GET /api/v1/users/1 - Get specific user
- POST /api/v1/users - Create new user
- PUT /api/v1/users/1 - Replace user
- PATCH /api/v1/users/1 - Update user
- DELETE /api/v1/users/1 - Delete user

## Response Format

Always use:
```json
{
  "data": { ... },
  "error": null,
  "meta": {
    "version": "v1",
    "timestamp": "2026-01-24T10:00:00Z"
  }
}
```

## Error Handling

- 400: Validation error
- 401: Authentication required
- 403: Insufficient permissions
- 404: Resource not found
- 409: Conflict (duplicate)
- 500: Server error

See [error-handling.md](references/error-handling.md) for complete guide.
```

### Discovery Mechanism

Claude reads description and decides:
- "User is writing an API endpoint" → Load this skill
- "User is reviewing API code" → Load this skill
- "User is doing database work" → Don't load (not relevant)

## Type 2: User-Triggered Workflows

### Characteristics
- **Who can invoke**: User ONLY
- **Discovery**: Via `/` menu only
- **Invocation**: `/skill-name` (user must type)
- **Use for**: Destructive actions, timing-critical operations

### When to Use

**Use user-triggered when**:
- Operation has side effects
- Timing is critical
- Destructive or irreversible
- Requires explicit user approval
- Modifies production systems

**Examples**:
- Deploy to production
- Database migrations
- Cleanup operations
- Security scans in production
- Notification sending

### Example: User-Triggered

```yaml
---
name: deploy
description: "Deploy application to production with zero-downtime. Use when releasing features or hotfixes. Requires approval confirmation. Not for development or staging."
disable-model-invocation: true
argument-hint: [environment, version]
---

# Deploy to Production

## Prerequisites

**Verify before deploying**:
- [ ] All tests passing
- [ ] Code reviewed and approved
- [ ] Environment variables configured
- [ ] Database migrations prepared

## Deployment Process

1. **Build artifacts**
   ```bash
   npm run build:production
   ```

2. **Run database migrations**
   ```bash
   npm run migrate:production
   ```

3. **Deploy with zero-downtime**
   ```bash
   npm run deploy:production
   ```

4. **Verify deployment**
   ```bash
   curl https://api.example.com/health
   ```

5. **Monitor logs**
   ```bash
   journalctl -u app -f
   ```

## Rollback

If issues detected:
```bash
npm run rollback:production
```

## Confirmation

Before deploying, you'll be asked to confirm:
- Target environment
- Version being deployed
- Approved by (who reviewed)

**Type "confirm" to proceed with deployment.**
```

### Why disable-model-invocation?

**Prevents accidental execution**:
- Claude won't invoke this skill automatically
- User must explicitly choose to run it
- Adds safety layer for dangerous operations

**Use cases**:
- Production deployments
- Database modifications
- Resource deletions
- External API calls with side effects
- Sending emails/notifications

## Type 3: Background Context Skills

### Characteristics
- **Who can invoke**: Claude ONLY
- **Discovery**: Automatic but hidden from `/` menu
- **Invocation**: Automatic only
- **Use for**: Context that enhances understanding

### When to Use

**Use background context when**:
- Explaining legacy systems
- Providing architectural context
- Documenting internal patterns
- Sharing historical decisions
- Adding domain expertise

**Examples**:
- Legacy system architecture
- Historical design decisions
- Integration patterns
- Business logic context
- Team conventions

### Example: Background Context

```yaml
---
name: legacy-payment-system
description: "Legacy payment processing architecture and integration patterns. Use when maintaining payment code or troubleshooting transactions. Not for new payment features (use Stripe integration)."
user-invocable: false
---

# Legacy Payment System

## Architecture

This system processes payments through multiple providers:

**Primary**: Authorize.Net (legacy)
**Fallback**: PayPal (backup)
**New**: Stripe (for new features)

## Payment Flow

```
User → Checkout → Payment Service
                  ↓
            [Determine Provider]
                  ↓
       ┌──────────┼──────────┐
       ↓          ↓          ↓
  Authorize  PayPal   Stripe
   .Net     (backup)  (new)
       └──────────┴──────────┘
                  ↓
            [Payment Gateway]
                  ↓
            [Bank Processor]
```

## Key Patterns

### Provider Selection
```javascript
// Old code determines provider
if (user.createdAt < '2020-01-01') {
  return 'authorize.net'; // Legacy users
} else if (user.country === 'US') {
  return 'stripe'; // New US users
} else {
  return 'paypal'; // International fallback
}
```

### Token Storage
- Authorize.Net: Database encrypted
- PayPal: Database encrypted
- Stripe: Stripe Vault (PCI compliant)

### Error Handling
- **Decline**: Show user-friendly message
- **Timeout**: Retry with fallback provider
- **Error**: Log to Sentry, alert team

## Migration Path

**Current status**: Phase 2 of 3

- ✅ Phase 1: Stripe integration complete
- 🔄 Phase 2: Migrating existing users (60% complete)
- ⏳ Phase 3: Deprecate Authorize.Net

**For new features**: Use Stripe directly

## Known Issues

1. **Authorize.Net token expiry**: Tokens expire after 12 months
   - **Workaround**: Re-tokenize during checkout
   - **Fix**: Scheduled for Phase 3

2. **PayPal webhooks**: Sometimes delayed by 30+ seconds
   - **Workaround**: Poll status after payment
   - **Fix**: Being investigated

3. **Currency conversion**: Uses legacy API with stale rates
   - **Workaround**: Manual rate updates daily
   - **Fix**: Migrate to modern currency API

## Integration Points

**Payment service**: `src/payment/`
- `legacy.service.js` - Authorize.Net wrapper
- `paypal.service.js` - PayPal wrapper
- `stripe.service.js` - Stripe wrapper
- `router.js` - Provider selection logic

**Database**: `payments` table
- `provider` - Which provider was used
- `provider_transaction_id` - External reference
- `status` - pending, completed, failed, refunded
- `metadata` - Provider-specific data (JSON)

## Common Tasks

**Troubleshooting failed payment**:
1. Check `provider` field
2. Check `provider_transaction_id`
3. Look up transaction in provider dashboard
4. Check `metadata` for error codes

**Adding new payment method**: Use Stripe, don't add to legacy system

**Testing payments**: Use test mode credentials in `.env`
```

### Why user-invocable: false?

**Benefits**:
- Context loads automatically when relevant
- Doesn't clutter `/` menu
- Provides background understanding
- No direct invocation needed

**Claude uses this when**:
- User asks about payment bugs
- User is modifying payment code
- User is troubleshooting transactions
- User asks about payment architecture

## Type Comparison

| Aspect | Auto-Discoverable | User-Triggered | Background Context |
|--------|-------------------|----------------|-------------------|
| **Invoked by** | Claude + User | User only | Claude only |
| **In `/` menu** | Yes | Yes | No |
| **Discovery** | Automatic | Manual | Automatic |
| **Use for** | Domain knowledge | Destructive actions | Context/enhancement |
| **Example** | API conventions | Deploy to production | Legacy architecture |
| **YAML flag** | (default) | `disable-model-invocation: true` | `user-invocable: false` |

## Choosing the Right Type

### Decision Tree

```
START: What do you need?

├─ "Knowledge or patterns"
│  └─ → Auto-Discoverable (default)
│
├─ "Destructive or side-effect action"
│  └─ → User-Triggered
│     └─ Add: disable-model-invocation: true
│
└─ "Context that helps understanding"
   └─ → Background Context
      └─ Add: user-invocable: false
```

### Examples by Type

**Auto-Discoverable**:
- `api-conventions` - API design patterns
- `database-patterns` - Database query patterns
- `testing-framework` - Testing approaches
- `coding-standards` - Code style guide

**User-Triggered**:
- `deploy` - Deploy to production
- `migrate-database` - Run migrations
- `cleanup-logs` - Clean old logs
- `send-notifications` - Send alerts

**Background Context**:
- `legacy-system` - Legacy architecture
- `payment-history` - Payment system evolution
- `auth-architecture` - Authentication design
- `team-conventions` - Team-specific rules

## YAML Reference

### Auto-Discoverable (Default)
```yaml
---
name: skill-name
description: "WHAT. Use when: WHEN."
user-invocable: true
---
```

### User-Triggered
```yaml
---
name: skill-name
description: "WHAT. Use when: WHEN."
disable-model-invocation: true
argument-hint: [param1, param2]
---
```

### Background Context
```yaml
---
name: skill-name
description: "WHAT. Use when: WHEN."
user-invocable: false
---
```

## Summary

**Type 1: Auto-Discoverable** - Default for knowledge and patterns
**Type 2: User-Triggered** - For dangerous or side-effect operations
**Type 3: Background Context** - For architectural context and history

**Most skills**: Use Type 1 (auto-discoverable)
**Add flag only**: When there's a specific reason
