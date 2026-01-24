# Skills Specification

## Summary
This specification defines the behavioral requirements, architectural patterns, and quality standards for skills in the Agent Skills ecosystem.

## Context Fork Requirements

### Critical Requirement: Forked Skills for Hub-Spoke Pattern
**Status**: CURRENTLY UNIMPLEMENTED - 0 of 18 skills use `context: fork`

**Requirement**: For hub-spoke workflows, ALL delegate worker skills MUST use `context: fork` in their YAML frontmatter.

**Evidence Gap**:
- Specification emphasizes `context: fork` as essential
- Zero production skills implement this pattern
- Test results validate the pattern works in isolation

**Implementation Requirement**:
- Hub skill: regular (no context: fork)
- Worker skills: MUST use `context: fork`
- Enable aggregation: ALL workers must use fork

**YAML Frontmatter Example**:
```yaml
---
name: worker-skill-name
context: fork  # CRITICAL for hub-spoke pattern
user-invocable: true
---
```

## Given-When-Then Acceptance Criteria

### G1: Skill Structure
**Given** a new skill in `.claude/skills/skill-name/SKILL.md`
**When** the skill is invoked
**Then** it MUST have:
- YAML frontmatter with name, description, user-invocable
- SKILL.md <500 lines OR references/ directory present
- WIN CONDITION marker output

### G2: Context Fork Behavior
**Given** a skill with `context: fork` in frontmatter
**When** invoked by a hub skill
**Then** it MUST:
- Execute in isolated context
- NOT have access to caller's conversation history
- Accept parameters via $ARGUMENTS
- Complete with WIN CONDITION marker

### G3: Progressive Disclosure
**Given** a skill with >500 lines in SKILL.md
**When** it exceeds the limit
**Then** it MUST:
- Create references/ directory
- Extract detailed content to references/ files
- Maintain SKILL.md <500 lines

### G4: Hub-Spoke Pattern
**Given** a hub skill delegating to workers
**When** workers need to aggregate results
**Then** ALL workers MUST:
- Use `context: fork` in frontmatter
- Execute with context isolation
- Return results to hub for aggregation

### G5: WIN CONDITION Markers
**Given** a skill execution
**When** it completes successfully
**Then** it MUST output:
- `## SKILL_NAME_COMPLETE` (PascalCase from skill name)
- Marker appears at end of execution

## Input/Output Examples

### Example 1: Regular Skill
**Input**: Skill invocation
```yaml
Skill("toolkit-architect", args="component=skills")
```

**Output**:
```
## TOOLKIT_ARCHITECT_COMPLETE
```

### Example 2: Forked Worker Skill
**Input**: Hub calls worker with parameters
```yaml
Skill("knowledge-worker", args="topic=architecture depth=detailed")
```

