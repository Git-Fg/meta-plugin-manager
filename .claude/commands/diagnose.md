---
description: "Diagnose ANY issue (skill, command, agent, hook, MCP, conversation, architecture). Use when: user mentions 'diagnose', 'analyze what went wrong', 'improve', recurring issues, unexpected behavior. Not for: simple file edits, single-purpose tool requests."
allowed-tools: ["Read", "Grep", "Glob", "AskUserQuestion", "Skill", "Bash"]
---

# Universal Issue Diagnosis

Think of diagnosis as **investigative pattern recognition**—examining symptoms, identifying root causes across any component type, and proposing actionable fixes.

## The Diagnostic Loop

**Execute this workflow:**

```
ISSUE TYPE DETECTION → AUTONOMOUS INVESTIGATION → DIAGNOSIS → PROPOSITIONS → IMPLEMENTATION PLAN
```

## Phase 1: Issue Type Detection

**First, determine what we're diagnosing.**

### Use AskUserQuestion to classify:

```
"What kind of issue are you experiencing?

1. Component Issue (skill, command, agent, hook, or MCP not working as expected)
2. Conversation Issue (repeated questions, misunderstandings, misalignment)
3. Architecture Issue (project structure, knowledge organization, patterns)
4. Performance Issue (slow execution, token inefficiency, autonomy problems)
5. Integration Issue (components not working together, dependencies)
6. Other (describe in 'Other' field)"
```

**Zero-typing standard:** User selects number, optionally types in "Other" field.

**Binary test:** "Can the issue be classified without asking?" → If yes, skip to Phase 2.

## Phase 2: Autonomous Investigation

**Before asking anything, gather information.**

### For Component Issues

**Load appropriate meta-skill for validation framework:**

| Component Type | Load This Skill | Key Validation Areas |
|----------------|-----------------|---------------------|
| Skills | `skill-development` | Description quality, autonomy, portability, structure |
| Commands | `command-development` | Frontmatter, executable examples, Success Criteria |
| Agents | `agent-development` | Triggering, isolation, philosophy bundling |
| Hooks | `hook-development` | Event patterns, security, validation |
| MCPs | `mcp-development` | Server configuration, transports, primitives |

**Investigation checklist:**
- [ ] Read the component's SKILL.md or command file
- [ ] Check frontmatter validity
- [ ] Verify file structure (references/, examples/)
- [ ] Scan for common anti-patterns
- [ ] Check recent modifications (git status if available)
- [ ] Test component loading if applicable

### For Conversation Issues

**Investigation sources:**
- Conversation history (look for repeated questions, corrections)
- Context gaps (what had to be explained repeatedly)
- User interventions (where user redirected or corrected)
- Time sinks (what took longer than necessary)

### For Architecture Issues

**Investigation sources:**
- `.claude/rules/` for consistency
- `CLAUDE.md` for project-specific patterns
- Component cross-references (circular dependencies?)
- Knowledge duplication vs. intentional redundancy

### For Performance Issues

**Investigation sources:**
- Component size (word count, token usage)
- Context fork usage (is overhead justified?)
- Progressive disclosure structure
- Autonomy blockers (why questions?)

### For Integration Issues

**Investigation sources:**
- Component dependencies (allowed-tools, Skill tool usage)
- Cross-component references
- Ralph orchestration state (`.ralph/` if applicable)
- Event flows and hat switching

**Recognition test:** "Could I find this with tools instead of asking?" → Use tools first.

## Phase 3: Diagnosis

**After investigation, formulate specific diagnosis.**

### Severity Classification

**Critical (Blocking):**
- Security vulnerabilities
- Complete component failure
- Fatal architecture violations
- Data loss risks

**High Priority:**
- Significant quality issues
- Major standards violations
- Performance degradation
- Broken workflows

**Medium Priority:**
- Minor standard deviations
- Documentation gaps
- Suboptimal patterns

**Low Priority:**
- Cosmetic issues
- Nice-to-have enhancements
- Minor optimizations

### Diagnosis Format

