# Three-Way Audit Patterns

## Navigation

| If you need... | Read this section... |
| :------------- | :------------------- |
| Review framework | ## The Review Framework |
| Investigation phases | ## Investigation Phases |
| Issue classification | ## Issue Classification |
| Feedback format | ## Feedback Format |
| Component detection | ## Component Type Detection |
| Validation questions | ## Recognition Questions |

## The Review Framework

Audit alignment between three dimensions:

1. **Request** - What user explicitly asked for
2. **Delivery** - What was actually implemented
3. **Standards** - What meta-development skills specify

## Investigation Phases

### Phase 1: Scan Context

1. Review conversation history
2. Examine user's original request
3. Analyze agent actions and outputs
4. Identify constraints specified

### Phase 2: Extract Request

- What was explicitly asked for?
- What constraints were specified?
- What goals were implied?

### Phase 3: Analyze Delivery

- What was implemented?
- How was it executed?
- What deviations occurred?

### Phase 4: Compare with Standards

Load appropriate meta-skill:

| Component Type  | Load This Skill         |
| --------------- | ----------------------- |
| Skills/Commands | `invocable-development` |
| Agents          | `agent-development`     |
| Hooks           | `hook-development`      |
| MCPs            | `mcp-development`       |

### Phase 5: Identify Gaps

- Intent misalignment
- Standards violations
- Completeness issues
- Quality concerns

## Issue Classification

| Severity     | Criteria                                                                 | Action                 |
| ------------ | ------------------------------------------------------------------------ | ---------------------- |
| **Critical** | Security vulnerability, complete misalignment, missing core requirements | Block, fix immediately |
| **High**     | Significant drift, incomplete implementation, reliability issues         | Fix before merge       |
| **Medium**   | Minor deviations, documentation gaps                                     | Fix in follow-up       |
| **Low**      | Cosmetic issues, nice-to-have enhancements                               | Consider for later     |

## Feedback Format

```markdown
## Meta-Critic Review

### Critical Issues (Blocking)

- **File**: path/to/file
- **Issue**: Description
- **Standard**: Reference to meta-skill
- **Fix**: Specific change required

### High Priority Issues

[Same format]

### Medium Priority Issues

[Same format]

### Low Priority Issues

[Same format]
```

## Component Type Detection

| If path contains...     | Component Type | Meta-Skill to Load    |
| ----------------------- | -------------- | --------------------- |
| .mcp.json, McpServer    | MCP Server     | mcp-development       |
| .claude/skills/         | Skill          | invocable-development |
| .claude/commands/       | Command        | invocable-development |
| .claude/agents/         | Agent          | agent-development     |
| PreToolUse, PostToolUse | Hook           | hook-development      |

## Recognition Questions

- "Does this review provide specific, actionable feedback?"
- "Are file:line references included for every issue?"
- "Is the applicable meta-skill referenced?"
- "Is severity classification clear and appropriate?"