**Worker Execution**:
- Isolated context (no access to hub's conversation)
- Parameters parsed from $ARGUMENTS
- Execution complete with marker

**Output**:
```
## KNOWLEDGE_WORKER_COMPLETE
```

### Example 3: Progressive Disclosure Refactor
**Given**: SKILL.md with 600 lines
**When**: Exceeds 500 line limit
**Action**:
1. Create references/ directory
2. Move detailed sections to references/
3. Keep SKILL.md at 450 lines

**After**:
```
.claude/skill-name/
├── SKILL.md (450 lines - workflows and examples)
└── references/
    ├── deep-details.md
    ├── troubleshooting.md
    └── patterns.md
```

## Edge Cases and Error Conditions

### E1: Missing WIN Condition Marker
**Condition**: Skill completes without marker
**Error**: `SKILL_COMPLETION_ERROR` - Missing required WIN CONDITION marker
**Resolution**: Add marker following naming convention

### E2: Oversized SKILL.md Without References
**Condition**: SKILL.md >500 lines, no references/ directory
**Error**: `PROGRESSIVE_DISCLOSURE_VIOLATION` - Must extract to references/
**Resolution**: Create references/ and move detailed content

### E3: Context Fork Without Worker Pattern
**Condition**: `context: fork` used without hub delegation
**Warning**: `CONTEXT_FORK_WARN` - Forking without hub pattern may lose project context
**Resolution**: Verify pattern requirements before forking

### E4: Hub-Spoke with Non-Forked Workers
**Condition**: Hub delegates to workers without `context: fork`
**Error**: `HUB_SPOKE_ERROR` - Workers must fork for aggregation
**Resolution**: Add `context: fork` to ALL worker skills

## Non-Functional Requirements

### Security
- Forked skills maintain complete context isolation
- No unauthorized access to caller's conversation or state
- Parameters passed via $ARGUMENTS only

### Performance
- Skill invocation completes within reasonable time limits
- Progressive disclosure reduces token load for simple operations
- Avoid deep nesting that impacts performance

### Maintainability
- Clear separation of concerns (Tier 1/2/3 structure)
- WIN CONDITION markers enable automation
- Context fork pattern documented and tested

## Behavioral Standards

### B1: Autonomy Requirements
Skills MUST achieve:
- 95% (Excellent): 0-1 questions during execution
- 85% (Good): 2-3 questions during execution
- 80% (Acceptable): 4-5 questions during execution
- <80% (Fail): 6+ questions (requires refactoring)

### B2: Workflow Pattern Selection
Choose pattern based on requirements:

| Requirement | Pattern | Context Fork Required |
|------------|---------|---------------------|
| Simple delegation | Regular skill | No |
| Result aggregation | Hub-Spoke | Yes (workers) |
| Isolated execution | Forked skill | Yes |
| Parallel processing | Forked skills | Yes (all) |

### B3: Naming Conventions
- Skill directories: kebab-case (skill-name)
- WIN markers: PascalCase (SKILL_NAME_COMPLETE)
- Frontmatter name: kebab-case
- Description: Clear, concise, actionable

## Quality Framework Integration

### Q1: 11-Dimensional Compliance
Skills must score ≥80/100 across:
1. Knowledge Delta - Expert-only content
2. Autonomy - 80-95% without questions
3. Discoverability - Clear triggers
4. Progressive Disclosure - Tier 1/2/3 structure
5. Clarity - Unambiguous instructions
6. Completeness - All scenarios covered
7. Standards Compliance - Agent Skills spec
8. Security - Safe execution
9. Performance - Efficient workflows
10. Maintainability - Well-structured
11. Innovation - Unique value

### Q2: Verification Process
Before production deployment:
1. Scan skill structure compliance
2. Verify WIN CONDITION marker present
3. Check progressive disclosure compliance
4. Validate context fork usage (if applicable)
5. Test autonomy score ≥80%

## Implementation Guidelines

### Step 1: Determine Skill Type
1. Is simple delegation needed? → Regular skill
2. Need result aggregation? → Hub-Spoke (fork workers)
3. Need isolation? → Forked skill
4. Need parallel execution? → Multiple forked skills

### Step 2: Implement Structure
1. Create directory in `.claude/skills/skill-name/`
2. Add YAML frontmatter with required fields
3. Write SKILL.md with workflows
4. Add WIN CONDITION marker

### Step 3: Progressive Disclosure Check
1. Count SKILL.md lines
2. If >500 lines: Create references/ directory
3. Extract detailed content to references/ files
4. Keep SKILL.md <500 lines

### Step 4: Verify Compliance
1. Check all acceptance criteria met
2. Validate quality framework score ≥80
3. Test autonomy requirements
4. Confirm WIN marker present

## Out of Scope

### Not Covered by This Specification
- Subagent architecture (see subagents.spec.md)
- Hooks configuration (see hooks.spec.md)
- MCP server setup (see mcp.spec.md)
- TaskList orchestration (see tasklist.spec.md)
- Testing frameworks (see quality.spec.md)

## Reference Implementations

### Examples to Study
- Context fork pattern: Not yet implemented (GAP)
- Progressive disclosure: toolkit-architect (good example)
- WIN markers: skills-architect, hooks-architect
- Hub-spoke: Not yet implemented (GAP)

## Status
- **CRITICAL GAP**: 0/18 skills implement context fork
- **VIOLATION**: 2 skills exceed 500-line limit (test-runner, ralph-orchestrator-expert)
- **MISSING**: WIN CONDITION marker (cat-detector)
- **NEEDS**: Hub-spoke production examples

## Fix Priority
1. **IMMEDIATE**: Implement context fork in production skills OR update spec to match reality
2. **SHORT**: Refactor oversized SKILL.md files
3. **SHORT**: Add missing WIN CONDITION marker
4. **MEDIUM**: Create hub-spoke examples
