# Testing Patterns

Pre-configured test patterns for common scenarios.

> **MANDATORY**: Never use `cd` to navigate. Only use `cd` in same command as claude to set its working directory. Always use absolute paths.

> **ALWAYS start with**: `!pwd` to get actual project path.

## Pattern: Skill Discovery

Verify skills are loaded and discoverable.

```bash
!pwd
mkdir <use-actual-path>test-discovery
cd <use-actual-path>test-discovery && claude --dangerously-skip-permissions -p "List all available skills" --output-format stream-json --verbose --debug --no-session-persistence --max-turns 5 > <use-actual-path>test-discovery/test-output.json 2>&1
cat <use-actual-path>test-discovery/test-output.json  # Check line 1: skills array
rm <use-actual-path>test-discovery/test-output.json
rm -rf <use-actual-path>test-discovery
```

**Verify**: Line 1 shows your test skills in `"skills"` array.

## Pattern: Autonomy Test

Test skill completes without questions.

```bash
!pwd
mkdir <use-actual-path>test-autonomy
cd <use-actual-path>test-autonomy && claude --dangerously-skip-permissions -p "Create README with project structure" --output-format stream-json --verbose --debug --no-session-persistence --max-turns 8 > <use-actual-path>test-autonomy/test-output.json 2>&1
cat <use-actual-path>test-autonomy/test-output.json  # Check line 3: num_turns, result
rm <use-actual-path>test-autonomy/test-output.json
rm -rf <use-actual-path>test-autonomy
```

**Verify**: No `"permission_denials"` in line 3, README created.

## Pattern: Context Fork Isolation

Verify forked skill cannot access main context.

```bash
!pwd
mkdir <use-actual-path>test-fork
# Create forked skill with context: fork in frontmatter
cd <use-actual-path>test-fork && claude --dangerously-skip-permissions -p "Call forked skill, verify context isolation" --output-format stream-json --verbose --debug --no-session-persistence --max-turns 15 > <use-actual-path>test-fork/test-output.json 2>&1
cat <use-actual-path>test-fork/test-output.json
rm <use-actual-path>test-fork/test-output.json
rm -rf <use-actual-path>test-fork
```

**Verify**: Forked skill executes without accessing main conversation variables.

## Pattern: Skill Chain

Test multi-skill calling sequence (A → B → C).

```bash
!pwd
mkdir <use-actual-path>test-chain
# Create skills: skill-c, skill-b (calls skill-c), skill-a (calls skill-b)
cd <use-actual-path>test-chain && claude --dangerously-skip-permissions -p "Execute skill-a" --output-format stream-json --verbose --debug --no-session-persistence --max-turns 20 > <use-actual-path>test-chain/test-output.json 2>&1
cat <use-actual-path>test-chain/test-output.json  # Check for all completion markers
rm <use-actual-path>test-chain/test-output.json
rm -rf <use-actual-path>test-chain
```

**Verify**: All completion markers present in result, num_turns > 5.

## Pattern: Parallel Forks

Test multiple forked skills running concurrently.

```bash
!pwd
mkdir <use-actual-path>test-parallel
# Create coordinator + multiple forked worker skills
cd <use-actual-path>test-parallel && claude --dangerously-skip-permissions -p "Run parallel tasks" --output-format stream-json --verbose --debug --no-session-persistence --max-turns 25 > <use-actual-path>test-parallel/test-output.json 2>&1
cat <use-actual-path>test-parallel/test-output.json
rm <use-actual-path>test-parallel/test-output.json
rm -rf <use-actual-path>test-parallel
```

**Verify**: All worker completion markers present, results aggregated.

## Pattern: Subagent Configuration

Test custom subagent with tool restrictions.

```bash
!pwd
mkdir <use-actual-path>test-subagent
# Create .claude/agents/custom-agent.md
cd <use-actual-path>test-subagent && claude --dangerously-skip-permissions -p "Use custom subagent for task" --output-format stream-json --verbose --debug --no-session-persistence --max-turns 15 > <use-actual-path>test-subagent/test-output.json 2>&1
cat <use-actual-path>test-subagent/test-output.json
rm <use-actual-path>test-subagent/test-output.json
rm -rf <use-actual-path>test-subagent
```

**Verify**: Subagent executed with configured tools only.