```
## Diagnosis: [Component/Issue Name]

**Issue Type:** [Component/Conversation/Architecture/Performance/Integration]
**Severity:** [Critical/High/Medium/Low]
**Component Location:** [file:line if applicable]

### Root Cause
[Specific diagnosis based on investigation]

### Impact
[What breaks, what's affected]

### Evidence
[Specific file references, logs, or conversation patterns]
```

## Phase 4: Propositions

**Present actionable fixes using zero-typing format.**

### Format

```
## Proposed Solutions

**Option 1**: [2-3 word summary]
[Specific action with file:line references]

**Option 2**: [2-3 word summary]
[Specific action with file:line references]

**Option 3**: [2-3 word summary]
[Specific action with file:line references]

**Option 4**: None of these / Investigate further
```

### Zero-Typing Examples

**For component issues:**
```
"Which fix should we apply?

1. Fix description in SKILL.md:42 (add What-When-Not format)
2. Add Success Criteria section (implement self-validation)
3. Reduce to High Freedom (trust Claude more)
4. Something else"
```

**For conversation issues:**
```
"What would prevent this recurring?

1. Add project rule: [specific text to add to .claude/rules/]
2. Update CLAUDE.md with: [specific guidance]
3. Create new skill: [skill purpose]
4. Something else"
```

**For architecture issues:**
```
"How should we fix the architecture?

1. Consolidate to .claude/rules/principles.md (universal pattern)
2. Move to CLAUDE.md (project-specific)
3. Inline in component (portability requirement)
4. Something else"
```

**Key principle:** User recognizes the correct fix, doesn't generate from scratch.

## Phase 5: Implementation Planning

**After user selects a solution, create detailed implementation plan.**

### Implementation Plan Format

```
## Implementation Plan

### Changes to Apply
**File:** [specific file path]
**Location:** [line number or section]
**Action:** [exact text to add/modify/delete]

```
[diff-style representation]
- Current: [what exists]
+ Change to: [what will be]
```

### Validation Steps
1. [ ] [Specific verification step 1]
2. [ ] [Specific verification step 2]
3. [ ] [Specific verification step 3]

### Related Files to Check
- [ ] [file1] - [why it matters]
- [ ] [file2] - [why it matters]
```

### Final Confirmation

**AskUserQuestion before implementing:**
```
"Ready to apply these changes?

1. Yes, implement the plan
2. No, modify the plan first
3. No, cancel this diagnosis"
```

## Critical Rules

**Investigation First:**
- Scan files, read components, check logs before asking
- Apply analytical frameworks (Root Cause, Pareto, Constraint Mapping)
- Use appropriate meta-skills as validation frameworks
- Only ask when investigation is insufficient

**Zero-Typing Questions:**
- Numbered options (1, 2, 3...)
- Self-explanatory (no research needed to answer)
- Include "Other" or "Something else" escape hatch
- ONE question at a time

**Specific Propositions:**
- Exact file locations (file:line)
- Concrete text changes (show diff)
- Reference validation frameworks (meta-skills)
- No abstract categories ("Fix description" → "Fix SKILL.md:42 description")

**Implementation Planning:**
- Show exact changes before applying
- Include validation steps
- Ask for confirmation before executing
- One issue per iteration (surgical fixes)

## Common Issue Patterns

### Component Not Loading
**Diagnosis:** Frontmatter error or path issue
**Investigation:** Check frontmatter syntax, file path, allowed-tools
**Fix:** Correct frontmatter fields or fix path

### Low Autonomy (Many Questions)
**Diagnosis:** Missing Success Criteria or unclear description
**Investigation:** Count questions, analyze what triggered them
**Fix:** Add Success Criteria or refine description with exact phrases

### Portability Failure
**Diagnosis:** Component references external files or uses project-specific paths
**Investigation:** Check for external references, hard-coded paths
**Fix:** Inline knowledge or use portable paths

### Context Fork Misuse
**Diagnosis:** Fork used when regular invocation would work
**Investigation:** Check if isolation is actually needed
**Fix:** Remove `context: fork` if overhead unjustified

### Rule Violation
**Diagnosis:** Action against .claude/rules/ standards
**Investigation:** Load applicable rules, compare with action
**Fix:** Update component or add missing rule to project

