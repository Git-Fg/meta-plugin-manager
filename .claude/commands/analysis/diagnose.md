---
description: "Diagnose ANY issue (skill, command, agent, hook, MCP, conversation, architecture). Use when: user mentions 'diagnose', 'analyze what went wrong', 'improve', recurring issues, unexpected behavior. Not for: simple file edits, single-purpose tool requests."
allowed-tools: ["Read", "Grep", "Glob", "AskUserQuestion", "Skill", "Bash"]
---

# Universal Issue Diagnosis

Think of diagnosis as **investigative pattern recognition**—examining symptoms, identifying root causes across any component type, and proposing actionable fixes.

## The Diagnostic Flow

```
CLASSIFY → INVESTIGATE → DIAGNOSE → PROPOSE → PLAN
```

**Trust intelligence to determine what's needed.** Some diagnoses require full flow; others skip steps when context provides clarity.

---

## Issue Classification

**First, understand what kind of issue exists.**

### Six Issue Types

| Type | Pattern | When |
|------|---------|------|
| **Component** | Skill/command/agent/hook/MCP misbehaving | Not loading, wrong behavior, errors |
| **Conversation** | Repeated questions, misunderstandings | User corrections, context gaps |
| **Architecture** | Knowledge organization problems | Scattered patterns, duplication |
| **Performance** | Token waste, low autonomy | Slow execution, many questions |
| **Integration** | Components not coordinating | Skill tool failures, permission issues |
| **Other** | Unclear or mixed symptoms | Use when patterns don't match |

### Classification Approach

**Can the issue be classified from context?** If yes, proceed directly to investigation.

**If unclear, use AskUserQuestion:**
```
"What kind of issue matches your situation?
1. Component (skill/command/agent/hook/MCP not working)
2. Conversation (repeated questions, misunderstandings)
3. Architecture (project structure, knowledge organization)
4. Performance (slow, inefficient, many questions)
5. Integration (components not working together)
6. Other"
```

**Remember:** Zero-typing standard. User selects number; optional detail in "Other" field.

---

## Investigation Strategy

**Investigate before asking.** Tools provide information faster than questions.

### Component Issues

**Load the appropriate meta-skill as validation framework:**

| Component | Meta-Skill | What It Provides |
|-----------|------------|------------------|
| Skills | `skill-development` | Description quality, autonomy, portability |
| Commands | `command-development` | Frontmatter validation, executable examples |
| Agents | `agent-development` | Triggering patterns, isolation requirements |
| Hooks | `hook-development` | Event patterns, security validation |
| MCPs | `mcp-development` | Server configuration, transport primitives |

**Investigation focuses on:**
- Read the component file (SKILL.md or command file)
- Check frontmatter validity (syntax, required fields)
- Scan for anti-patterns (command wrappers, zero delta, etc.)
- Verify file structure (references/, examples/ present?)
- Test component loading if applicable

### Other Issue Types

**Conversation Issues:** Review history for repeated questions, user corrections, time sinks

**Architecture Issues:** Check `.claude/rules/` for consistency, `CLAUDE.md` for project patterns, cross-references for circular dependencies

**Performance Issues:** Check component size, context fork usage, progressive disclosure structure, autonomy blockers

**Integration Issues:** Check dependencies (allowed-tools, Skill tool usage), cross-component references, orchestration state

### Recognition Test

**"Could tools provide this information instead of asking?"** If yes, investigate first.

---

## Diagnosis Formulation

**After investigation, synthesize findings into specific diagnosis.**

### Severity Levels

**Critical (Blocking):** Security vulnerabilities, complete failures, data loss risks

**High Priority:** Quality issues, major violations, broken workflows

**Medium Priority:** Minor deviations, documentation gaps

**Low Priority:** Cosmetic issues, nice-to-have enhancements

### Diagnosis Pattern

```
## Diagnosis: [Component/Issue Name]

**Issue Type:** [Component/Conversation/Architecture/Performance/Integration]
**Severity:** [Critical/High/Medium/Low]
**Location:** [file:line if applicable]

### Root Cause
[What's actually happening - based on investigation evidence]

### Impact
[What breaks, who/what is affected]

### Evidence
[Specific observations: file references, log patterns, conversation markers]
```

