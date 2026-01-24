# URL Validation Knowledge Specification

## Summary
This specification defines the mandatory URL validation requirements for knowledge skills, emphasizing mandatory fetching and 15-minute cache minimum to ensure documentation accuracy and currency.

## Critical Gap: URL Verification System

### Current Status
**MISSING**: Automated URL verification for knowledge skills
**Evidence**:
- 19 references to code.claude.com domain found
- 1 reference to agentskills.io domain
- No automated verification system exists
- Manual verification required (AUDIT_REPORT.md:180-187)

**Impact**:
- Documentation accuracy cannot be guaranteed
- Stale or broken URLs may remain undetected
- Users receive outdated information
- No systematic validation process

## Given-When-Then Acceptance Criteria

### G1: Mandatory URL Fetching
**Given** a knowledge skill with external URLs
**When** skill is implemented
**Then** it MUST include:
- URL fetching section using mcp__simplewebfetch__simpleWebFetch
- 15-minute cache minimum for all URLs
- Validation of all external references
- Documentation of URL status

### G2: URL Validation Process
**Given** URLs in knowledge skill documentation
**When** validation is performed
**Then** it MUST:
- Fetch all URLs using mcp__simplewebfetch__simpleWebFetch
- Verify URLs return valid content
- Check for redirects or errors
- Document validation results

### G3: Cache Policy
**Given** URL fetching for validation
**When** cache expires
**Then** it MUST:
- Respect 15-minute minimum cache
- Use cache for repeated fetches
- Re-validate after cache expiration
- Maintain cache for efficiency

### G4: Documentation Requirements
**Given** URLs used in skill documentation
**When** writing SKILL.md
**Then** it MUST include:
- URL fetching section (MANDATORY for knowledge skills)
- List of all external URLs
- Validation status for each URL
- Cache configuration details

### G5: Failed Validation Handling
**Given** URL validation fails
**When** broken or stale URL detected
**Then** it MUST:
- Flag URL as invalid
- Attempt to find alternative
- Update documentation
- Report validation errors

## URL Validation Workflow

### Step 1: Identify URLs
**Extract from skill documentation**:
- code.claude.com references
- agentskills.io references
- Other external URLs

**Tools**:
```bash
# Find all URLs in skill documentation
grep -r "https\?://" .claude/skills/*/SKILL.md | grep -v "mcp__simplewebfetch__simpleWebFetch"
```

### Step 2: Validate URLs
**Use mcp__simplewebfetch__simpleWebFetch**:
```bash
# Validate single URL
mcp__simplewebfetch__simpleWebFetch url="https://example.com" options='{"cacheDir": ".cache/url-validation", "timeoutMs": 30000}'

# Validate multiple URLs (script)
for url in $(grep -r "https\?://" .claude/skills/*/SKILL.md | cut -d' ' -f2 | sort -u); do
  mcp__simplewebfetch__simpleWebFetch url="$url" options='{"cacheDir": ".cache/url-validation", "timeoutMs": 30000}'
done
```

### Step 3: Document Results
**Create validation report**:
```markdown
# URL Validation Report

## Validated URLs
- https://agentskills.io/specification: VALID (2026-01-24)
- https://code.claude.com/docs/agents: VALID (2026-01-24)

## Failed URLs
None

## Cache Configuration
- Cache directory: .cache/url-validation
- Cache expiration: 15 minutes minimum
- Last validated: 2026-01-24
```

### Step 4: Update Documentation
**Add validation section to SKILL.md**:
```markdown
## URL Validation

### External References
- [Agent Skills Specification](https://agentskills.io/specification) - Validated 2026-01-24
- [Claude Code Documentation](https://code.claude.com/docs/agents) - Validated 2026-01-24

### Validation Method
All URLs validated using mcp__simplewebfetch__simpleWebFetch with 15-minute cache.
```

## Knowledge Skill Requirements

### Mandatory Sections
**Knowledge skills MUST include**:

1. **URL Fetching Section**:
```markdown
## URL Fetching

This knowledge skill validates all external URLs using mcp__simplewebfetch__simpleWebFetch with 15-minute cache.

### External References
[List all external URLs]

### Validation Status
[Document validation results]
```

2. **URL List**:
   - All external URLs used
   - Validation date
   - Status (valid/invalid)

3. **Cache Configuration**:
   - Cache directory specified
   - 15-minute minimum cache
   - Cache expiration policy

