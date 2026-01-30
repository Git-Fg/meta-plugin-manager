---
description: "Execute STRATEGY.md phases with parallel Task() batching and TDD prompt injection. Uses TodoWrite for phase-level tracking and /qa:verify-phase as gatekeeper. Primary command for executing planned work."
argument-hint:
  [
    path/to/STRATEGY.md or "auto" for latest or "--all" for all incomplete phases,
  ]
---

# Strategy Execution

**Parses STRATEGY.md, batches parallel tasks, injects TDD style**

## Quick Context

Executes STRATEGY.md phases with intelligent parallelization. Batches independent tasks into single Task() calls.

## Workflow

### 1. Identify Strategy

**Detect strategy location:**

| Arguments             | Action                          |
| --------------------- | ------------------------------- |
| `--all`               | Find all incomplete phases      |
| `auto` or empty       | Find next phase from ROADMAP.md |
| `path/to/STRATEGY.md` | Use specified strategy          |

**Discovery patterns:**

- `Glob: .claude/workspace/strategy/**/*-STRATEGY.md` → Collect strategies
- `Glob: .claude/workspace/strategy/**/phases/**/*` → Collect phases
- Identify incomplete: STRATEGY exists but phase not complete

### 2. Parse STRATEGY.md Structure

**Extract phases:**

1. Read STRATEGY.md
2. Parse `<phase>` tags to identify:
   - Phase ID and type (`sequential` | `parallel`)
   - Tasks within each phase
   - Task attributes (style, agent, checkpoint)
   - Gate criteria

**Phase type routing:**

| Phase Type   | Execution Pattern                          |
| ------------ | ------------------------------------------ |
| `sequential` | Execute tasks one after another            |
| `parallel`   | Batch independent tasks into single Task() |

### 3. TDD Style Injection

**For tasks with `style="tdd"`:**

Inject TDD prompt block before execution:

```markdown
<style_injection type="tdd">

## Identity: TDD Practitioner

You are a Test-Driven Development practitioner. For every behavior:

1. **RED**: Write a failing test that specifies the desired behavior
2. **GREEN**: Write minimal code to make the test pass
3. **REFACTOR**: Clean up code while tests remain green

**Critical Rules:**

- NO production code without a failing test first
- NO additional features in GREEN phase
- NO behavior changes in REFACTOR phase
- 80%+ code coverage required

</style_injection>
```

**For tasks with `style="reviewed"`:**

Inject additional review gate:

```markdown
<style_injection type="reviewed">

## Identity: Reviewed Developer

You are implementing with quality gates. After implementation:

1. Self-review against requirements
2. Run /verify --quick
3. Fix any issues before marking complete

</style_injection>
```

### 4. Native Agent Mapping

**Map `agent` attribute to native type:**

| Task Agent        | Native subagent_type | Use When                                 |
| ----------------- | -------------------- | ---------------------------------------- |
| `Explore`         | `Explore`            | Investigation, pattern discovery         |
| `Plan`            | `Plan`               | Architectural planning, design decisions |
| `general-purpose` | `general-purpose`    | Implementation, refactoring, bug fixes   |
| `Bash`            | `Bash`               | CLI operations, git, build commands      |

**Task dispatch pattern:**

```typescript
// Sequential phase - one task at a time
for (const task of phase.tasks) {
  const prompt = injectTdInjection(task.style) + task.content;
  Task({ subagent_type: task.agent, prompt });
  if (task.checkpoint !== "none") await checkpoint(task.checkpoint);
}

// Parallel phase - batch into single call
const parallelTasks = phase.tasks.filter((t) => t.depends === undefined);
const batchedPrompt = parallelTasks
  .map((t) => injectTdInjection(t.style) + t.content)
  .join("\n\n---\n\n");
Task({ subagent_type: parallelTasks[0].agent, prompt: batchedPrompt });
```

### 5. Phase Execution with Gate

**Execute phase:**

1. For each task in phase:
   - Inject TDD style if applicable
   - Dispatch to appropriate agent
   - Handle checkpoints

2. After all tasks complete:
   - Invoke `/qa:verify-phase` for gate check

```typescript
// Execute parallel phase
const parallelTasks = phase.tasks.filter((t) => t.depends === undefined);
const batchedPrompt = buildBatchedPrompt(parallelTasks);
Task({ subagent_type: "general-purpose", prompt: batchedPrompt });

// Gate check
await runCommand("/qa:verify-phase", { phase: phase.id, gate: phase.gate });
```

### 6. Update Tracking

After phase completes:

1. **TodoWrite**: Mark phase task complete via TaskUpdate
2. **STRATEGY.md**: Update phase status
3. **ROADMAP.md**: Update progress
4. **Commit**: If clean, commit phase completion

## Usage Patterns

**Execute all incomplete phases:**

```
/strategy:execute --all
```

**Auto-detect (execute next phase):**

```
/strategy:execute
```

**Explicit strategy:**

```
/strategy:execute .claude/workspace/strategy/auth/STRATEGY.md
```

## Success Criteria

- [ ] Correct strategy identified via Glob/Grep
- [ ] Parallel phases batched into single Task() calls
- [ ] TDD style injected for styled tasks
- [ ] Native agent mapping applied
- [ ] `/qa:verify-phase` gate passes
- [ ] TodoWrite phase tasks marked complete

---

<critical_constraint>
MANDATORY: Batch parallel tasks into single Task() call (one API message)

MANDATORY: Inject <style_injection> before TDD tasks

MANDATORY: Run /qa:verify-phase after every phase

MANDATORY: Phase-level TodoWrite tracking (not micro-tasks)
</critical_constraint>