**Key distinction:** Root cause explains "why" based on evidence, not speculation.

---

## Solution Propositions

**Present fixes through recognition, not generation.**

### Zero-Typing Format

Numbered options let users recognize the correct path without typing:

```
"Which fix matches your situation?

1. [Specific action with file:line] - [2-3 word context]
2. [Specific action with file:line] - [2-3 word context]
3. [Specific action with file:line] - [2-3 word context]
4. Something else"
```

### Proposition Patterns

**For component issues:**
```
"Which fix should we apply?
1. Fix description in SKILL.md:42 (add What-When-Not format)
2. Add Success Criteria section (implement self-validation)
3. Remove context: fork (overhead unjustified)
4. Something else"
```

**For conversation issues:**
```
"What would prevent this recurring?
1. Add to .claude/rules/principles.md: [specific text]
2. Update CLAUDE.md with: [specific guidance]
3. Create new skill for: [purpose]
4. Something else"
```

**For integration issues:**
```
"How should we fix the integration?
1. Update Skill(tool-name) invocation to match frontmatter name
2. Add Skill(tool-name) to allowed-tools in component
3. Remove Task tool, use Skill tool for delegation
4. Something else"
```

**Principle:** Each option includes specific file location and action. No abstract categories.

---

## Implementation Planning

**After user selects a solution, create actionable implementation plan.**

### Plan Format

```
## Implementation Plan

### Changes
**File:** [path]
**Location:** [line/section]

```
- Current: [what exists]
+ Change to: [what will be]
```

### Validation
1. [ ] [Specific check]
2. [ ] [Specific check]
3. [ ] [Specific check]

### Related Files
- [file] - [why it matters]
```

### Final Confirmation

```
"Ready to apply these changes?
1. Yes, implement
2. Modify plan
3. Cancel"
```

**Show exact changes before applying.** Users should see what will happen.

---

## Common Patterns

### Component Not Loading

**Look for:** Frontmatter syntax errors, missing required fields, wrong file paths

**Investigation:** Check frontmatter against appropriate meta-skill validation references

**Fix:** Correct frontmatter or fix file location

---

### Wrong Tool Selection

**Look for:** Skills using Task tool for delegation instead of Skill tool

**Pattern:** `allowed-tools: ["Task", ...]` with instructions to "spawn subagent"

**Fix:** Add `Skill(tool-name)` to allowed-tools, update instructions to use Skill tool

**Why:** Skill tool consumes 1 prompt, preserves conversation context. Task tool wastes 2-5 prompts, loses context.

---

### Missing Frontmatter

**Look for:** Command doesn't appear in CLI list

**Investigation:** Check for `description` field, invocation mode (`user-invocable` or `disable-model-invocation`)

**Fix:** Add complete frontmatter with What-When-Not description format

---

### Permission Problems

**Look for:** Component can't access needed tools

**Investigation:** Compare `allowed-tools` with component description and intended behavior

**Pattern:** `allowed-tools: ["Grep", "Write"]` but description says "reads configuration files" (Read missing)

**Fix:** Add missing tool to allowed-tools or remove allowed-tools entirely (default to maximum freedom)

**Remember:** Permissions are reactive-only. Only constrain after observing specific issues.

---

### Low Autonomy

**Look for:** 5+ questions per session (target: 0-5)

**Investigation:** Check for Success Criteria section, analyze description for exact trigger phrases

**Fix:** Add Success Criteria with completion conditions, refine description with What-When-Not format

**Recognition:** Missing Success Criteria means component can't self-validate completion → keeps asking.

---

### Integration Failures

**Look for:** "skill not found" when command tries to delegate

**Investigation:** Compare Skill(tool-name) invocation with actual skill frontmatter `name:` field

**Pattern:** Command calls `Skill(target-skill)` but skill declares `name: different-name`

**Fix:** Update invocation to match frontmatter name, or rename skill to match invocation

---

### Portability Issues

