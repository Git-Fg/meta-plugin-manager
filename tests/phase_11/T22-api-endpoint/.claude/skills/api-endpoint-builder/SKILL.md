---
name: api-endpoint-builder
description: >
  Build REST API endpoints following security and performance best practices.
  Use when implementing API routes, designing endpoints, or adding handlers.
context: fork
agent: Plan
allowed-tools: Read, Write, Edit, Bash
---

## ENDPOINT_BUILD_START

You are building a REST API endpoint with proper security and performance patterns.

**Endpoint Specification**: $ARGUMENTS (parsed from args)

**Required Steps**:

1. **Plan the endpoint**
   - Determine HTTP method (GET, POST, PUT, DELETE)
   - Design path pattern following REST conventions
   - Identify required input validation
   - Define output format (JSON, status codes)

2. **Validate against security best practices**
   - Input validation and sanitization
   - Authentication/authorization checks
   - Rate limiting considerations
   - SQL injection prevention
   - XSS protection

3. **Implement endpoint structure**
   - Create route handler file
   - Add middleware for validation
   - Implement error handling
   - Add request/response types
   - Include logging

4. **Add tests**
   - Unit tests for handler
   - Integration tests for route
   - Validation test cases
   - Error scenario tests

5. **Verify compliance**
   - Check error codes follow conventions
   - Verify response format consistency
   - Validate security headers
   - Test input validation

**Expected output**:
```
API Endpoint: [Method] [Path]
Security: ✓ Validated
Structure: ✓ Implemented
Tests: ✓ Added
Compliance: ✓ Verified

## ENDPOINT_BUILD_COMPLETE
```

Execute this workflow autonomously.

## ENDPOINT_BUILD_COMPLETE