### Implementation Pattern
```markdown
## URL Fetching

All external URLs in this skill are validated using mcp__simplewebfetch__simpleWebFetch with 15-minute cache.

### External References
- https://agentskills.io/specification - Agent Skills specification
- https://code.claude.com/docs/agents - Claude Code documentation

### Validation Method
Each URL fetched and validated during skill development. Results:

| URL | Status | Last Validated |
|-----|--------|----------------|
| agentskills.io/specification | VALID | 2026-01-24 |
| code.claude.com/docs/agents | VALID | 2026-01-24 |

Cache: .cache/url-validation (15-minute minimum)
```

## Input/Output Examples

### Example 1: Complete URL Validation
**Input**: Knowledge skill with external URLs
```
Skill: hooks-knowledge
URLs:
- https://agentskills.io/hooks
- https://code.claude.com/docs/hooks
```

**Validation Process**:
```bash
# Fetch and validate
mcp__simplewebfetch__simpleWebFetch url="https://agentskills.io/hooks" options='{"cacheDir": ".cache/hooks-knowledge", "timeoutMs": 30000}'
mcp__simplewebfetch__simpleWebFetch url="https://code.claude.com/docs/hooks" options='{"cacheDir": ".cache/hooks-knowledge", "timeoutMs": 30000}'
```

**Output**:
```
## URL Validation

### External References
- [Agent Skills Hooks](https://agentskills.io/hooks) - Validated 2026-01-24
- [Claude Hooks Guide](https://code.claude.com/docs/hooks) - Validated 2026-01-24

### Validation Results
All URLs validated successfully. Cache: .cache/hooks-knowledge (15-minute minimum)
```

### Example 2: Failed URL Validation
**Input**: Knowledge skill with broken URL
```
URL: https://code.claude.com/docs/nonexistent-page
```

**Validation**:
```bash
mcp__simplewebfetch__simpleWebFetch url="https://code.claude.com/docs/nonexistent-page"
```

**Expected Output**:
```
## URL Validation

### External References
- [Documentation](https://code.claude.com/docs/nonexistent-page) - INVALID (404 Not Found)

### Validation Results
⚠️ 1 URL failed validation. Action required:
- Broken link detected: https://code.claude.com/docs/nonexistent-page
- Resolution: Remove or update link
```

### Example 3: URL with Redirect
**Input**: URL that redirects
```
URL: https://example.com/old-path
```

**Validation**:
```bash
mcp__simplewebfetch__simpleWebFetch url="https://example.com/old-path"
```

**Expected Behavior**:
- Follows redirect automatically
- Validates final destination
- Documents redirect chain

**Output**:
```
## URL Validation

### External References
- [Documentation](https://example.com/old-path) → https://example.com/new-path - VALID

### Redirects Detected
https://example.com/old-path → https://example.com/new-path
```

## Edge Cases and Error Conditions

### E1: Broken or Invalid URL
**Condition**: URL returns 404, 500, or connection error
**Error**: `URL_VALIDATION_FAILED`
**Action**:
1. Flag URL as invalid
2. Attempt to find working alternative
3. Update documentation
4. Remove or fix link

### E2: Stale Content
**Condition**: URL returns outdated information
**Error**: `STALE_CONTENT_DETECTED`
**Action**:
1. Note content date
2. Check for newer version
3. Update documentation if needed
4. Re-validate periodically

### E3: Excessive Redirects
**Condition**: URL has 3+ redirects
**Warning**: `EXCESSIVE_REDIRECTS`
**Action**:
1. Document redirect chain
2. Consider using final URL directly
3. Verify each redirect step
4. Update documentation

### E4: Slow Response
**Condition**: URL takes >30 seconds
**Warning**: `SLOW_RESPONSE`
**Action**:
1. Document slow response time
2. Consider cache settings
3. May indicate server issues
4. Monitor over time

### E5: Cache Expiration
**Condition**: Cache expires before next use
**Action**:
1. Re-validate URLs
2. Update cache timestamp
3. Document re-validation
4. Maintain 15-minute minimum

## Implementation Guidelines

### For Knowledge Skill Developers

#### Step 1: Identify URLs
1. Review SKILL.md for all external URLs
2. Create list of URLs to validate
3. Note purpose of each URL

#### Step 2: Validate URLs
```bash
# Use mcp__simplewebfetch__simpleWebFetch for each URL
mcp__simplewebfetch__simpleWebFetch url="URL_HERE" options='{"cacheDir": ".cache/skill-name", "timeoutMs": 30000}'
```

