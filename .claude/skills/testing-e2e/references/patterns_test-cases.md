# Test Case Patterns (20+ Examples)

## Navigation

| If you need... | Read this section... |
| :------------- | :------------------- |
| Skill invocation tests | ## PATTERN: Skill Invocation Tests |
| Command execution tests | ## PATTERN: Command Execution Tests |
| Agent autonomy tests | ## PATTERN: Agent Autonomy Tests |
| Hook event tests | ## PATTERN: Hook Event Tests |
| MCP tool tests | ## PATTERN: MCP Tool Tests |
| Hallucination scenarios | ## PATTERN: Hallucination Scenarios |
| Integration tests | ## PATTERN: Integration Tests |
| Validation templates | ## PATTERN: Validation Templates |

---

## PATTERN: Skill Invocation Tests

### Test 1: Correct Skill Triggers

```markdown
# Test: [Skill Name] Triggers on Correct Phrase

## Use Cases
| Scenario | Trigger Phrase | Expected |
|----------|---------------|----------|
| Normal request | "Use [skill]" | Skill triggers |
| Implicit request | [context matching description] | Skill triggers |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| Skill exists | `[ -f "$SANDBOX/.claude/skills/[skill]/SKILL.md" ]` | Exit 0 |
| Description matches | `grep -q "[trigger]" $SANDBOX/.claude/skills/[skill]/SKILL.md` | Exit 0 |
| Invoked correctly | `grep -c "invoke.*[skill]" $LOG` | > 0 |

## Risks
| Risk | Mitigation |
|------|------------|
| Wrong skill | Verify description intent |

## Test Prompts
```yaml
prompt: |
  [Context that matches skill description]
allowedTools: "Read,Edit,Bash"
expectedExitCode: 0
```

## Hallucination Scenarios
| Scenario | Detection |
|----------|-----------|
| Wrong skill invoked | Check `grep -c "invoke.*wrong-skill" $LOG` == 0 |
| No skill invoked | Check `grep -c "invoke.*skill" $LOG` > 0 |
```

### Test 2: Skill Does NOT Trigger on Wrong Phrase

```markdown
# Test: [Skill Name] Does NOT Trigger on Unrelated Phrase

## Use Cases
| Scenario | Trigger Phrase | Expected |
|----------|---------------|----------|
| Unrelated request | [unrelated context] | Skill doesn't trigger |
| Similar but wrong | [similar but different intent] | Skill doesn't trigger |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| Wrong context | `grep -c "wrong context" $LOG` | 0 |
| Correct behavior | `grep -v "Wrong skill" $LOG | grep -c "No skill needed"` | > 0 |
```

---

## PATTERN: Command Execution Tests

### Test 3: Command Executes Successfully

```markdown
# Test: [Command Name] Executes Successfully

## Use Cases
| Scenario | Trigger | Expected |
|----------|---------|----------|
| Normal execution | Invoke command | Command runs, output produced |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| Command exists | `[ -f "$SANDBOX/.claude/commands/[cmd].md" ]` | Exit 0 |
| Has description | `grep -q "^description:" $SANDBOX/.claude/commands/[cmd].md` | Exit 0 |
| Executed | `grep -c "Command.*executed\|Output.*produced" $LOG` | > 0 |

## Test Prompts
```yaml
prompt: |
  Execute the [command-name] command with [parameters]
allowedTools: "Bash,Read"
expectedExitCode: 0
```

## Hallucination Scenarios
| Scenario | Detection |
|----------|-----------|
| Wrong command | Verify command name in output |
| No output | Check for actual results |
```

### Test 4: Command Description is Non-Spoiling

```markdown
# Test: [Command] Description Does Not Spoil Body Content

## Use Cases
| Scenario | Check | Expected |
|----------|-------|----------|
| Description length | `wc -w < $SANDBOX/.claude/commands/[cmd].md` | < 100 words |
| No section names | `grep -c "## " $SANDBOX/.claude/commands/[cmd].md` | 0 in desc |
| Blind pointer | `grep -q "Use when\|Includes\|Not for" $SANDBOX/.claude/commands/[cmd].md` | Exit 0 |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| Brief description | `head -5 $SANDBOX/.claude/commands/[cmd].md | grep -c "description:"` | 1 |
| No spoilers | `grep "description:" -A 3 $SANDBOX/.claude/commands/[cmd].md | grep -c "##"` | 0 |
```

---

## PATTERN: Agent Autonomy Tests

### Test 5: Agent Does NOT Spawn Other Agents

```markdown
# Test: [Agent Name] Does Not Spawn Subagents

## Use Cases
| Scenario | Trigger | Expected |
|----------|---------|----------|
| Agent invoked | [agent trigger] | Agent operates, no Task() calls |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| No Task() calls | `grep -c "Task(" $LOG` | 0 |
| Agent operates | `grep -c "Analyzing\|Processing\|Executing" $LOG` | > 0 |
| Direct execution | `grep -c "Using.*tool\|Calling.*function" $LOG` | > 0 |

## Risks
| Risk | Mitigation |
|------|------------|
| Agent recursion | Check for Task() calls |

## Test Prompts
```yaml
prompt: |
  [Agent trigger context]
