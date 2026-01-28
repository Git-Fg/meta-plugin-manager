# Meta-Critic Integration

This workflow details how to integrate the meta-critic skill for three-way quality review (Request vs Delivery vs Standards).

---

## What is Meta-Critic?

Meta-critic performs **three-way comparison**:

1. **Request**: What did the user ask for?
2. **Delivery**: What was actually implemented?
3. **Standards**: What do meta-development skills specify?

This identifies gaps, misalignments, and quality issues that single-axis reviews miss.

---

## When to Use Meta-Critic

### Use Cases

1. **After skill creation** - Verify alignment with original request
2. **User feedback** - Diagnose "this doesn't feel right"
3. **Drift detection** - Check if component evolved away from standards
4. **Quality gates** - Validate before deployment/release

### Trigger Patterns

- User says: "This doesn't feel right"
- User says: "Something's off"
- User says: "Not what I asked for"
- After major component changes
- Before marking task complete

---

## Integration Pattern

### Step 1: Load Meta-Critic Skill

Use the Skill tool to load meta-critic:

```
Load meta-critic skill with:
- Conversation history (for Request extraction)
- Component path (for Delivery analysis)
- Component type (for Standards loading)
```

### Step 2: Meta-Critic Performs

Meta-critic autonomously:

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

### Step 3: Findings Formulation

Meta-critic generates structured report:

```markdown
## Meta-Critic Review: [component-name]

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

### High Priority Issues

Significant misalignments or standard violations:

1. **[Issue Name]**
   - **Request**: [What user expected]
   - **Delivery**: [What was delivered]
   - **Standards**: [What standard requires]
   - **Fix**: [Specific action]

### Medium Priority Issues

Improvements for better alignment:

1. **[Issue Name]**
   - **Gap**: [Description of misalignment]
   - **Fix**: [Improvement suggestion]

### Low Priority Issues

Minor optimizations or polish:

1. **[Issue Name]**
   - **Gap**: [Description]
   - **Fix**: [Optimization]
```

### Step 4: Resolution

Present findings and:

- Offer to apply changes
- Verify corrections
- Confirm completion

---

## Quality Gates

Meta-critic validates:

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

### Quality

- [ ] Meets autonomy targets
- [ ] Portability maintained
- [ ] Progressive disclosure in place

---

## Integration Examples

### Example 1: After Skill Creation

**Command invokes meta-critic:**

```
User: /toolkit:skill:create Create a skill for Docker log analysis
[Skill created]
Command: Load meta-critic to review creation
```

**Meta-critic analyzes:**

- Request: "Docker log analysis skill"
- Delivery: [Examines created skill]
- Standards: Loads skill-development

**Meta-critic reports:**

- Critical: Missing error handling patterns
- High: Description references other skills
- Medium: Could use workflow files
- Low: Minor style issues

### Example 2: User Feedback

**User expresses dissatisfaction:**

```
User: "This doesn't feel right"
AI: I'll use meta-critic to diagnose the issue
```

**Meta-critic analyzes:**

- Request: [Scans conversation for original request]
- Delivery: [Examines what was done]
- Standards: [Loads appropriate meta-dev skill]

**Meta-critic identifies:**

- Gap between user's mental model and implementation
- Standard violations causing friction
- Misalignment in approach

### Example 3: Drift Detection

**Component evolved over time:**

```
User: /toolkit:skill:metacritic my-old-skill
```

**Meta-critic analyzes:**

- Request: [Original intent from skill]
- Delivery: [Current state]
- Standards: [Current meta-dev standards]

**Meta-critic identifies:**

- Standards have evolved
- Skill uses deprecated patterns
- New best practices available

---

## Best Practices

### When Invoking Meta-Critic

**DO:**

- Use after major component changes
- Use when user expresses dissatisfaction
- Use for quality gates before deployment
- Let meta-critic load its own reference files

**DON'T:**

- Use for trivial issues (use direct fixes)
- Skip meta-critic for complex changes
- Hardcode standards (let meta-critic load them)

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

- Three-way comparison completed
- Request extracted from conversation
- Delivery analyzed thoroughly
- Standards cited from meta-development skills
- Actionable recommendations provided
- User understands gaps and next steps