**Look for:** Component references external files, uses project-specific paths

**Investigation:** Scan for "see CLAUDE.md", "refer to .claude/rules/", hard-coded paths like `/Users/...`

**Fix:** Inline knowledge directly into component, use portable relative paths

**Why:** Components must work in projects with zero `.claude/rules/` dependency.

---

## Full Workflow Examples

### Example: Skill Using Wrong Tool

**Context:** Skill spawns subagents instead of using Skill tool for delegation

**Investigation reveals:**
- `allowed-tools: ["Task", "Read", "Write"]` - Task present, Skill missing
- Instructions: "Use Task tool to spawn subagent for delegation"
- skill-development teaches: Use Skill tool for delegation, not Task
- This is command wrapper anti-pattern

**Diagnosis:**
```
## Diagnosis: my-delegate-skill
**Issue Type:** Component
**Severity:** High Priority
**Location:** .claude/skills/my-delegate-skill/SKILL.md

### Root Cause
Uses Task tool for delegation instead of Skill tool. Command wrapper anti-pattern.

### Impact
- Wastes prompts (Task: 2-5, Skill: 1)
- Loses conversation context (subagent isolation)
- Defeats skill composition

### Evidence
- Line 15: allowed-tools includes Task, excludes Skill(tool-name)
- Line 45: "Use Task tool to spawn subagent"
```

**Propositions:**
```
"Which fix should we apply?
1. Add Skill(tool-name) to allowed-tools and update instructions
2. Remove Task from allowed-tools entirely (force correct usage)
3. Convert to command (if human-invoked orchestration intended)
4. Something else"
```

**Implementation Plan:**
```
### Changes
File: .claude/skills/my-delegate-skill/SKILL.md:15
- Current: allowed-tools: ["Task", "Read", "Write"]
+ Change to: allowed-tools: ["Skill(other-skill)", "Read", "Write"]

File: .claude/skills/my-delegate-skill/SKILL.md:45
- Current: "Use Task tool to spawn subagent for delegation"
+ Change to: "Use Skill tool to delegate to other-skill when needed"

### Validation
[ ] Verify frontmatter syntax valid
[ ] Test skill triggers Skill tool correctly
[ ] Check conversation context preserved

### Related Files
- .claude/skills/other-skill/SKILL.md - Ensure accepts delegation
- .claude/rules/anti-patterns.md - Reference command wrapper pattern
```

---

### Example: Permission Constraint Blocking Function

**Context:** Skill can't read files but description says it "reads configuration files"

**Investigation reveals:**
- `allowed-tools: ["Grep", "Write"]` - Read missing
- Description: "This skill reads configuration files and analyzes them"
- Skill needs Read tool to function
- No documented issue that prompted Read exclusion
- This is premature constraint (added proactively, not reactively)

**Diagnosis:**
```
## Diagnosis: my-file-skill
**Issue Type:** Component
**Severity:** Critical (Blocking)
**Location:** .claude/skills/my-file-skill/SKILL.md:3

### Root Cause
Read tool missing from allowed-tools, but skill requires it for described function.
Premature permission constraint - added proactively instead of reactively.

### Impact
- Skill can't perform core function
- Silent failure (no error, just doesn't work)
- User thinks skill is broken

### Evidence
- Line 3: allowed-tools excludes Read
- Line 8: Description says "reads configuration files"
```

**Propositions:**
```
"Which fix should we apply?
1. Add Read to allowed-tools (skill needs it for described function)
2. Remove allowed-tools entirely (default to maximum freedom)
3. Update description to match current permissions
4. Something else"
```

**Implementation Plan:**
```
### Changes
File: .claude/skills/my-file-skill/SKILL.md:3
- Current: allowed-tools: ["Grep", "Write"]
+ Change to: allowed-tools: ["Read", "Grep", "Write"]

### Validation
[ ] Verify skill can read files using Read tool
[ ] Test with sample configuration file

### Related Files
- CLAUDE.md - Reference permission constraint rules
```

---

### Example: Low Autonomy (Too Many Questions)

