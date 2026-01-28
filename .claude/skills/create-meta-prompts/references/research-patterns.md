## Overview

Prompt patterns for gathering information that will be consumed by planning or implementation prompts.

Includes quality controls, verification mechanisms, and streaming writes to prevent research gaps and token limit failures.

<prompt_template>
```xml
<session_initialization>
Before beginning research, verify today's date:
!`date +%Y-%m-%d`

Use this date when searching for "current" or "latest" information.
Example: If today is 2025-11-22, search for "2025" not "2024".

<research_objective>
Research {topic} to inform {subsequent use}.

Purpose: {What decision/implementation this enables}
Scope: {Boundaries of the research}
Output: {topic}-research.md with structured findings

<research_scope>
<include>
{What to investigate}
{Specific questions to answer}

<exclude>
{What's out of scope}
{What to defer to later research}

<sources>
{Priority sources with exact URLs for WebFetch}
Official documentation:
- https://example.com/official-docs
- https://example.com/api-reference

Search queries for WebSearch:
- "{topic} best practices {current_year}"
- "{topic} latest version"

{Time constraints: prefer current sources - check today's date first}

<verification_checklist>
{If researching configuration/architecture with known components:}
□ Verify ALL known configuration/implementation options (enumerate below):
  □ Option/Scope 1: {description}
  □ Option/Scope 2: {description}
  □ Option/Scope 3: {description}
□ Document exact file locations/URLs for each option
□ Verify precedence/hierarchy rules if applicable
□ Confirm syntax and examples from official sources
□ Check for recent updates or changes to documentation

{For all research:}
□ Verify negative claims ("X is not possible") with official docs
□ Confirm all primary claims have authoritative sources
□ Check both current docs AND recent updates/changelogs
□ Test multiple search queries to avoid missing information
□ Check for environment/tool-specific variations

<research_quality_assurance>
Before completing research, perform these checks:

<completeness_check>
- [ ] All enumerated options/components documented with evidence
- [ ] Each access method/approach evaluated against ALL requirements
- [ ] Official documentation cited for critical claims
- [ ] Contradictory information resolved or flagged

<source_verification>
- [ ] Primary claims backed by official/authoritative sources
- [ ] Version numbers and dates included where relevant
- [ ] Actual URLs provided (not just "search for X")
- [ ] Distinguish verified facts from assumptions

<blind_spots_review>
Ask yourself: "What might I have missed?"
- [ ] Are there configuration/implementation options I didn't investigate?
- [ ] Did I check for multiple environments/contexts (e.g., Desktop vs Code)?
- [ ] Did I verify claims that seem definitive ("cannot", "only", "must")?
- [ ] Did I look for recent changes or updates to documentation?

<critical_claims_audit>
For any statement like "X is not possible" or "Y is the only way":
- [ ] Is this verified by official documentation?
- [ ] Have I checked for recent updates that might change this?
- [ ] Are there alternative approaches I haven't considered?

<output_structure>
Save to: `.prompts/{num}-{topic}-research/{topic}-research.md`

Structure findings using this XML format:

```xml
<research>
  
## Summary

{2-3 paragraph executive summary of key findings}
  

  <findings>
    <finding category="{category}">
      <title>{Finding title}
      <detail>{Detailed explanation}
      <source>{Where this came from}
      <relevance>{Why this matters for the goal}
    
    <!-- Additional findings -->
  

  <recommendations>
    <recommendation priority="high">
      <action>{What to do}
      
## Rationale

{Why}
    
    <!-- Additional recommendations -->
  

  <code_examples>
    {Relevant code patterns, snippets, configurations}
  

  <metadata>
    
### {high|medium|low}

{Why this confidence level}
    
    
## Dependencies

