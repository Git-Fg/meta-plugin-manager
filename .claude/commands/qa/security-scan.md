---
name: security-scan
description: "Execute predefined security scans and display results. Use when: user mentions 'qa/security-scan', '/scan-security', 'quick security check'; performing routine security audits; getting rapid vulnerability assessment. Integrates with security-auditor agent for comprehensive analysis. Not for: deep security reviews (use agent directly)."
user-invocable: true
---

# Security Scan Command

Execute predefined security scans for rapid vulnerability assessment.

## Available Scans

### 1. Quick Scan (Default)
**Command**: `qa/security-scan` or `/scan-security`
**Scope**: Common vulnerabilities, exposed secrets, basic misconfigurations
**Duration**: Fast (~1-2 minutes)
**Output**: Summary with actionable recommendations

### 2. Comprehensive Scan
**Command**: `qa/security-scan comprehensive` or `/scan-security --comprehensive`
**Scope**: Full codebase audit including OWASP Top 10, compliance checks
**Duration**: Thorough (~5-10 minutes)
**Output**: Detailed report with severity ratings

### 3. Targeted Scan
**Command**: `qa/security-scan --target [pattern]` or `/scan-security --target [pattern]`
**Scope**: Focus on specific files, directories, or vulnerability types
**Duration**: Variable
**Output**: Focused findings on target area

**Examples:**
- `qa/security-scan --target "*.js"` - Scan JavaScript files only
- `qa/security-scan --target "auth"` - Focus on authentication-related code
- `qa/security-scan --target "api"` - Focus on API endpoints

## Scan Categories

### Critical Issues (Immediate Action Required)
- **Exposed Credentials**: API keys, passwords, tokens in code
- **SQL Injection**: Unparameterized queries
- **Command Injection**: Unsanitized system calls
- **Authentication Bypass**: Critical auth flaws

### High Severity (Fix Soon)
- **Cross-Site Scripting (XSS)**: Reflected/stored XSS vulnerabilities
- **CSRF Protection**: Missing cross-site request forgery protection
- **Insecure Direct Object References**: IDOR vulnerabilities
- **Sensitive Data Exposure**: Unencrypted PII/credentials

### Medium Severity (Plan to Fix)
- **Missing Input Validation**: Lack of input sanitization
- **Error Information Leakage**: Detailed error messages
- **Missing Security Headers**: HSTS, CSP, X-Frame-Options
- **Weak Cryptographic Algorithms**: MD5, SHA1 usage

### Low Severity (Improve Over Time)
- **Outdated Dependencies**: Known CVEs in packages
- **Insufficient Logging**: Missing security event tracking
- **Information Disclosure**: Verbose error messages
- **Missing Rate Limiting**: API endpoints without protection

## Integration with Security Auditor Agent

### Automatic Delegation
**Trigger**: When command identifies potential security issues
**Action**: Prompt to run comprehensive audit with security-auditor agent
**Format**: "Run detailed analysis with security-auditor agent for complete vulnerability assessment"

### Manual Delegation
**Command**: `qa/security-scan --deep` or `/scan-security --agent`
**Effect**: Invokes security-auditor agent for comprehensive analysis
**Use Case**: When quick scan finds issues requiring detailed investigation

## Command Flags

### `--comprehensive`
Full codebase audit with OWASP Top 10 coverage

### `--target [pattern]`
Focus scan on specific files/directories/vulnerability types

### `--severity [level]`
Filter results by severity (critical, high, medium, low)

### `--json`
Output results in JSON format for automation

### `--report [path]`
Save results to file path

### `--agent` or `--deep`
Delegate to security-auditor agent for comprehensive analysis

## Success Criteria

**Binary test:** "Does scan provide actionable security findings?"
- Includes specific file:line references
- Categorizes by severity (Critical/High/Medium/Low)
- Provides clear remediation guidance
- Offers next steps for comprehensive analysis

**Binary test:** "Can non-security experts understand findings?"
- Plain language descriptions
- Clear impact explanations
- Prioritized action items

**Binary test:** "Does integration work seamlessly?"
- Easy transition to security-auditor agent
- Consistent output format
- Shared context between command and agent

## Security Best Practices

- **Read-Only Operation**: Command performs analysis only, no modifications
- **Safe Pattern Matching**: Uses read-only tools (Grep, Glob, Read)
- **No Code Execution**: Never runs code or commands during scan
- **Secure Output**: Doesn't expose sensitive data in reports
- **Rate Limiting**: Designed for repeated use without system impact

**Remember:** This command provides rapid security assessment. For comprehensive analysis, always leverage the security-auditor agent which provides detailed vulnerability assessment and remediation guidance.