### Performance Issue
**Diagnosis:** Token inefficiency or poor progressive disclosure
**Investigation:** Check word count, tier structure, delta standard
**Fix:** Move content to references/, remove Claude-obvious info

### Integration Failure
**Diagnosis:** Components not coordinating properly
**Investigation:** Check dependencies, Skill tool usage, allowed-tools
**Fix:** Update permissions or add proper Skill invocation

## Full Workflow Examples

### Example 1: Skill Misbehaving (Wrong Tool Selection)

**User runs:** `/diagnose`
**Context:** A skill keeps spawning subagents when it should use the `Skill` tool to delegate

#### Phase 1: Issue Type Detection
```
"What kind of issue are you experiencing?
1. Component Issue
2. Conversation Issue
3. Architecture Issue
4. Performance Issue
5. Integration Issue
6. Other"

User selects: 1
```

#### Phase 2: Autonomous Investigation
```
[Investigation]
- Read .claude/skills/my-delegate-skill/SKILL.md
- Load skill-development for validation framework
- Check allowed-tools frontmatter field
- Scan for Task tool usage pattern
- Compare with command-development for Skill tool patterns

[Evidence Found]
- SKILL.md line 15: allowed-tools: ["Task", "Read", "Write"]
- SKILL.md line 45: "Use Task tool to spawn subagent for delegation"
- skill-development teaches: Use Skill tool for delegation, not Task
- Command wrapper anti-pattern detected: Skill just spawns subagents
```

#### Phase 3: Diagnosis
```
## Diagnosis: my-delegate-skill

**Issue Type:** Component
**Severity:** High Priority
**Component Location:** .claude/skills/my-delegate-skill/SKILL.md

### Root Cause
The skill uses Task tool to spawn subagents for delegation instead of using the Skill tool.
This is a command wrapper anti-pattern - the skill should directly invoke other skills/commands.

### Impact
- Wastes prompts (Task consumes 2-5 prompts, Skill consumes 1)
- Loses conversation context (subagent can't access history)
- Defeats purpose of skill composition

### Evidence
- Line 15: allowed-tools includes Task but not Skill(subtask-name)
- Line 45: Instructions say to spawn subagent
- References anti-patterns.md: "Command Wrapper Skills"
```

#### Phase 4: Propositions
```
"Which fix should we apply?

1. Add Skill(tool-name) to allowed-tools and update instructions (correct delegation pattern)
2. Remove Task from allowed-tools entirely (force correct usage)
3. Convert to command (if human-invoked orchestration is intended)
4. Something else"

User selects: 1
```

#### Phase 5: Implementation Plan
```
## Implementation Plan

### Changes to Apply
**File:** .claude/skills/my-delegate-skill/SKILL.md
**Location:** Line 15 (frontmatter)

```
- Current: allowed-tools: ["Task", "Read", "Write"]
+ Change to: allowed-tools: ["Skill(other-skill)", "Read", "Write"]
```

**File:** .claude/skills/my-delegate-skill/SKILL.md
**Location:** Line 45 (instructions)

```
- Current: "Use Task tool to spawn subagent for delegation"
+ Change to: "Use Skill tool to delegate to other-skill when needed"
```

### Validation Steps
1. [ ] Verify frontmatter syntax is valid (no silent failures)
2. [ ] Test skill invocation triggers Skill tool correctly
3. [ ] Check conversation context is preserved (no fork needed)

### Related Files to Check
- [ ] .claude/skills/other-skill/SKILL.md - Ensure it accepts delegation
- [ ] .claude/rules/anti-patterns.md - Reference command wrapper pattern
```

#### Final Confirmation
```
"Ready to apply these changes?
1. Yes, implement the plan
2. No, modify the plan first
3. No, cancel this diagnosis"

User selects: 1

[Implementation proceeds]
```

---

### Example 2: Command Not Working (Missing Frontmatter)

**User runs:** `/diagnose`
**Context:** A command they created doesn't appear in the available commands list

#### Phase 1: Issue Type Detection
```
[Autonomous detection based on context]
Issue type determined: Component Issue (Command)
```

