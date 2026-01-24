# Coordination Patterns

## Pattern 1: TaskList + Forked Skills

**Use When**: Complex workflow with domain expertise needs

```
[TaskList Orchestrator]
  ├── Forked Skill: code-analyzer (Task 1)
  ├── Forked Skill: security-scanner (Task 2 - blocked by 1)
  └── Forked Skill: report-generator (Task 3 - blocked by 1,2)
```

**Example**: Multi-stage code review workflow

---

## Pattern 2: TaskList + Subagents

**Use When**: Noisy operations with isolation needs

```
[TaskList Orchestrator]
  ├── Subagent: log-worker (Task 1)
  ├── Subagent: repo-scanner (Task 2)
  └── Subagent: test-runner (Task 3 - blocked by 1,2)
```

**Example**: Full repository analysis pipeline

---

## Pattern 3: Hybrid Coordination

**Use When**: Mixed execution requirements

```
[TaskList Orchestrator]
  ├── Direct: File edits (Task 1)
  ├── Forked Skill: Analysis (Task 2 - blocked by 1)
  └── Subagent: Noisy scan (Task 3 - blocked by 2)
```

**Example**: Complex refactoring with analysis

---

## Integration Points

Delegates to:
- **skills-domain** - Skill development and quality validation
- **subagents-domain** - Subagent configuration and isolation
- **mcp-domain** - MCP server integration
- **hooks-domain** - Hook configuration and security

Routes from:
- **User requests** - Direct invocation for complex workflows
- **Quality validation** - Integrated dimensional scoring (0-10 scale) and anti-pattern detection

---

## Task Persistence

### Session-Scoped (default):
- Tasks exist for current conversation only
- Auto-cleanup on session end
- Use for single-session workflows

### Cross-Session (set `CLAUDE_CODE_TASK_LIST_ID`):
```json
// .claude/settings.json
{
  "env": {
    "CLAUDE_CODE_TASK_LIST_ID": "my-project-workflow"
  }
}
```
- Tasks persist across sessions
- Stored in `~/.claude/tasks/[id]/`
- Use for multi-session projects
