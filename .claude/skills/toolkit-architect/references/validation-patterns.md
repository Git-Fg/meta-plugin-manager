# Validation Patterns

## Validation Levels

### Level 1: Basic Type Validation
- File existence check
- YAML syntax validation
- Frontmatter presence
- Required fields check

### Level 2: Schema Validation
- Type checking (string, int, bool, list, dict)
- Range validation (min/max for numbers)
- Pattern matching (regex for strings)
- Array item validation
- Field dependencies

### Level 3: Business Rule Validation
- Environment-specific rules (production vs development)
- Security requirements (SSL, authentication)
- Resource constraints (timeout, retry limits)
- Cross-field dependencies

## Validation Patterns

### Progressive Validation
```bash
Level 1 (basic) → Level 2 (schema) → Level 3 (business)
```

### Conditional Validation
Apply rules based on configuration state:
- If caching enabled → require Redis URL
- If auth required → require credentials
- If production → require SSL

### Multi-Stage Validation
Pipeline approach with stages:
- Syntax validation
- Schema validation
- Security validation
- Performance validation

## Common Validation Rules

### Security Rules
- Production requires SSL
- Authentication requires credentials
- Secure protocols only (HTTPS, SSH)

### Resource Rules
- Timeout range: 1-3600 seconds
- Retry count: 0-10
- Memory limits: non-negative
- CPU percent: 0-100

### Field Dependencies
- Email format validation
- URL format validation
- Database URL prefixes (postgresql://, mysql://, sqlite://)

## Best Practices

1. **Fail Fast**: Check obvious errors first
2. **Clear Messages**: Specific error descriptions
3. **Validate Early**: Check at load, before use, before critical operations
4. **Appropriate Level**: Basic for runtime, full for deployment
5. **Log Results**: Track validation outcomes

## Validation Checklist

### Pre-Deployment
- [ ] YAML syntax valid
- [ ] Required fields present
- [ ] Types match schema
- [ ] Values within ranges
- [ ] Security requirements met
- [ ] Business rules satisfied

### Runtime
- [ ] Configuration file exists
- [ ] Plugin enabled
- [ ] Environment variables set
- [ ] Dependencies available
- [ ] Permissions correct
- [ ] Network connectivity confirmed