**Context:** Skill asks 5-8 questions per session

**Investigation reveals:**
- Description: "Helps with various tasks related to project management" (vague)
- Missing Success Criteria section entirely
- No exact trigger phrases listed
- Current: 5-8 questions/session < 80% autonomy (target: 80-95% = 0-5 questions)

**Diagnosis:**
```
## Diagnosis: my-asking-skill
**Issue Type:** Performance
**Severity:** High Priority
**Location:** .claude/skills/my-asking-skill/SKILL.md:1

### Root Cause
Missing Success Criteria and unclear description. Can't self-validate completion.

### Impact
- Fails autonomy standard (<80%, should be 80-95%)
- High cognitive load on user
- Slower execution

### Evidence
- Line 5-10: Description vague, no exact phrases
- Missing Success Criteria section
- Question count: 5-8 per session (target: 0-5)
```

**Propositions:**
```
"Which fix should we apply?
1. Add Success Criteria section
2. Refine description with exact trigger phrases
3. Both: Add Success Criteria AND refine description
4. Something else"
```

**Implementation Plan:**
```
### Changes
File: .claude/skills/my-asking-skill/SKILL.md:5
- Current: description: "Helps with various tasks related to project management"
+ Change to: description: "Assist with project task breakdown and dependency mapping. Use when: user mentions 'break down tasks', 'map dependencies', 'task relationships'. Not for: simple task lists, time estimation."

File: .claude/skills/my-asking-skill/SKILL.md:50 (add section)
+ ## Success Criteria
+
+ Consider complete when:
+ - Task dependencies mapped (parent/child relationships identified)
+ - Critical path highlighted (blocking tasks marked)
+ - All tasks have assigned owners or clear criteria
+
+ Do NOT ask about: timeline, effort estimates, resource allocation

### Validation
[ ] Test with same scenario - should ask ≤3 questions
[ ] Verify Success Criteria are checkable (binary test)
[ ] Check description uses What-When-Not format
```

---

### Example: Integration Name Mismatch

**Context:** Command tries to invoke skill but gets "skill not found"

**Investigation reveals:**
- Command line 20: `Use Skill(target-skill) to delegate analysis`
- Skill exists at `.claude/skills/target-skill/SKILL.md`
- Skill frontmatter line 2: `name: different-name`
- Name mismatch: command calls `target-skill`, skill declares `different-name`

**Diagnosis:**
```
## Diagnosis: my-orchestrator → target-skill
**Issue Type:** Integration
**Severity:** High Priority
**Location:** .claude/commands/my-orchestrator.md:20

### Root Cause
Name mismatch between Skill tool invocation and skill frontmatter name.

### Impact
- Integration fails silently
- Command can't delegate to skill
- Workflow broken

### Evidence
- Command line 20: Skill(target-skill)
- Skill line 2: name: different-name
```

**Propositions:**
```
"Which fix should we apply?
1. Update command to use correct name: Skill(different-name)
2. Rename skill to match command: name: target-skill
3. Something else"
```

**Implementation Plan:**
```
### Changes
File: .claude/commands/my-orchestrator.md:20
- Current: Use Skill(target-skill) to delegate analysis
+ Change to: Use Skill(different-name) to delegate analysis

### Validation
[ ] Test command invocation - should successfully call skill
[ ] Verify skill receives context correctly
[ ] Check skill output returns to command

### Related Files
- .claude/skills/different-name/SKILL.md - Verify name intentional
```

---

## Quality Recognition

**Good diagnoses share these patterns:**

- **Investigation precedes questions** - Tools used before asking
- **Specific file locations** - Every fix includes file:line reference
- **Concrete changes shown** - Diff-style representation before implementing
- **Zero-typing questions** - Numbered options, user recognizes correctness
- **Evidence-based** - Root cause from investigation, not speculation
- **Meta-skill referenced** - Uses appropriate validation framework

**Recognition test:** "Does this diagnosis enable immediate action?" If yes, it's ready.

---

**Remember:** Investigation first, recognition over generation, specific propositions with file locations. Trust intelligence to determine what each diagnosis needs.
