---
description: "Diagnose any issue including skills, commands, agents, hooks, MCPs, conversations, or architecture when user mentions 'diagnose', 'analyze what went wrong', 'improve', recurring issues, or unexpected behavior. Not for simple file edits or single-purpose tool requests."
allowed-tools: Read, Grep, Glob, AskUserQuestion, Skill, Bash
---

# Universal Issue Diagnosis

<mission_control>
<objective>Investigate and diagnose ANY issue through pattern recognition and evidence-based analysis</objective>
<success_criteria>Root cause identified with specific file:line references and actionable fix proposed</success_criteria>
</mission_control>

<trigger>When user mentions: 'diagnose', 'analyze what went wrong', 'improve', recurring issues, unexpected behavior</trigger>

---

<interaction_schema>
CLASSIFY → INVESTIGATE → thinking → DIAGNOSE → PROPOSE → PLAN
</interaction_schema>

Think of diagnosis as **investigative pattern recognition**—examining symptoms, identifying root causes across any component type, and proposing actionable fixes.

## The Diagnostic Flow

```
CLASSIFY → INVESTIGATE → DIAGNOSE → PROPOSE → PLAN
```

**Trust intelligence to determine what's needed.** Some diagnoses require full flow; others skip steps when context provides clarity.

---

## Issue Classification

<thinking>
**Task Analysis:**
User needs issue diagnosis across component types
**Constraints:** Must be evidence-based, not speculative
**Approaches:** Full classification flow vs. direct investigation based on context clarity
**Selected:** Use intelligence to determine what's needed - skip classification if context provides clarity
</thinking>

**First, understand what kind of issue exists.**

### Six Issue Types

| Type             | Pattern                                  | When                                   |
| ---------------- | ---------------------------------------- | -------------------------------------- |
| **Component**    | Skill/command/agent/hook/MCP misbehaving | Not loading, wrong behavior, errors    |
| **Conversation** | Repeated questions, misunderstandings    | User corrections, context gaps         |
| **Architecture** | Knowledge organization problems          | Scattered patterns, duplication        |
| **Performance**  | Token waste, low autonomy                | Slow execution, many questions         |
| **Integration**  | Components not coordinating              | Skill tool failures, permission issues |
| **Other**        | Unclear or mixed symptoms                | Use when patterns don't match          |

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

<diagnostic_parameters>
<parameter name="investigation_first">
Investigate before asking. Tools provide information faster than questions.
</parameter>

  <parameter name="meta_skill_loading">
    Load appropriate meta-skill as validation framework for component issues
  </parameter>

  <parameter name="evidence_based">
    All root causes must be based on investigation evidence, not speculation
  </parameter>
</diagnostic_parameters>

### Component Issues

**Load the appropriate meta-skill as validation framework:**

| Component | Meta-Skill              | What It Provides                            |
| --------- | ----------------------- | ------------------------------------------- |
| Skills    | `invocable-development` | Description quality, autonomy, portability  |
| Commands  | `invocable-development` | Frontmatter validation, executable examples |
| Agents    | `agent-development`     | Triggering patterns, isolation requirements |
| Hooks     | `hook-development`      | Event patterns, security validation         |
| MCPs      | `mcp-development`       | Server configuration, transport primitives  |

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

<thinking>
**Task Analysis:**
Investigation complete, need to synthesize findings
**Constraints:** Must be specific, evidence-based, actionable
**Approaches:** Severity assessment, root cause formulation, solution propositions
**Selected:** Use diagnostic matrix format with zero-typing propositions
</thinking>

**After investigation, synthesize findings into specific diagnosis.**

### Severity Levels

**Critical (Blocking):** Security vulnerabilities, complete failures, data loss risks

**High Priority:** Quality issues, major violations, broken workflows

**Medium Priority:** Minor deviations, documentation gaps

**Low Priority:** Cosmetic issues, nice-to-have enhancements

### Diagnosis Pattern

