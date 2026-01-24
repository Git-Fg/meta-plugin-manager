# Quality Framework

Skills must score ≥80/100 on 11-dimensional framework before production.

**Philosophy Foundation**: Quality frameworks guide but don't replace intelligent decision-making. See @.claude/rules/philosophy.md for core principles that inform quality evaluation.

## When to Apply

**FOR DIRECT USE**: Apply this framework when:
- Creating new skills
- Auditing existing skills before production
- Evaluating skill quality for deployment
- Ensuring autonomous execution (80-95% without questions)

**TO KNOW WHEN**: Recognize that:
- Quality frameworks guide but don't replace intelligent decision-making
- Context matters - some dimensions may be more critical than others
- TaskList enables quality validation for complex multi-skill workflows
- Progressive disclosure affects what belongs in Tier 1 vs Tier 2/3

## 11-Dimensional Framework

1. **Knowledge Delta** - Expert-only vs Claude-obvious
2. **Autonomy** - 80-95% completion without questions
3. **Discoverability** - Clear description with triggers
4. **Progressive Disclosure** - Tier 1/2/3 properly organized
5. **Clarity** - Unambiguous instructions
6. **Completeness** - Covers all scenarios
7. **Standards Compliance** - Follows Agent Skills spec
8. **Security** - Validation, safe execution
9. **Performance** - Efficient workflows
10. **Maintainability** - Well-structured
11. **Innovation** - Unique value

## Autonomy Scoring (from skills/test-runner/references/autonomy-testing.md)

**From test-output.json, check line 3:**
```json
"permission_denials": [
  {
    "tool_name": "AskUserQuestion",
    "tool_input": { "questions": [...] }
  }
]
```

**Autonomy levels:**
- 95% (Excellent): 0-1 questions
- 85% (Good): 2-3 questions
- 80% (Acceptable): 4-5 questions
- <80% (Fail): 6+ questions

**What counts as a question:**
- ❌ "Which file should I modify?"
- ❌ "What should I name this variable?"
- ✅ Reading files for context
- ✅ Running bash commands as part of workflow

## Progressive Disclosure (from skills-architect/references/progressive-disclosure.md)

**Tier 1** (~100 tokens): YAML frontmatter - always loaded
- `name`, `description`, `user-invocable`

**Tier 2** (<500 lines): SKILL.md - loaded on activation
- Core implementation with workflows and examples

**Tier 3** (on-demand): references/ - loaded when needed
- Deep details, troubleshooting, examples

**Rule**: Create references/ only when SKILL.md + references >500 lines total.
