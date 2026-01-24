# Subagent Validation Framework

6-dimensional quality scoring system for subagent configuration.

---

## Scoring Dimensions

### 1. Configuration Validity (20 points)
**Focus**: YAML syntax, required fields

| Aspect | Points | Check |
|--------|--------|-------|
| Valid YAML | 5 | Parses correctly |
| Required fields present | 10 | name + description |
| No syntax errors | 5 | Clean parsing |

### 2. Frontmatter Correctness (15 points)
**Focus**: Valid fields only, no invalid entries

| Aspect | Points | Check |
|--------|--------|-------|
| Valid fields only | 10 | No invalid fields |
| Correct field names | 5 | Proper spelling/casing |

### 3. Context Appropriateness (15 points)
**Focus**: Correct directory selection

| Aspect | Points | Check |
|--------|--------|-------|
| Right context type | 10 | Project/Plugin/User match |
| Correct directory | 5 | Valid path |

### 4. Tool Restrictions (15 points)
**Focus**: Appropriate allow/deny lists

| Aspect | Points | Check |
|--------|--------|-------|
| Tools or disallowedTools set | 10 | Appropriate restrictions |
| Reasonable restrictions | 5 | Matches use case |

### 5. Skills Integration (15 points)
**Focus**: Proper skill injection

| Aspect | Points | Check |
|--------|--------|-------|
| Skills listed if needed | 10 | For specialized agents |
| Correct skill names | 5 | Valid skill references |

### 6. Documentation Quality (20 points)
**Focus**: Clear description and prompts

| Aspect | Points | Check |
|--------|--------|-------|
| Clear description | 10 | Actionable, specific |
| Good name | 5 | Descriptive |
| Use case clarity | 5 | When to delegate |

---

## Quality Grades

| Grade | Score | Description |
|-------|-------|-------------|
| A | 90-100 | Exemplary configuration |
| B | 75-89 | Good with minor gaps |
| C | 60-74 | Adequate, needs improvement |
| D | 40-59 | Poor, significant issues |
| F | 0-39 | Failing, critical errors |

---

## VALIDATE Workflow

**Purpose**: Check configuration compliance

**Process**:
1. Parse YAML frontmatter
2. Check required fields
3. Validate field values
4. Score each dimension
5. Generate report

---

## OPTIMIZE Workflow

**Purpose**: Fix configuration issues

**Process**:
1. Review validation findings
2. Prioritize by impact
3. Fix high-priority issues
4. Re-validate
5. Achieve ≥80/100

---

## Common Issues

### Critical (Score <60)
- Missing required fields
- Invalid field names
- YAML syntax errors
- Wrong context

### Warning (Score 60-80)
- Vague description
- Inappropriate model
- Missing tool restrictions
- No hooks for safety

### Best Practices (Score >90)
- Specific description
- Appropriate model
- Proper restrictions
- Safety hooks configured

---

## Success Criteria

**Production Ready**: ≥80/100 (Grade B)

**All Dimensions**:
- Configuration Validity: ≥16/20
- Frontmatter Correctness: ≥12/15
- Context Appropriateness: ≥12/15
- Tool Restrictions: ≥12/15
- Skills Integration: ≥12/15
- Documentation Quality: ≥16/20

See also: configuration-guide.md, context-detection.md, coordination-patterns.md
