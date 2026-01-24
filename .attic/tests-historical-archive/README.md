# Historical Test Archives

This directory contains older test versions and trial runs that have been superseded by the current test structure.

## What Was Moved Here

- **Old test directories** from `.attic/` that were scattered and unorganized
- **Previous versions** of tests that have been re-executed in the new structure
- **Trial runs** and experiments that informed the current test framework

## Current Test Structure

All **current and active** tests are in:
- `raw_logs/` - Test execution outputs organized by phase
- `results/FINAL_TEST_COMPLETION_REPORT.md` - Primary results document
- `skill_test_plan.json` - Master test specification

## Using This Directory

**For Reference Only**: These tests are preserved for historical context and were used to develop the current understanding of skill behavior.

**For Current Testing**: Use the files in the main `tests/` directory structure.

## What We Learned

These historical tests led to the discovery of:
1. Regular → Regular skill calling is one-way handoff
2. Forked skills enable subroutine patterns
3. Context isolation is complete in forked skills
4. Forked skills achieve 100% autonomy
5. Hub-and-spoke architecture is the recommended pattern

---

**Main Documentation**: See `../README.md` and `../INDEX.md` for current test framework.