allowedTools: "Task,Bash,Read,Edit"
expectedExitCode: 0
```

## Hallucination Scenarios
| Scenario | Detection |
|----------|-----------|
| Task() calls found | `grep "Task(" $LOG` must be empty |
| Spawns other agents | Verify no agent invocation patterns |
```

### Test 6: Agent Triggers Only on Correct Conditions

```markdown
# Test: [Agent Name] Triggers on Specific Conditions

## Use Cases
| Scenario | Condition | Expected |
|----------|-----------|----------|
| Correct trigger | [specific context] | Agent spawns |
| Wrong trigger | [unrelated context] | Agent doesn't spawn |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| Correct trigger | `grep -c "Agent.*spawned" $LOG` | 1 |
| Wrong context | `grep -c "Not.*trigger" $LOG` | > 0 |
```

---

## PATTERN: Hook Event Tests

### Test 7: Hook Fires on Correct Event

```markdown
# Test: [Hook Name] Fires on [Event Name]

## Use Cases
| Scenario | Event | Expected |
|----------|-------|----------|
| Event occurs | [specific trigger] | Hook fires |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| Hook config exists | `[ -f "$SANDBOX/.claude/settings.json" ]` | Exit 0 |
| Hook defined | `grep -q "[hook-name]" $SANDBOX/.claude/settings.json` | Exit 0 |
| Event triggered | `grep -c "[event].*detected" $LOG` | > 0 |

## Risks
| Risk | Mitigation |
|------|------------|
| Wrong event | Verify event type |

## Test Prompts
```yaml
prompt: |
  [Action that triggers the event]
allowedTools: "Bash(git *),Bash(rm *),Bash(sudo *)"
expectedExitCode: 0
```

## Hallucination Scenarios
| Scenario | Detection |
|----------|-----------|
| Wrong event | Verify event type in log |
| No event | Check for hook trigger |
```

---

## PATTERN: MCP Tool Tests

### Test 8: MCP Tool Returns Valid Structure

```markdown
# Test: [MCP Tool] Returns Valid JSON

## Use Cases
| Scenario | Tool | Expected |
|----------|------|----------|
| Tool call | [mcp-tool] | Valid JSON returned |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| MCP configured | `[ -d "$SANDBOX/Custom_MCP/[mcp]" ]` | Exit 0 |
| Valid JSON | `echo "$TOOL_OUTPUT" | jq . > /dev/null 2>&1` | Exit 0 |
| Has required fields | `echo "$TOOL_OUTPUT" | jq 'has("result")'` | Exit 0 |

## Test Prompts
```yaml
prompt: |
  Use the [mcp-tool] tool with [parameters]
allowedTools: "[mcp-tool]"
expectedExitCode: 0
```

## Hallucination Scenarios
| Scenario | Detection |
|----------|-----------|
| Invalid JSON | Validate with jq |
| Missing fields | Check required fields |
```

### Test 9: MCP Integration with Skill

```markdown
# Test: [MCP] Works with [Skill]

## Use Cases
| Scenario | Components | Expected |
|----------|------------|----------|
| Skill uses MCP | skill + mcp-tool | Tool invoked, result used |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| Skill mentions MCP | `grep -q "[mcp-tool]" $SANDBOX/.claude/skills/[skill]/SKILL.md` | Exit 0 |
| Tool called | `grep -c "[mcp-tool].*invoked" $LOG` | > 0 |
| Result used | `grep -c "Result.*used\|Output.*processed" $LOG` | > 0 |
```

---

## PATTERN: Hallucination Scenarios

### Test 10: Read Instead of Invoke

```markdown
# Test: Claude Does NOT Read When Should Invoke

## Use Cases
| Scenario | What Should Happen | What Should NOT Happen |
|----------|-------------------|----------------------|
| Skill context | Invoke skill | Read about skill |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| Skill invoked | `grep -c "invoke.*skill\|use.*skill" $LOG` | > 0 |
| No reading | `grep -c "Read.*SKILL.md\|cat.*SKILL.md" $LOG` | 0 |

## Hallucination Scenarios
| Scenario | Detection |
|----------|-----------|
| Reading file | `grep "Read.*SKILL.md" $LOG` must be empty |
| Describing instead of doing | Verify action taken |
```

### Test 11: Skipped Verification

```markdown
# Test: Claude Verifies All Validation Conditions

## Use Cases
| Scenario | Expected |
|----------|----------|
| Multiple conditions | All checked |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| All conditions checked | `grep -c "verify\|check\|validate" $LOG` | >= num_conditions |
| No skipped steps | `grep -c "skip\|omit\|miss" $LOG` | 0 |

## Hallucination Scenarios
| Scenario | Detection |
|----------|-----------|
| Missing check | Count validation mentions |
| Partial work | Verify all outputs produced |
```

