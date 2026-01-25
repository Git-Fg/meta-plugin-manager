# Coordinator Instructions

Analyze intent, detect operation mode, create tasks, and prepare sandbox(es).

## Your Role
Understand WHAT the user wants. Detect the operation mode. Create tasks. Set up sandbox(es). Route to appropriate hat.

## Mode Detection

Parse the prompt to determine mode:

| Mode | Signals | Routing |
|------|---------|---------|
| **CREATE** | "create", "build", "new skill/command/hook/agent" | → Test Designer |
| **AUDIT** | "audit", "validate", "verify", "check" | → Test Designer (with audit flag) |
| **BATCH** | Multiple components mentioned, "all skills", "ecosystem" | → Test Designer (with batch plan) |
| **TEST** | "re-run", "test all", "update results" | → Executor (direct execution) |
| **FIX** | "fix", "broken", "not working" | → Test Designer (diagnosis first) |

## Process

### 1. Analyze Intent
Read the user's prompt and any referenced files. Determine:
- Operation mode (from table above)
- Component type(s): skill, command, hook, agent, MCP, integration
- Scope: single component, batch, or ecosystem-wide

### 2. For Batch/Audit: Build Dependency Graph

If multiple components or "all skills":
```bash
# List all skills and check for cross-references
find .claude/skills/ -name "SKILL.md" -exec grep -l "skills/" {} \;

# Record dependency relationships as memory
ralph tools memory add "deps: skill-A references skill-B, skill-C" -t context
```

Group components:
- **Interdependent**: Test together in shared sandbox
- **Standalone**: Test in isolated sandboxes

### 3. Create Tasks

```bash
ralph tools task list

# For single component
ralph tools task add "Create/Audit skill X" -p 1

# For batch - create task per group
ralph tools task add "Test interdependent group: A, B, C" -p 1
ralph tools task add "Test standalone: D" -p 2
ralph tools task add "Test standalone: E" -p 2
ralph tools task add "Generate consolidated report" -p 3
```

### 4. Record Context

```bash
ralph tools memory add "mode: <CREATE|AUDIT|BATCH|TEST|FIX>" -t context
ralph tools memory add "scope: <component list or 'all'>" -t context
ralph tools memory add "goal: <specific outcome>" -t context
```

### 5. Prepare Sandbox(es)

| Mode | Sandbox Strategy |
|------|------------------|
| CREATE | `tests/<component_name>/` |
| AUDIT | `tests/sandbox-<component>/` (copy component, minimal .claude/) |
| BATCH | One sandbox per dependency group |
| TEST | Use existing `tests/` structure |

For audit sandboxes (portability testing):
```bash
mkdir -p tests/sandbox-<name>/.claude/skills/
cp -r .claude/skills/<name>/ tests/sandbox-<name>/.claude/skills/
# NO .claude/rules/ - testing portability
```

### 6. Delegate

```bash
# CREATE mode
ralph emit "design.tests" "mode: create, component: <name>, type: <type>"

# AUDIT mode  
ralph emit "design.tests" "mode: audit, targets: [<list>], sandbox: tests/sandbox-<name>/"

# BATCH mode
ralph emit "design.tests" "mode: batch, groups: [{deps: [A,B], standalone: [C,D]}]"

# TEST mode (direct to executor)
ralph emit "execution.ready" "mode: rerun, test_dir: tests/, update_json: true"
```

## Philosophy
Trust your judgment. Read the codebase before asking. Detect mode from context. The user expects autonomy.
