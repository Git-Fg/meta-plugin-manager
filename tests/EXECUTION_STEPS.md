# Test Execution Steps - Quick Reference

## How to Execute the Tests

### Step 1: Review Test Plan
```bash
cd /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/
cat README.md
cat skill_test_plan.json | jq '.test_plan.phases[0]'  # View first phase
```

### Step 2: Start with Phase 1, Test 1.1
```bash
# Create test skills in a temp directory
mkdir -p /tmp/test-skills/skill-b
mkdir -p /tmp/test-skills/skill-a
```

### Step 3: Create skill-b (Transitive)
```yaml
---
name: skill-b
description: "Simple transitive skill for testing"
---

## SKILL_B_COMPLETE

Processing completed successfully.
Output: Test data from skill-b
```

### Step 4: Create skill-a (Regular Caller)
```yaml
---
name: skill-a
description: "Caller skill that calls skill-b"
---

## SKILL_A_STARTED

Calling skill-b to process data...
[Execute skill-b]

Skill-b completed successfully. Received: "Test data from skill-b"

## SKILL_A_COMPLETE
```

### Step 5: Test Execution
```bash
# Copy to project and test
cp -r /tmp/test-skills/* .claude/skills/

# Execute test
/call skill-a

# Verify output contains:
# 1. "## SKILL_A_STARTED"
# 2. "## SKILL_B_COMPLETE" (marker from skill-b)
# 3. "## SKILL_A_COMPLETE"
```

### Step 6: Document Results
```markdown
## Test 1.1 Results

**Setup**: ✅ Created skill-b (transitive) and skill-a (regular)
**Execution**: ✅ Called skill-a
**Results**:
- ✅ Win condition marker "## SKILL_B_COMPLETE" appeared
- ✅ Results passed back to skill-a
- ✅ skill-a completed with "## SKILL_A_COMPLETE"

**Conclusion**: PASS - Win conditions work correctly
```

### Step 7: Progress to Next Test (1.2)
```bash
# Create skill-c
cat > /tmp/test-skills/skill-c/SKILL.md << 'EOF'
---
name: skill-c
description: "Final skill in chain"
---

## SKILL_C_COMPLETE

Final processing step completed.
EOF

# Update skill-b to call skill-c
# Update skill-a to call skill-b

# Test chain: skill-a → skill-b → skill-c
```

### Step 8: Move to Phase 2 (Forked Skills)
```yaml
---
name: skill-forked
description: "Forked skill for testing isolation"
context: fork
agent: Explore
---

## SKILL_FORKED_COMPLETE

Forked execution completed.
Isolation: Verified - no access to main context
Tools available: Explore tools (Read, Grep, Glob)
```

**Test**: Regular skill calls forked skill
**Verify**: Forked skill has no access to main conversation

### Step 9: Continue Through All Phases
For each test:
1. Create skill files
2. Execute test
3. Verify markers appear
4. Check context behavior
5. Document results
6. Move to next test

### Step 10: Document All Findings
```markdown
# Skill Testing Results

## Phase 1: Basic Calling
- Test 1.1: PASS
- Test 1.2: PASS

## Phase 2: Forked Skills
- Test 2.1: PASS
- Test 2.2: PASS
- Test 2.3: PASS

## Phase 3: Forked + Subagents
- Test 3.1: PASS
- Test 3.2: PASS

[Continue for all phases...]

## Key Findings
1. Win conditions work as expected
2. Context isolation is real
3. Forked skills can access subagents
4. [Other findings...]

## Conclusions
[Overall conclusions...]
```

## Key Commands

### Create Skills
```bash
mkdir -p .claude/skills/<skill-name>
cat > .claude/skills/<skill-name>/SKILL.md << 'EOF'
[YAML frontmatter]
---
[Skill content]
## WIN_CONDITION_MARKER
[Output]
EOF
```

### Test Execution
```bash
# Call skill
/call <skill-name> [parameters]

# Verify markers
grep "##.*_COMPLETE" <output>
```

### Validation Checklist
```bash
For each test:
□ Skills created
□ Win conditions defined
□ Test executed
□ Markers verified
□ Context checked
□ Results documented
```

## Timeline

- **Phase 1** (2 tests): ~30 min
- **Phase 2** (3 tests): ~45 min
- **Phase 3** (2 tests): ~45 min
- **Phase 4** (3 tests): ~60 min
- **Phase 5** (2 tests): ~30 min
- **Phase 6** (2 tests): ~30 min
- **Phase 7** (2 tests): ~60 min

**Total**: ~5 hours

## Success Metrics

✅ **All markers appear**
✅ **Context behaves correctly**
✅ **Results transfer properly**
✅ **No unexpected errors**

## Documentation Template

```markdown
## Test [ID]: [Name]

**Setup**:
- Skills created: [list]
- Relationships: [diagram]

**Execution**:
1. [Step]
2. [Step]
3. [Step]

**Results**:
- ✅/❌ [Validation]
- ✅/❌ [Validation]

**Observations**:
- [What happened]

**Conclusion**:
- [Pass/Fail/Finds]
```

## Critical Success Factors

1. **Start Small**: Begin with Phase 1, Test 1.1
2. **Document Everything**: Record all observations
3. **Verify Markers**: Ensure win conditions appear
4. **Check Context**: Validate isolation/preservation
5. **Progress Gradually**: Complete phases sequentially
6. **Stay Organized**: Keep test files tidy
7. **Question Everything**: Note unexpected behavior

## Getting Help

If stuck:
1. Review quick_reference.md
2. Check test_implementation_guide.md
3. Verify skill setup
4. Check for errors
5. Document issue and continue

## After Testing

1. Compile all results
2. Identify patterns
3. Update mental model
4. Apply to real projects
5. Share findings

---

**Ready to begin? Start with Phase 1, Test 1.1!**
```