### Test 12: Wrong Skill Triggered

```markdown
# Test: Correct Skill Invoked for Context

## Use Cases
| Scenario | Expected Skill | Wrong Skills |
|----------|---------------|--------------|
| [context] | [correct-skill] | [wrong-skill-1], [wrong-skill-2] |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| Correct invoked | `grep -c "invoke.*[correct-skill]" $LOG` | > 0 |
| Wrong not invoked | `grep -c "invoke.*[wrong-skill]" $LOG` | 0 |

## Hallucination Scenarios
| Scenario | Detection |
|----------|-----------|
| Wrong skill | Verify correct skill name in log |
| Multiple attempts | Check for skill name changes |
```

---

## PATTERN: Integration Tests

### Test 13: Skill Works with Command

```markdown
# Test: [Skill] Uses [Command] Correctly

## Use Cases
| Scenario | Components | Expected |
|----------|------------|----------|
| Skill requires command | skill + command | Command invoked |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| Command invoked | `grep -c "[command].*executed" $LOG` | > 0 |
| Output used | `grep -c "Command.*result\|Output.*used" $LOG` | > 0 |
```

### Test 14: Multi-Component Workflow

```markdown
# Test: Complete Workflow with Multiple Components

## Use Cases
| Scenario | Components | Expected |
|----------|------------|----------|
| Full workflow | skill + command + agent | All work together |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| Component 1 | `grep -c "[comp1].*done" $LOG` | > 0 |
| Component 2 | `grep -c "[comp2].*done" $LOG` | > 0 |
| Integration | `grep -c "Output.*passed\|Result.*forwarded" $LOG` | > 0 |
```

---

## PATTERN: Validation Templates

### Template A: File Validation

```markdown
## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| File exists | `[ -f "$PATH" ]` | Exit 0 |
| Valid format | `file "$PATH" | grep -q "Markdown"` | Exit 0 |
| Has content | `[ -s "$PATH" ]` | Exit 0 |
| Correct structure | `grep -q "[pattern]" $PATH` | Exit 0 |
```

### Template B: YAML Validation

```markdown
## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| Valid YAML | `yaml-frontmatter-valid "$PATH"` | Exit 0 |
| Has frontmatter | `head -1 "$PATH" | grep -q "^---"` | Exit 0 |
| Required fields | `grep -q "name:" "$PATH" && grep -q "description:" "$PATH"` | Exit 0 |
```

### Template C: JSON Validation

```markdown
## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| Valid JSON | `echo "$DATA" | jq . > /dev/null 2>&1` | Exit 0 |
| Has field | `echo "$DATA" | jq 'has("field")'` | Exit 0 |
| Correct value | `echo "$DATA" | jq '.field == "value"'` | Exit 0 |
```

### Template D: Exit Code Validation

```markdown
## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| Success exit | `claude -p "..."; echo $?` | 0 |
| Expected failure | `claude -p "..."; echo $?` | 1 |
| Graceful error | `claude -p "..."; echo $?` | 2 |
```

---

## Anti-Pattern: Test Definition Mistakes

### Anti-Pattern: Incomplete Validation

```markdown
❌ Wrong:
## Validation Conditions
| Condition | Check |
|-----------|-------|
| Works | It works |

✅ Correct:
## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| File exists | `[ -f "output.md" ]` | Exit 0 |
| Has content | `[ -s "output.md" ]` | Exit 0 |
| Valid YAML | `head -1 output.md | grep -q "^---"` | Exit 0 |
```

### Anti-Pattern: Missing Hallucination Tests

```markdown
❌ Wrong:
## Hallucination Scenarios
| Scenario | Detection |
|----------|-----------|
| (empty) | (empty)

✅ Correct:
## Hallucination Scenarios
| Scenario | Detection |
|----------|-----------|
| Read instead of invoke | Check for invoke pattern |
| Skipped verification | Count verification steps |
| Generic output | Verify specific results |
```

---

## Recognition Questions

| Question | Answer Should Be... |
| :------- | :------------------ |
| Test has validation conditions? | Yes, with specific checks |
| Hallucination scenarios included? | Yes, 2-3 scenarios |
| Risks documented? | Yes, with mitigations |
| Prompts test actual behavior? | Yes, realistic scenarios |

---

## Constraints

<critical_constraint>
**Test Pattern Invariant:**

1. Every test MUST have validation conditions with specific checks
2. Every test MUST include hallucination scenarios
3. Every test MUST document risks and mitigations
4. Validation conditions MUST use deterministic checks (exit codes, file existence)
5. Hallucination detection MUST use grep/eval patterns, not AI evaluation
</critical_constraint>
