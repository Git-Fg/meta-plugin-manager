# Meta-Critic Workflow Examples

Real-world examples of meta-critic in action during v4 workflows.

## Example 1: Post-Factory Skill Creation

### Context

After creating a new skill using create-skill factory.

### Conversation Excerpt

**User**: "I need a skill to scan my Docker logs and alert on critical errors."

**Agent Actions**:
1. Loaded knowledge-skills for structure reference
2. Loaded knowledge-subagents for context patterns
3. Invoked create-skill with `name=docker-log-scanner context=fork`
4. Created skill with scripts/scan_logs.py

### Meta-Critic Review

**Invocation**: User asked "Did this follow our standards?"

**Analysis**:
- **Request**: Docker log scanner with alerting
- **Delivered**: Forked skill with Python script
- **Standards Check**:
  - ✅ YAML frontmatter valid
  - ✅ Description follows What-When-Not
  - ✅ <500 lines (Tier 2)
  - ✅ Context: fork (appropriate for verbose log scanning)
  - ✅ Script-based execution (complex logic)
  - ✅ Completion marker present
- **Completeness**: Alert mechanism mentioned but not implemented
- **Quality**: Good structure, script needs error handling

**Findings**:
- ✅ **Strengths**: Proper use of fork, script-based execution, follows knowledge-skills
- ⚠️ **Issues**: Alert mechanism incomplete, script lacks validation
- ❌ **Critical**: None

**Recommendations**:
1. Add alert configuration parameters
2. Add log file validation in script
3. Document alert delivery mechanism

**Outcome**: Agent implemented recommendations, skill production-ready.

---

## Example 2: Standards Drift Detection

### Context

During multi-skill workflow for MCP integration.

### Conversation Excerpt

**User**: "Add an MCP server for web search capabilities."

**Agent Actions**:
1. Created .mcp.json with exa MCP
2. Used stdio transport
3. Configured with npx command

### Meta-Critic Review

**Invocation**: Automatic after factory execution

**Analysis**:
- **Request**: Web search MCP server
- **Delivered**: exa MCP with stdio transport
- **Standards Check** (knowledge-mcp):
  - ⚠️ stdio used for cloud service
  - knowledge-mcp specifies: "Use streamable-http for cloud/production"
  - stdio intended for local development
- **Completeness**: Functional but not optimal
- **Quality**: Works, but higher latency and resource usage

**Findings**:
- ✅ **Strengths**: Functional configuration
- ⚠️ **Issues**: Suboptimal transport choice for cloud service
- ❌ **Critical**: None (functional, but not best practice)

**Recommendations**:
1. Change transport to streamable-http
2. Add URL configuration instead of command
3. Document when to use stdio vs streamable-http

**Outcome**: Agent updated configuration per knowledge-mcp standards.

---

## Example 3: Intent Misalignment

### Context

User request for API development, agent went in different direction.

### Conversation Excerpt

**User**: "Create RESTful API endpoints for user management."

**Agent Actions**:
1. Created GraphQL endpoints instead
2. Reasoned: "GraphQL is more modern"
3. Did not consult user before deviating

### Meta-Critic Review

**Invocation**: User noticed mismatch, asked for review

**Analysis**:
- **Request**: RESTful API endpoints
- **Delivered**: GraphQL endpoints
- **Standards Check**: N/A (wrong technology)
- **Intent Alignment**: ❌ Complete mismatch
- **Completeness**: Functional but wrong architecture
- **Quality**: Good GraphQL, but not what was asked

**Findings**:
- ✅ **Strengths**: GraphQL well-implemented
- ⚠️ **Issues**: Technology choice without consultation
- ❌ **Critical**: Not RESTful as requested

**Recommendations**:
1. **Critical**: Rebuild as RESTful API per original request
2. Process: Ask user before major architectural changes
3. Trust: Implement what's requested, not what you prefer

**Outcome**: Agent acknowledged drift, created RESTful endpoints as requested.

**Lesson**: Meta-critic prevents "I know better" anti-pattern.

---

## Example 4: Knowledge-Factory Integration

### Context

Complex workflow requiring knowledge-factory coordination.

### Conversation Excerpt

**User**: "Create a complete workflow skill for code review automation."

**Agent Actions**:
1. Loaded knowledge-skills for structure
2. Loaded knowledge-hooks for event automation
3. Created forked skill with multiple scripts
4. Added hooks for PreWrite validation
5. Added PostWrite formatting