#### Phase 2: Autonomous Investigation
```
[Investigation]
- Glob .claude/commands/**/*.md
- Read .claude/commands/my-command.md
- Load command-development for validation framework
- Check frontmatter fields against command-development references/frontmatter-reference.md

[Evidence Found]
- File exists at .claude/commands/my-command.md
- Missing `description` field (required for discoverability)
- Missing `user-invocable: true` or `disable-model-invocation: false`
- Command-development line 45: "Commands without description don't appear in CLI"
```

#### Phase 3: Diagnosis
```
## Diagnosis: my-command

**Issue Type:** Component
**Severity:** Critical (Blocking)
**Component Location:** .claude/commands/my-command.md:1

### Root Cause
Missing required frontmatter fields: description and user-invocable/disable-model-invocation.
Commands without these fields fail silent loading and don't appear in the CLI.

### Impact
- Command not discoverable or invocable
- No error message (silent failure)
- User can't use the command they created

### Evidence
- Line 1-3: Frontmatter only contains name
- command-development/references/frontmatter-reference.md: "description is REQUIRED"
- command-development/references/frontmatter-reference.md: "Must specify invocation mode"
```

#### Phase 4: Propositions
```
"Which fix should we apply?

1. Add description and user-invocable: true (human + AI can use)
2. Add description and disable-model-invocation: false (same as above)
3. Add description and disable-model-invocation: true (human-only)
4. Something else"

User selects: 1
```

#### Phase 5: Implementation Plan
```
## Implementation Plan

### Changes to Apply
**File:** .claude/commands/my-command.md
**Location:** Line 1 (frontmatter)

```
- Current: ---
           name: my-command
           ---

+ Change to: ---
+ name: my-command
+ description: "What this command does in What-When-Not format. Use when: trigger phrases. Not for: exclusion phrases."
+ user-invocable: true
+ ---
```

### Validation Steps
1. [ ] Verify frontmatter YAML is valid (no syntax errors)
2. [ ] Check command appears in `/commands` list
3. [ ] Test invocation with `/my-command`

### Related Files to Check
- [ ] command-development/references/frontmatter-reference.md - Reference validation rules
```

#### Final Confirmation
```
"Ready to apply these changes?
1. Yes, implement the plan
2. No, modify the plan first
3. No, cancel this diagnosis"

User selects: 1

[Implementation proceeds]
```

---

### Example 3: Wrong Permission Settings

**User runs:** `/diagnose`
**Context:** A skill can't read files even though it needs to

#### Phase 1: Issue Type Detection
```
"What kind of issue are you experiencing?
1. Component Issue
2. Conversation Issue
3. Architecture Issue
4. Performance Issue
5. Integration Issue
6. Other"

User selects: 1
```

#### Phase 2: Autonomous Investigation
```
[Investigation]
- Read .claude/skills/my-file-skill/SKILL.md
- Check frontmatter allowed-tools field
- Read skill description to understand intended behavior
- Load skill-development for validation framework

[Evidence Found]
- SKILL.md line 8: "This skill reads configuration files and analyzes them"
- SKILL.md line 3: allowed-tools: ["Grep", "Write"] (Read is missing!)
- skill-development: "allowed-tools is reactive-only, not proactive"
- The skill NEEDS Read tool to function
- Personal rules: "Only add constraints when observing specific issues"
```

#### Phase 3: Diagnosis
```
## Diagnosis: my-file-skill

**Issue Type:** Component
**Severity:** Critical (Blocking)
**Component Location:** .claude/skills/my-file-skill/SKILL.md:3

### Root Cause
Read tool missing from allowed-tools, but skill description says it "reads configuration files".
This is a premature permission constraint - added proactively instead of reactively.

### Impact
- Skill can't perform its core function (reading files)
- Silent failure (no error, just doesn't work)
- User thinks skill is broken

### Evidence
- Line 3: allowed-tools: ["Grep", "Write"] - Read missing
- Line 8: Description says "reads configuration files"
- CLAUDE.md personal rules: "Only add constraints after observing issues"
- No documented issue that prompted Read exclusion
```