```markdown
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

<execution_plan>
Present fixes through recognition, not generation. Use zero-typing format for all propositions.
</execution_plan>

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

<execution_plan>
After user selects a solution, create actionable implementation plan with specific file references and validation criteria.
</execution_plan>

### Plan Format

````markdown
## Implementation Plan

### Changes

**File:** [path]
**Location:** [line/section]

```diff
- Current: [what exists]
+ Change to: [what will be]
```
````

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

<diagnostic_matrix>
  **Symptom:** Component doesn't load or appear
  **Investigation:** Check frontmatter against meta-skill validation references
  **Root Cause:** Frontmatter syntax errors, missing required fields, wrong file paths
  **Fix:** Correct frontmatter or fix file location
</diagnostic_matrix>

---

### Wrong Tool Selection

<diagnostic_matrix>
  **Symptom:** Skills using Task tool for delegation instead of Skill tool
  **Investigation:** Check allowed-tools for Task but not Skill
  **Root Cause:** Command wrapper anti-pattern
  **Fix:** Add Skill(tool-name) to allowed-tools, update instructions
  **Why:** Skill tool consumes 1 prompt, Task wastes 2-5 prompts
</diagnostic_matrix>

---

### Missing Frontmatter

<diagnostic_matrix>
  **Symptom:** Command doesn't appear in CLI list
  **Investigation:** Check for description field and invocation mode
  **Root Cause:** Missing or incomplete frontmatter
  **Fix:** Add complete frontmatter with What-When-Not description format
</diagnostic_matrix>

---

### Permission Problems

<diagnostic_matrix>
  **Symptom:** Component can't access needed tools
  **Investigation:** Compare allowed-tools with intended behavior
  **Root Cause:** Premature permission constraint (added proactively, not reactively)
  **Fix:** Add missing tool or remove allowed-tools entirely
  **Remember:** Permissions are reactive-only. Only constrain after observing issues.
</diagnostic_matrix>

---

### Low Autonomy

<diagnostic_matrix>
  **Symptom:** 5+ questions per session (target: 0-5)
  **Investigation:** Check for Success Criteria section, analyze description
  **Root Cause:** Missing Success Criteria, unclear description
  **Fix:** Add Success Criteria with completion conditions, refine description
  **Recognition:** Can't self-validate → keeps asking
</diagnostic_matrix>

---

### Integration Failures

<diagnostic_matrix>
  **Symptom:** "skill not found" when command tries to delegate
  **Investigation:** Compare Skill(tool-name) invocation with skill frontmatter name
  **Root Cause:** Name mismatch between invocation and declaration
  **Fix:** Update invocation to match frontmatter name
</diagnostic_matrix>

---

### Portability Issues

<diagnostic_matrix>
  **Symptom:** Component references external files or project-specific paths
  **Investigation:** Scan for "see CLAUDE.md", hard-coded paths
  **Root Cause:** Violates portability invariant
  **Fix:** Inline knowledge, use portable relative paths
  **Why:** Components must work with zero .claude/rules/ dependency
</diagnostic_matrix>

---

## Full Workflow Examples

### Example: Skill Using Wrong Tool

<thinking>
**Context:** Skill spawns subagents instead of using Skill tool
**Investigation:**
- allowed-tools: ["Task", "Read", "Write"] - Task present, Skill missing
- Instructions: "Use Task tool to spawn subagent for delegation"
- This is command wrapper anti-pattern
**Diagnosis:** Component issue, High Priority, Wrong tool selection
**Approach:** Add Skill to allowed-tools or remove Task
</thinking>

<diagnostic_matrix>
  **Observation:**
  - Line 15: allowed-tools includes Task, excludes Skill(tool-name)
  - Line 45: "Use Task tool to spawn subagent"

  **Root Cause:** Uses Task tool for delegation instead of Skill tool. Command wrapper anti-pattern.

  **Impact:** Wastes prompts (Task: 2-5, Skill: 1), loses conversation context
</diagnostic_matrix>

**Propositions:**
```

"Which fix should we apply?

1. Add Skill(tool-name) to allowed-tools and update instructions
2. Remove Task from allowed-tools entirely (force correct usage)
3. Convert to command (if orchestration workflow intended)
4. Something else"

````

**Implementation Plan:**
```markdown
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
````

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

## Absolute Constraints

<critical_constraint>
MANDATORY: All root causes MUST be based on investigation evidence
MANDATORY: All propositions MUST include specific file:line references
MANDATORY: Use zero-typing format for ALL user questions
MANDATORY: Show exact changes (diff format) before implementing

NO speculation. NO abstract categories. NO guessing without evidence.
</critical_constraint>
