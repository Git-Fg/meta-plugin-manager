# Complete Workflow

This reference covers the complete workflow from initial setup through final deliverables.

## Complete Workflow (Setup to Deliverables)

### Initial Setup
1. **Review Framework**:
   - Read this skill documentation
   - Review test plan structure
   - Understand expected discoveries
   - Prepare TaskList tracking

2. **Create Master TaskList**:
   - "Execute All Tests" (master task)
   - "Phase 1: Basic Skill Calling"
   - "Phase 2: Forked Skills"
   - "Phase 3: Forked + Subagents"
   - "Phase 4: Advanced Patterns"
   - "Phase 5: Context Transfer"
   - "Phase 6: Error Handling"
   - "Phase 7: Real-World"
   - "Generate Final Deliverables"

### Per-Test Execution Loop
For each NOT_STARTED test:

1. **Setup Phase**:
   - Create test task
   - Create folder structure
   - Generate skills from spec
   - Verify prerequisites

2. **Execute Phase**:
   - Run test with CLI flags
   - Capture NDJSON output
   - Monitor execution

3. **Validate Phase**:
   - Check NDJSON structure
   - Calculate autonomy score
   - Verify completion markers
   - Answer key questions

4. **Document Phase**:
   - Update test plan
   - Record findings
   - Archive test (if pass)
   - Plan next steps

### Phase Completion Review
After each phase:
- Review all test results
- Identify patterns
- Update mental model
- Document discoveries
- Prepare for next phase

### Final Deliverables Generation
After all tests complete:

1. **Test Results Document** - All test outputs
2. **Findings Summary** - Key discoveries
3. **Pattern Catalog** - Validated patterns
4. **Best Practices** - How to use skills
5. **Anti-Patterns** - What to avoid
6. **Mental Model** - Updated understanding