#### Phase 4: Propositions
```
"Which fix should we apply?

1. Add Read to allowed-tools (skill needs it for described function)
2. Remove allowed-tools entirely (default to maximum freedom)
3. Update description to match current permissions (if Grep-only is intentional)
4. Something else"

User selects: 1
```

#### Phase 5: Implementation Plan
```
## Implementation Plan

### Changes to Apply
**File:** .claude/skills/my-file-skill/SKILL.md
**Location:** Line 3 (frontmatter)

```
- Current: allowed-tools: ["Grep", "Write"]
+ Change to: allowed-tools: ["Read", "Grep", "Write"]
```

### Validation Steps
1. [ ] Verify skill can now read files using Read tool
2. [ ] Test skill with sample configuration file
3. [ ] Document why Read is needed (if adding to permissions comments)

### Related Files to Check
- [ ] CLAUDE.md - Reference personal rules on permission constraints
- [ ] .claude/rules/askuserquestion-best-practices.md - Check if questions are needed
```

#### Final Confirmation
```
"Ready to apply these changes?
1. Yes, implement the plan
2. No, modify the plan first
3. No, cancel this diagnosis"

User selects: 1

[Implementation proceeds]
```

---

### Example 4: Low Autonomy (Too Many Questions)

**User runs:** `/diagnose`
**Context:** A skill asks 5+ questions every time it's used

#### Phase 1: Issue Type Detection
```
[Autonomous detection: "recurring questions" pattern]
Issue type determined: Performance Issue (Autonomy)
```

#### Phase 2: Autonomous Investigation
```
[Investigation]
- Read .claude/skills/my-asking-skill/SKILL.md
- Load skill-development/references/autonomy-design.md
- Check for Success Criteria section
- Analyze description for exact trigger phrases

[Evidence Found]
- SKILL.md word count: 800 (within guidelines)
- Description: vague ("helps with various tasks")
- Missing Success Criteria section
- No exact trigger phrases listed
- skill-development: "80-95% autonomy = 0-5 questions per session"
- Current behavior: 5-8 questions per session = <80% autonomy
```

#### Phase 3: Diagnosis
```
## Diagnosis: my-asking-skill

**Issue Type:** Performance
**Severity:** High Priority
**Component Location:** .claude/skills/my-asking-skill/SKILL.md:1

### Root Cause
Missing Success Criteria and unclear description with no exact trigger phrases.
The skill can't self-validate completion, so it keeps asking for clarification.

### Impact
- Fails autonomy standard (<80%, should be 80-95%)
- High cognitive load on user
- Slower execution speed
- Violates skill-development quality framework

### Evidence
- Line 5-10: Description is vague, no exact phrases
- Missing Success Criteria section entirely
- Question count: 5-8 per session (target: 0-5)
- skill-development/references/quality-framework.md: "Success Criteria required for self-validation"
```

#### Phase 4: Propositions
```
"Which fix should we apply?

1. Add Success Criteria section with specific completion conditions
2. Refine description with exact trigger phrases (What-When-Not format)
3. Both: Add Success Criteria AND refine description
4. Something else"

User selects: 3
```

#### Phase 5: Implementation Plan
```
## Implementation Plan

### Changes to Apply
**File:** .claude/skills/my-asking-skill/SKILL.md
**Location:** Line 5-10 (description)

```
- Current: description: "Helps with various tasks related to project management"
+ Change to: description: "Assist with project task breakdown and dependency mapping. Use when: user mentions 'break down tasks', 'map dependencies', 'task relationships'; needs project structure analysis. Not for: simple task lists, time estimation."
```

**File:** .claude/skills/my-asking-skill/SKILL.md
**Location:** Add new section after body (around line 50)

```
+ ## Success Criteria
+
+ Consider the task complete when:
+ - Task dependencies are mapped (parent/child relationships identified)
+ - Critical path is highlighted (blocking tasks marked)
+ - All tasks have assigned owners or clear ownership criteria
+
+ Do NOT ask about: timeline, effort estimates, or resource allocation (out of scope)
```

### Validation Steps
1. [ ] Test skill with same scenario - should ask ≤3 questions
2. [ ] Verify Success Criteria are checkable (binary test)
3. [ ] Check description uses What-When-Not format

### Related Files to Check
- [ ] skill-development/references/description-guidelines.md - Reference format
- [ ] skill-development/references/autonomy-design.md - Success Criteria patterns
```