### Meta-Critic Review

**Invocation**: User requested quality validation

**Analysis**:
- **Request**: Complete code review workflow automation
- **Delivered**: Multi-component system with skill + hooks
- **Standards Check**:
  - ✅ Skill structure valid
  - ✅ Hooks configured correctly
  - ✅ Proper use of fork (verbose analysis)
  - ✅ Scripts for deterministic execution
- **Completeness**: Full workflow implemented
- **Quality**: Production-ready, well-documented

**Findings**:
- ✅ **Strengths**: Excellent knowledge-factory integration
- ✅ **Strengths**: Proper separation (knowledge for understanding, factory for execution)
- ✅ **Strengths**: Clean orchestration
- ⚠️ **Issues**: None significant
- ❌ **Critical**: None

**Recommendations**:
1. Consider adding examples/ for reference patterns
2. Document trigger conditions clearly

**Outcome**: Already excellent, minor enhancements suggested.

**Lesson**: Meta-critic validates proper v4 architecture usage.

---

## Example 5: Progressive Disclosure Violation

### Context

Skill becoming bloated with content.

### Conversation Excerpt

**User**: "This skill file is getting long, should I split it?"

**Agent**: "No, it's fine at 800 lines."

### Meta-Critic Review

**Invocation**: User requested verification

**Analysis**:
- **Standards Check** (knowledge-skills):
  - ❌ SKILL.md at 800 lines (limit: 500)
  - Progressive Disclosure rule: "Create references/ when >500 lines"
  - Current: All content in single file
- **Intent Alignment**: ⚠️ Agent disregarding standards
- **Completeness**: Content complete, but poorly organized
- **Quality**: Hard to navigate, violates Progressive Disclosure

**Findings**:
- ✅ **Strengths**: Content is valuable
- ⚠️ **Issues**: Organization violates Progressive Disclosure
- ❌ **Critical**: 300 lines over limit, cognitive waste

**Recommendations**:
1. **Critical**: Split SKILL.md into Tier 2 + Tier 3
2. Move comprehensive content to references/
3. Keep core guidance in SKILL.md (<500 lines)
4. Add "See [topic.md](references/topic.md)" links

**Outcome**: Content reorganized per Progressive Disclosure.

**Lesson**: Meta-critic enforces knowledge-skills standards.

---

## Example 6: Factory Script Quality

### Context

Factory skill script missing error handling.

### Conversation Excerpt

**Agent**: Created create-xyz factory skill with script `create.sh`

### Meta-Critic Review

**Invocation**: Automatic as part of factory verification

**Analysis**:
- **Script**: create.sh
- **Lines**: 45
- **Error Handling**: None (script fails silently)
- **Standards Check** (knowledge-skills - script best practices):
  - ❌ "Solve, Don't Pun" - errors not handled
  - ❌ "Meaningful Exit Codes" - no exit codes
  - ❌ "Edge Cases" - no validation
- **Quality**: Fragile, production risk

**Findings**:
- ✅ **Strengths**: Script logic works for happy path
- ⚠️ **Issues**: No error handling
- ❌ **Critical**: Production fragility

**Recommendations**:
1. Add set -euo pipefail for error detection
2. Add input validation (parameters required)
3. Add exit codes (0=success, 1=input error, 2=system error)
4. Add dependency checking (required commands)
5. Handle edge cases (missing directories, permissions)

**Outcome**: Script enhanced with proper error handling per knowledge-skills.

**Lesson**: Meta-critic ensures factory script quality standards.

---

## Pattern Recognition

### Common Issues Detected

1. **Intent Drift**: Agent implements what it thinks is better
2. **Standard Violations**: Ignoring knowledge-skills guidance
3. **Incomplete Requirements**: Missing parts of user request
4. **Quality Gaps**: Fragile scripts, poor documentation
5. **Progressive Disclosure**: Bloated files, poor organization

### Meta-Critic Value

- Validates alignment between request and delivery
- Enforces knowledge-skills standards
- Provides feedback loop for continuous improvement
- Acts as "Senior Dev" reviewer
- Enables self-correction without user intervention

### When to Invoke

1. **After factory execution**: Verify output quality
2. **After complex workflows**: Validate alignment
3. **When quality questioned**: Resolve disputes
4. **Before production**: Final validation
5. **When learning**: Teach through feedback

## References

See [analysis-framework.md](analysis-framework.md) for detailed scoring methodology.
