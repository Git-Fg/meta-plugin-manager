# Quick Reference

## Skill Calling Cheat Sheet

```
Need orchestration? → Hub (regular) calls Workers (forked)
Need data transfer? → Use parameters (args="key=value")
Need isolation? → Forked skill (context: fork)
Need control return? → Forked skill (not regular)
Need nested workflows? → Forked can call forked (validated)
Need autonomy? → 80-95% without questions
Need custom tools? → Custom subagent (tools + model fields)
```

## Decision Tree

```
├─ Multi-step workflow?
│  └─ Yes → Use forked skills (context: fork)
│
├─ Need to aggregate results?
│  └─ Yes → ALL workers MUST be forked
│
├─ Need caller context?
│  ├─ Yes → DON'T fork
│  └─ No → Use fork (context: fork)
│
├─ Need parallel execution?
│  └─ Yes → Use forked skills (security isolation)
│
└─ Need custom tools?
   └─ Yes → Custom subagent (tools + model)
```

## Testing Commands (from skills/claude-cli-non-interactive/references/patterns.md)

### Skill Discovery Test
```bash
!pwd
mkdir <use-actual-path>test-discovery
cd <use-actual-path>test-discovery && claude --dangerously-skip-permissions -p "List all available skills" --output-format stream-json --verbose --debug --no-session-persistence --max-turns 5 > <use-actual-path>test-discovery/test-output.json 2>&1
cat <use-actual-path>test-discovery/test-output.json
```
**Verify**: Line 1 shows your test skills in `"skills"` array.

### Autonomy Test
```bash
!pwd
mkdir <use-actual-path>test-autonomy
cd <use-actual-path>test-autonomy && claude --dangerously-skip-permissions -p "Create README with project structure" --output-format stream-json --verbose --debug --no-session-persistence --max-turns 8 > <use-actual-path>test-autonomy/test-output.json 2>&1
cat <use-actual-path>test-autonomy/test-output.json
```
**Verify**: No `"permission_denials"` in line 3, README created.

### Context Fork Isolation Test
```bash
!pwd
mkdir <use-actual-path>test-fork
# Create forked skill with context: fork in frontmatter
cd <use-actual-path>test-fork && claude --dangerously-skip-permissions -p "Call forked skill, verify context isolation" --output-format stream-json --verbose --debug --no-session-persistence --max-turns 15 > <use-actual-path>test-fork/test-output.json 2>&1
cat <use-actual-path>test-fork/test-output.json
```
**Verify**: Forked skill executes without accessing main conversation variables.

## Parameter Passing Pattern

**Caller invokes with:**
```yaml
Skill("analyze-data", args="dataset=production_logs timeframe=24h")
```

**Forked skill receives via $ARGUMENTS:**
```yaml
---
name: analyze-data
context: fork
---
Scan $ARGUMENTS:
1. Parse: dataset=production_logs timeframe=24h
2. Execute analysis
3. Output: ## ANALYZE_COMPLETE
```

## Context Isolation Model

**🔒 SECURITY ISOLATION**: Forked skills cannot access:
- Caller's conversation history
- User preferences (user_preference, session_id)
- Context variables (project_codename, etc.)
- Caller's session state

**✅ WHAT PASSES**:
- Parameters via `args` (proper data transfer method)
- Their own isolated execution context
- Files they create/modify

**🛡️ USE FOR**:
- Parallel processing (secure isolation)
- Untrusted code execution (security barrier)
- Multi-tenant processing (isolated contexts)
- Noisy operations (keep main context clean)

**❌ DON'T FORK WHEN**:
- Need conversation history
- Need user preferences
- Need previous workflow steps
- Simple sequential tasks

## Autonomy Levels (from skills/claude-cli-non-interactive/references/autonomy-scoring.md)

**Check test-output.json line 3:**
```json
"permission_denials": [
  {
    "tool_name": "AskUserQuestion",
    "tool_input": { "questions": [...] }
  }
]
```

| Score | Questions | Grade |
|-------|-----------|-------|
| 95% | 0-1 | Excellence |
| 85% | 2-3 | Good |
| 80% | 4-5 | Acceptable |
| <80% | 6+ | Fail |

## Skill Completion Markers

**Each skill must output:**
```
## SKILL_NAME_COMPLETE
```

**Expected formats:**
- `## SKILL_A_COMPLETE`
- `## FORKED_OUTER_COMPLETE`
- `## CUSTOM_AGENT_COMPLETE`
- `## ANALYZE_COMPLETE`

## Test-Validated Patterns (from tests/results/TEST_RESULTS_SUMMARY.md)

✅ **Test 2.2**: Context isolation confirmed
✅ **Test 2.3**: 100% autonomy validated
✅ **Test 3.2**: Custom subagents work (Read+Grep, Haiku)
✅ **Test 4.2**: Nested forks validated
✅ **Test 5.1**: Parameter passing works
✅ **Test 7.1**: Hub-and-spoke pattern validated

## Testing Workflow

**MANDATORY**:
1. **First**: Call `tool-analyzer` skill to automate pattern detection
2. **Then**: Read full log manually if analyzer output unclear
3. **Watch for**: synthetic skill use (hallucinated) vs. real tool/task/skill use

**NEVER**:
- Create test runner scripts (run_*.sh, batch_*.sh)
- Use `cd` to navigate (unreliable)
- Run multiple tests in monitoring loops

## Project Structure Quick Reference

```
.claude/
├── skills/                      # Skills are PRIMARY building blocks
│   └── skill-name/
│       ├── SKILL.md            # <500 lines (Tier 2)
│       └── references/          # On-demand (Tier 3)
├── agents/                      # Context fork isolation
├── hooks/                       # Event automation
├── commands/                     # Legacy: manual workflows
├── settings.json                # Project-wide hooks & configuration
├── settings.local.json          # Local overrides (gitignored)
└── .mcp.json                   # MCP server configuration
```

## Router Logic (from toolkit-architect/SKILL.md)

**Route to specialized architects:**
- "I need a skill" → Route to skills-architect
- "I want web search" → Route to mcp-architect
- "I need hooks" → Route to hooks-architect
- "I need a PR reviewer" → Route to skills-architect or subagents-architect

## When in Doubt

**Most customization needs** met by CLAUDE.md + one Skill.

**Build from skills up** - Every capability should be a Skill first. Commands and Subagents are orchestrators, not creators.

**Reference**: [Official docs](https://agentskills.io/home)

## Quality Gate

All skills must score ≥80/100 on 11-dimensional framework before production.

**Reference**: [CLAUDE.md rules/quality-framework](rules/quality-framework.md)
