---
name: security
description: "Apply authentication, authorization, input validation, and secrets protection patterns. Use when handling user credentials, validating input, protecting APIs, or auditing code for injection, XSS, and access control issues. Not for general development without security focus."
---

# Security

security skill documentation.

## Core Concept

Core concept for security.

## Best Practices

Follow best practices and guidelines.

## Navigation

For detailed examples, see: `examples.md`
For technical reference, see: `reference.md`

---

<critical_constraint>
MANDATORY: Never expose secrets, credentials, or tokens in logs/output
MANDATORY: Apply OWASP Top 10 mitigation for all user inputs
MANDATORY: Use parameterized queries to prevent injection
MANDATORY: Implement least privilege for all operations
No exceptions. Security vulnerabilities have severe consequences.
</critical_constraint>