#### Step 3: Document Results
Add URL validation section to SKILL.md:
```markdown
## URL Validation

### External References
- [URL Name](URL) - Description

### Validation Method
Validated using mcp__simplewebfetch__simpleWebFetch with 15-minute cache.

### Results
| URL | Status | Date |
|-----|--------|------|
| URL | VALID/INVALID | YYYY-MM-DD |
```

#### Step 4: Maintain Validation
- Re-validate URLs periodically
- Update cache as needed
- Monitor for changes
- Fix broken links immediately

### For Quality Reviewers

#### Validation Checklist
- [ ] All external URLs identified
- [ ] mcp__simplewebfetch__simpleWebFetch used for validation
- [ ] 15-minute cache configured
- [ ] URL validation section present
- [ ] Validation results documented
- [ ] No broken or stale URLs

#### Review Process
1. Scan SKILL.md for URLs
2. Verify URL fetching section exists
3. Check validation results
4. Test a sample URL manually
5. Confirm cache configuration
6. Flag any issues

## Quality Framework Integration

### Discoverability
- URL validation section easily found
- Clear validation status
- Well-organized URL list
- Descriptive links

### Completeness
- All URLs validated
- Complete validation results
- No missing external references
- Comprehensive coverage

### Standards Compliance
- Follows mandatory URL fetching requirement
- Uses mcp__simplewebfetch__simpleWebFetch tool
- Implements 15-minute cache
- Documents validation process

## Automation Opportunities

### Automated Validation Script
```bash
#!/bin/bash
# validate-urls.sh

SKILL_DIR=".claude/skills/$1"
CACHE_DIR=".cache/$1"

# Extract URLs
URLS=$(grep -r "https\?://" "$SKILL_DIR" | grep -v "mcp__simplewebfetch__simpleWebFetch" | cut -d' ' -f2 | sort -u)

# Validate each URL
for url in $URLS; do
  echo "Validating: $url"
  mcp__simplewebfetch__simpleWebFetch url="$url" options="{\"cacheDir\": \"$CACHE_DIR\", \"timeoutMs\": 30000}"
done

echo "Validation complete"
```

### CI/CD Integration
```yaml
# .github/workflows/url-validation.yml
name: URL Validation
on: [push, pull_request]

jobs:
  validate-urls:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Validate URLs
        run: |
          for skill in .claude/skills/*/; do
            ./validate-urls.sh $(basename "$skill")
          done
```

## Current Implementation Status

### ✅ Compliant Knowledge Skills
**Evidence**: AUDIT_REPORT shows 18/18 skills have web content fetching sections
**Status**: 100% compliance with URL fetching requirement

### ❌ Missing Systems
- Automated URL verification tool
- Centralized validation process
- URL change monitoring
- Stale content detection

### 📋 Improvements Needed
1. Systematic URL validation
2. Automated checking
3. Cache management
4. Failure alerting

## Fix Priority

### Immediate (Critical)
1. **Create validation tool**: Build automated URL checker
2. **Validate all URLs**: Check current references
3. **Fix broken links**: Update or remove invalid URLs
4. **Document validation**: Add results to skills

### Short-term (High)
5. **Implement monitoring**: Track URL changes
6. **Set up alerts**: Notify on broken URLs
7. **Create cache system**: Manage 15-minute cache
8. **Train developers**: Teach validation process

### Medium-term (Medium)
9. **Build CI/CD checks**: Automated validation in pipeline
10. **Create dashboard**: Monitor URL health
11. **Establish schedule**: Regular validation cycles
12. **Document best practices**: URL management guide

## Validation Checklist

### For Each Knowledge Skill
- [ ] URL fetching section present
- [ ] All external URLs listed
- [ ] Validation results documented
- [ ] mcp__simplewebfetch__simpleWebFetch used
- [ ] 15-minute cache configured
- [ ] No broken URLs
- [ ] Cache directory specified
- [ ] Last validated date noted

### Quality Review
- [ ] Verify URL fetching section
- [ ] Check validation results
- [ ] Test sample URLs
- [ ] Confirm cache settings
- [ ] Review documentation
- [ ] Flag any issues

## Out of Scope

### Not Covered by This Specification
- Specific skill architectures
- Content quality within skills
- Testing methodologies
- Security specifics

## References
- Knowledge skills: All skills with external URLs
- Web fetch tool: mcp__simplewebfetch__simpleWebFetch
- Audit report: AUDIT_REPORT.md (lines 180-187)
- Cache directory: .cache/simplewebfetch-mcp/
- Test plan: `tests/skill_test_plan.json`