{What's needed to act on this research}
    
    <open_questions>
      {What couldn't be determined}
    
    
## Assumptions

{What was assumed}
    

    <!-- ENHANCED: Research Quality Report -->
    <quality_report>
      <sources_consulted>
        {List URLs of official documentation and primary sources}
      
      <claims_verified>
        {Key findings verified with official sources}
      
      <claims_assumed>
        {Findings based on inference or incomplete information}
      
      <contradictions_encountered>
        {Any conflicting information found and how resolved}
      
      <confidence_by_finding>
        {For critical findings, individual confidence levels}
        - Finding 1: High (official docs + multiple sources)
        - Finding 2: Medium (single source, unclear if current)
        - Finding 3: Low (inferred, requires hands-on verification)
      
    
  

```

<pre_submission_checklist>
Before submitting your research report, confirm:

**Scope Coverage**
- [ ] All enumerated options/approaches investigated
- [ ] Each component from verification checklist documented or marked "not found"
- [ ] Official documentation cited for all critical claims

**Claim Verification**
- [ ] Each "not possible" or "only way" claim verified with official docs
- [ ] URLs to official documentation included for key findings
- [ ] Version numbers and dates specified where relevant

**Quality Controls**
- [ ] Blind spots review completed ("What did I miss?")
- [ ] Quality report section filled out honestly
- [ ] Confidence levels assigned with justification
- [ ] Assumptions clearly distinguished from verified facts

**Output Completeness**
- [ ] All required XML sections present
- [ ] SUMMARY.md created with substantive one-liner
- [ ] Sources consulted listed with URLs
- [ ] Next steps clearly identified

```

<incremental_output>
**CRITICAL: Write findings incrementally to prevent token limit failures**

Instead of generating the full research in memory and writing at the end:
1. Create the output file with initial structure
2. Write each finding as you discover it
3. Append code examples as you find them
4. Update metadata at the end

This ensures:
- Zero lost work if token limit is hit
- File contains all findings up to that point
- No estimation heuristics needed
- Works for any research size

## Workflow

Step 1 - Initialize structure:
```bash
# Create file with skeleton
Write: .prompts/{num}-{topic}-research/{topic}-research.md
Content: Basic XML structure with empty sections
```

Step 2 - Append findings incrementally:
```bash
# After researching authentication libraries
Edit: Append <finding> to <findings> section

# After discovering rate limits
Edit: Append another <finding> to <findings> section
```

Step 3 - Add code examples as discovered:
```bash
# Found jose example
Edit: Append to <code_examples> section
```

Step 4 - Finalize metadata:
```bash
# After completing research
Edit: Update <metadata> section with confidence, dependencies, etc.
```

<example_prompt_instruction>
```xml
<output_requirements>
Write findings incrementally to {topic}-research.md as you discover them:

1. Create the file with this initial structure:
   ```xml
   <research>
     
## Summary

[Will complete at end]
     <findings>
     <recommendations>
     <code_examples>
     <metadata>
   
   ```

2. As you research each aspect, immediately append findings:
   - Research JWT libraries → Write finding
   - Discover security pattern → Write finding
   - Find code example → Append to code_examples

3. After all research complete:
   - Write summary (synthesize all findings)
   - Write recommendations (based on findings)
   - Write metadata (confidence, dependencies, etc.)

This incremental approach ensures all work is saved even if execution
hits token limits. Never generate the full output in memory first.

```

## Benefits

**vs. Pre-execution estimation:**
- No estimation errors (you don't predict, you just write)
- No artificial modularization (agent decides natural breakpoints)
- No lost work (everything written is saved)

**vs. Single end-of-execution write:**
- Survives token limit failures (partial progress saved)
- Lower memory usage (write as you go)
- Natural checkpoint recovery (can continue from last finding)

<summary_requirements>
Create `.prompts/{num}-{topic}-research/SUMMARY.md`

Load template: [summary-template.md](summary-template.md)

For research, emphasize key recommendation and decision readiness. Next step typically: Create plan.

## Success Criteria

- All scope questions answered
- All verification checklist items completed
- Sources are current and authoritative
- Findings are actionable
- Metadata captures gaps honestly
- Quality report distinguishes verified from assumed
- SUMMARY.md created with substantive one-liner
- Ready for planning/implementation to consume

```

<key_principles>

<structure_for_consumption>
The next Claude needs to quickly extract relevant information:
```xml
<finding category="authentication">
  <title>JWT vs Session Tokens
  <detail>
    JWTs are preferred for stateless APIs. Sessions better for
    traditional web apps with server-side rendering.
  
  <source>OWASP Authentication Cheatsheet 2024
  <relevance>
    Our API-first architecture points to JWT approach.
  

```

<include_code_examples>
The implementation prompt needs patterns to follow:
```xml
<code_examples>

## Example

```typescript
import { jwtVerify } from 'jose';

const { payload } = await jwtVerify(
  token,
  new TextEncoder().encode(secret),
  { algorithms: ['HS256'] }
);
```
Source: jose library documentation

```

<explicit_confidence>
Help the next Claude know what to trust:
```xml
<metadata>
  
### medium

API documentation is comprehensive but lacks real-world
    performance benchmarks. Rate limits are documented but
    actual behavior may differ under load.
  

  <quality_report>
    <confidence_by_finding>
      - JWT library comparison: High (npm stats + security audits + active maintenance verified)
      - Performance benchmarks: Low (no official data, community reports vary)
      - Rate limits: Medium (documented but not tested)
    
  

```

<enumerate_known_possibilities>
When researching systems with known components, enumerate them explicitly:
```xml
<verification_checklist>
**CRITICAL**: Verify ALL configuration scopes:
□ User scope - Global configuration
□ Project scope - Project-level configuration files
□ Local scope - Project-specific user overrides
□ Environment scope - Environment variable based

```

This forces systematic coverage and prevents omissions.

<research_types>

<technology_research>
For understanding tools, libraries, APIs:

```xml
<research_objective>
Research JWT authentication libraries for Node.js.

Purpose: Select library for auth implementation
Scope: Security, performance, maintenance status
Output: jwt-research.md

<research_scope>
<include>
- Available libraries (jose, jsonwebtoken, etc.)
- Security track record
- Bundle size and performance
- TypeScript support
- Active maintenance
- Community adoption

<exclude>
- Implementation details (for planning phase)
- Specific code architecture (for implementation)

<sources>
Official documentation (use WebFetch):
- https://github.com/panva/jose
- https://github.com/auth0/node-jsonwebtoken

Additional sources (use WebSearch):
- "JWT library comparison {current_year}"
- "jose vs jsonwebtoken security {current_year}"
- npm download stats
- GitHub issues/security advisories

<verification_checklist>
□ Verify all major JWT libraries (jose, jsonwebtoken, passport-jwt)
□ Check npm download trends for adoption metrics
□ Review GitHub security advisories for each library
□ Confirm TypeScript support with examples
□ Document bundle sizes from bundlephobia or similar

```

<best_practices_research>
For understanding patterns and standards:

```xml
<research_objective>
Research authentication security best practices.

Purpose: Inform secure auth implementation
Scope: Current standards, common vulnerabilities, mitigations
Output: auth-security-research.md

<research_scope>
<include>
- OWASP authentication guidelines
- Token storage best practices
- Common vulnerabilities (XSS, CSRF)
- Secure cookie configuration
- Password hashing standards

<sources>
Official sources (use WebFetch):
- https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html
- https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html

Search sources (use WebSearch):
- "OWASP authentication {current_year}"
- "secure token storage best practices {current_year}"

<verification_checklist>
□ Verify OWASP top 10 authentication vulnerabilities
□ Check latest OWASP cheatsheet publication date
□ Confirm recommended hash algorithms (bcrypt, scrypt, Argon2)
□ Document secure cookie flags (httpOnly, secure, sameSite)

```

<api_service_research>
For understanding external services:

```xml
<research_objective>
Research Stripe API for payment integration.

Purpose: Plan payment implementation
Scope: Endpoints, authentication, webhooks, testing
Output: stripe-research.md

<research_scope>
<include>
- API structure and versioning
- Authentication methods
- Key endpoints for our use case
- Webhook events and handling
- Testing and sandbox environment
- Error handling patterns
- SDK availability

<exclude>
- Pricing details
- Account setup process

<sources>
Official sources (use WebFetch):
- https://stripe.com/docs/api
- https://stripe.com/docs/webhooks
- https://stripe.com/docs/testing

Context7 MCP:
- Use mcp__context7__resolve-library-id for Stripe
- Use mcp__context7__get-library-docs for current patterns

<verification_checklist>
□ Verify current API version and deprecation timeline
□ Check webhook event types for our use case
□ Confirm sandbox environment capabilities
□ Document rate limits from official docs
□ Verify SDK availability for our stack

```

<comparison_research>
For evaluating options:

```xml
<research_objective>
Research database options for multi-tenant SaaS.

Purpose: Inform database selection decision
Scope: PostgreSQL, MongoDB, DynamoDB for our use case
Output: database-research.md

<research_scope>
<include>
For each option:
- Multi-tenancy support patterns
- Scaling characteristics
- Cost model
- Operational complexity
- Team expertise requirements

<evaluation_criteria>
- Data isolation requirements
- Expected query patterns
- Scale projections
- Team familiarity

<verification_checklist>
□ Verify all candidate databases (PostgreSQL, MongoDB, DynamoDB)
□ Document multi-tenancy patterns for each with official sources
□ Compare scaling characteristics with authoritative benchmarks
□ Check pricing calculators for cost model verification
□ Assess team expertise honestly (survey if needed)

```

## Metadata Guidelines

Load: [metadata-guidelines.md](metadata-guidelines.md)

**Enhanced guidance**:
- Use <quality_report> to distinguish verified facts from assumptions
- Assign confidence levels to individual findings when they vary
- List all sources consulted with URLs for verification
- Document contradictions encountered and how resolved
- Be honest about limitations and gaps in research

<tool_usage>

<context7_mcp>
For library documentation:
```
Use mcp__context7__resolve-library-id to find library
Then mcp__context7__get-library-docs for current patterns
```
</context7_mcp>

<web_search>
For recent articles and updates:
```
Search: "{topic} best practices {current_year}"
Search: "{library} security vulnerabilities {current_year}"
Search: "{topic} vs {alternative} comparison {current_year}"
```

<web_fetch>
For specific documentation pages:
```
Fetch official docs, API references, changelogs with exact URLs
Prefer WebFetch over WebSearch for authoritative sources
```

Include tool usage hints in research prompts when specific sources are needed.

<pitfalls_reference>
Before completing research, review common pitfalls:
Load: [research-pitfalls.md](research-pitfalls.md)

Key patterns to avoid:
- Configuration scope assumptions - enumerate all scopes
- "Search for X" vagueness - provide exact URLs
- Deprecated vs current confusion - check changelogs
- Tool-specific variations - check each environment