#### Final Confirmation
```
"Ready to apply these changes?
1. Yes, implement the plan
2. No, modify the plan first
3. No, cancel this diagnosis"

User selects: 1

[Implementation proceeds]
```

---

### Example 5: Integration Failure (Components Not Working Together)

**User runs:** `/diagnose`
**Context:** A command tries to invoke a skill but says "skill not found"

#### Phase 1: Issue Type Detection
```
"What kind of issue are you experiencing?
1. Component Issue
2. Conversation Issue
3. Architecture Issue
4. Performance Issue
5. Integration Issue
6. Other"

User selects: 5
```

#### Phase 2: Autonomous Investigation
```
[Investigation]
- Read .claude/commands/my-orchestrator.md
- Check if skill exists: Glob .claude/skills/target-skill/
- Read target-skill/SKILL.md to check its name
- Check command's allowed-tools
- Load command-development and skill-development for patterns

[Evidence Found]
- Command line 20: Uses Skill tool with "target-skill"
- Skill exists at .claude/skills/target-skill/SKILL.md
- Skill frontmatter line 2: name: different-name (mismatch!)
- Command attempts: Skill(target-skill) but skill name is different-name
- Integration issue: Name mismatch preventing Skill tool invocation
```

#### Phase 3: Diagnosis
```
## Diagnosis: my-orchestrator → target-skill

**Issue Type:** Integration
**Severity:** High Priority
**Component Location:** .claude/commands/my-orchestrator.md:20

### Root Cause
Name mismatch between Skill tool invocation and actual skill frontmatter name.
Command calls Skill(target-skill) but skill's frontmatter declares name: different-name.

### Impact
- Integration fails silently ("skill not found")
- Command can't delegate to skill
- Workflow broken

### Evidence
- Command line 20: Skill(target-skill)
- Skill line 2: name: different-name
- skill-development: "name in frontmatter is the Skill tool identifier"
```

#### Phase 4: Propositions
```
"Which fix should we apply?

1. Update command to use correct name: Skill(different-name)
2. Rename skill to match command: name: target-skill
3. Something else"

User selects: 1
```

#### Phase 5: Implementation Plan
```
## Implementation Plan

### Changes to Apply
**File:** .claude/commands/my-orchestrator.md
**Location:** Line 20

```
- Current: Use Skill(target-skill) to delegate analysis
+ Change to: Use Skill(different-name) to delegate analysis
```

### Validation Steps
1. [ ] Test command invocation - should successfully call skill
2. [ ] Verify skill receives context correctly
3. [ ] Check skill output returns to command

### Related Files to Check
- [ ] .claude/skills/different-name/SKILL.md - Verify skill name is intentional
- [ ] command-development/references/interactive-commands.md - Reference Skill tool patterns
```

#### Final Confirmation
```
"Ready to apply these changes?
1. Yes, implement the plan
2. No, modify the plan first
3. No, cancel this diagnosis"

User selects: 1

[Implementation proceeds]
```

---

## Output Format

```
## Diagnosis Complete

### Issue
[Specific diagnosis with severity]

### Proposed Solutions
[Zero-typing options with specific actions]

### Investigation Evidence
[What was checked, what was found]
```

**Binary test:** "Does diagnosis provide specific, actionable fixes?" → Must include file locations and concrete changes.

## Quick Reference

**Issue Type Question:**
```
"What kind of issue?
1. Component (skill/command/agent/hook/MCP)
2. Conversation
3. Architecture
4. Performance
5. Integration
6. Other"
```

**Solution Selection Question:**
```
"Which fix?
1. [Specific action with file:line]
2. [Specific action with file:line]
3. [Specific action with file:line]
4. Something else"
```

**Implementation Confirmation:**
```
"Apply changes?
1. Yes, implement
2. Modify plan
3. Cancel"
```

**Remember:** Recognition over generation. Users recognize the correct path; don't make them generate it.
