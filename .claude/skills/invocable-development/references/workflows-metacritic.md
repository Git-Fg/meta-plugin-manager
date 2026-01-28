# Quality Standards Integration

This workflow details how to integrate the quality-standards skill for three-way quality review (Request vs Delivery vs Standards) and six-phase verification gates.

---

## What is Quality Standards?

Quality-standards provides **unified quality assurance** through:

1. **Six-Phase Gates**: BUILD → TYPE → LINT → TEST → SECURITY → DIFF
2. **Three-Way Comparison**:
   - **Request**: What did the user ask for?
   - **Delivery**: What was actually implemented?
   - **Standards**: What do meta-development skills specify?

This identifies gaps, misalignments, and quality issues that single-axis reviews miss.

---

## When to Use Quality Standards

### Use Cases

1. **After skill creation** - Verify alignment with original request
2. **Before claiming completion** - Run six-phase gates
3. **User feedback** - Diagnose "this doesn't feel right"
4. **Drift detection** - Check if component evolved away from standards
5. **Quality gates** - Validate before deployment/release

### Trigger Patterns

- User says: "This doesn't feel right"
- User says: "Something's off"
- User says: "Not what I asked for"
- About to claim task complete
- After major component changes

---

## Integration Pattern

### Step 1: Load Quality Standards Skill

Use the Skill tool to load quality-standards:

```
Load quality-standards skill with:
- Conversation history (for Request extraction)
- Component path (for Delivery analysis)
- Component type (for Standards loading)
```

### Step 2: Run Six-Phase Gates

quality-standards executes gates in sequence:

| Phase | Gate     | Command Pattern                | Evidence |
| ----- | -------- | ------------------------------ | -------- |
| 1     | BUILD    | `npm run build`, `cargo build` | Exit 0   |
| 2     | TYPE     | `tsc --noEmit`, `pyright`      | 0 errors |
| 3     | LINT     | `eslint`, `pylint`             | 0 errors |
| 4     | TEST     | `npm test`, `pytest`           | All pass |
| 5     | SECURITY | Grep diff + `npm audit`        | 0 issues |
| 6     | DIFF     | Grep git diff                  | Clean    |

### Step 3: Three-Way Analysis

quality-standards performs:

**1. Request Extraction**

- Scans conversation for user's original request
- Identifies constraints and requirements
- Extracts implied goals
- Notes any clarifications or refinements

**2. Delivery Analysis**

- Examines what was implemented
- Identifies deviations from request
- Notes what was added/removed
- Assesses completeness

**3. Standards Comparison**

- Loads appropriate meta-development skill:
  - For skills → `invocable-development`
  - For commands → `invocable-development`
  - For agents → `agent-development`
  - For hooks → `hook-development`
- Compares delivery against standards
- Identifies gaps and violations

### Step 4: Findings Formulation

quality-standards generates structured report:

```markdown
## Quality Audit: [component-name]

### Six-Phase Gate Results

| Phase | Gate  | Result |
| ----- | ----- | ------ |
| 1     | BUILD | PASS   |
| 2     | TYPE  | PASS   |
| ...   | ...   | ...    |

### Three-Way Summary

| Dimension     | What Was Found             | Gap Analysis              |
| ------------- | -------------------------- | ------------------------- |
| **Request**   | User asked for X           | -                         |
| **Delivery**  | Implemented Y              | Y differs from X by...    |
| **Standards** | Meta-dev skill specifies Z | Delivery violates Z by... |

### Critical Issues (Blocking)

Issues that prevent component from meeting request or standards:

1. **[Issue Name]**
   - **Request**: User wanted X
   - **Delivery**: Got Y instead
   - **Standards**: Standard requires Z
   - **Fix**: [Specific action with file:line]
```

---

## Quality Gates Checklist

quality-standards validates:

### Intent Alignment

- [ ] Delivery matches Request
- [ ] Deviations are justified
- [ ] User's goals are met

### Standards Compliance

- [ ] Follows meta-development skill standards
- [ ] No critical violations
- [ ] Architecture patterns correct

### Completeness

- [ ] All requested features present
- [ ] No unintended omissions
- [ ] Edge cases handled

### Verification

- [ ] BUILD gate passes
- [ ] TYPE gate passes
- [ ] LINT gate passes
- [ ] TEST gate passes (80%+ coverage)
- [ ] SECURITY gate passes
- [ ] DIFF gate passes

---

## Integration Examples

### Example 1: After Skill Creation

**Command invokes critique:**

```
User: /toolkit:build:skill Create a skill for Docker log analysis
[Skill created]
Command: Load quality-standards to audit creation
```

**Audit analyzes:**

- Request: "Docker log analysis skill"
- Delivery: [Examines created skill]
- Standards: Loads invocable-development
- Gates: Runs six-phase verification

**Audit reports:**

- Critical: Missing error handling patterns
- High: Description references other skills
- Medium: Could use workflow files
- Low: Minor style issues

### Example 2: Before Claiming Completion

```
User: I've finished implementing the feature
AI: I'll use quality-standards to verify before claiming complete
[Loads quality-standards]
[Runs BUILD gate]
[Runs TYPE gate]
[Runs LINT gate]
[Runs TEST gate]
[Runs SECURITY gate]
[Runs DIFF gate]
"All gates pass. Implementation is complete."
```

### Example 3: User Feedback

**User expresses dissatisfaction:**

```
User: "This doesn't feel right"
AI: I'll use quality-standards to diagnose the issue
```

**Audit analyzes:**

- Request: [Scans conversation for original request]
- Delivery: [Examines what was done]
- Standards: [Loads appropriate meta-dev skill]

**Audit identifies:**

- Gap between user's mental model and implementation
- Standard violations causing friction
- Misalignment in approach

---

## Best Practices

### When Invoking Quality Standards

**DO:**

- Use before claiming any completion
- Use after major component changes
- Use when user expresses dissatisfaction
- Use for quality gates before deployment
- Let quality-standards load its own reference files

**DON'T:**

- Use for trivial issues (use direct fixes)
- Skip verification for complex changes
- Hardcode standards (let quality-standards load them)

### Interpreting Findings

**Critical issues:**

- Block completion
- Must fix before proceeding
- Usually indicate fundamental problems

**High priority:**

- Important but not blocking
- Should fix soon
- Affect quality or usability

**Medium priority:**

- Improvements
- Fix when convenient
- Enhance effectiveness

**Low priority:**

- Nice-to-haves
- Polish and optimization
- Can defer

---

## Success Criteria

- Six-phase gates completed in sequence
- Three-way comparison completed
- Request extracted from conversation
- Delivery analyzed thoroughly
- Standards cited from meta-development skills
- Actionable recommendations provided
- User understands gaps and next steps
