# Progressive Disclosure Knowledge Specification

## Summary
This specification defines the progressive disclosure pattern for skill documentation, emphasizing the critical <500 line limit for SKILL.md and proper tier structure (Tier 1/2/3) to optimize token usage and maintainability.

## Critical Violations

### Current Status
**VIOLATION**: 2 of 18 skills exceed 500-line limit

| Skill | Lines | Status | Required Action |
|-------|-------|--------|----------------|
| test-runner/SKILL.md | 845 lines | ❌ VIOLATION | Extract to references/ |
| ralph-orchestrator-expert/SKILL.md | 573 lines | ❌ VIOLATION | Extract to references/ |

**Impact**:
- Violates progressive disclosure rule
- Wastes token budget on Tier 1 load
- Reduces skill discoverability
- Contradicts specification requirements

## Progressive Disclosure Architecture

### Tier Structure

#### Tier 1: YAML Frontmatter (~100 tokens)
**Always loaded** when skill is referenced
**Contains**:
- name
- description
- user-invocable
- hooks (if applicable)
- Other frontmatter fields

**Purpose**: Quick skill identification and basic understanding
**Token Budget**: ~100 tokens maximum
**CRITICAL**: Must remain minimal to reduce token waste

#### Tier 2: SKILL.md (<500 lines)
**Loaded on skill activation**
**Contains**:
- Core implementation workflows
- Examples of usage
- Basic patterns and guidance
- Integration instructions

**Purpose**: Complete skill usage without deep details
**Token Budget**: <500 lines (≈4000 tokens)
**CRITICAL**: Must stay under 500 lines

#### Tier 3: references/ (On-Demand)
**Loaded only when needed**
**Contains**:
- Deep technical details
- Comprehensive examples
- Troubleshooting guides
- Advanced patterns
- Edge case handling

**Purpose**: Detailed reference for complex scenarios
**Token Budget**: Unlimited (loaded on-demand)
**Structure**: Multiple files as needed

## Given-When-Then Acceptance Criteria

### G1: SKILL.md Line Limit
**Given** a skill in `.claude/skills/skill-name/SKILL.md`
**When** line count exceeds 500 lines
**Then** it MUST:
- Create references/ directory
- Extract detailed content to reference files
- Maintain SKILL.md <500 lines
- Preserve Tier 1/2/3 structure

### G2: References Directory
**Given** content extracted to references/
**When** creating reference files
**Then** it MUST:
- Place files in `.claude/skills/skill-name/references/`
- Name files descriptively (e.g., troubleshooting.md)
- Keep each reference file <500 lines
- Link to references from SKILL.md

### G3: Tier 1 Optimization
**Given** a skill's YAML frontmatter
**When** evaluating for Tier 1
**Then** it MUST:
- Keep description concise (~1-2 sentences)
- Avoid detailed explanations in description
- Focus on actionable triggers
- Stay under ~100 tokens

### G4: Tier 2 Completeness
**Given** SKILL.md <500 lines
**When** user activates skill
**Then** it MUST provide:
- Complete workflow examples
- Basic integration patterns
- Common use cases
- Essential implementation guidance

### G5: Tier 3 Accessibility
**Given** complex skill with references/
**When** user needs deep details
**Then** references/ MUST:
- Be discoverable from SKILL.md
- Provide comprehensive coverage
- Include troubleshooting
- Offer advanced examples

## Refactoring Patterns

### Pattern 1: Extract Troubleshooting
**What to Move**: Detailed troubleshooting sections
**Target**: `references/troubleshooting.md`
**Keep in SKILL.md**: Brief troubleshooting summary

**Example**:
```markdown
# SKILL.md (before)
## Troubleshooting
### Common Errors
[200 lines of detailed troubleshooting]

# SKILL.md (after)
## Troubleshooting
See [references/troubleshooting.md](references/troubleshooting.md) for comprehensive troubleshooting guide.

# references/troubleshooting.md
# Troubleshooting Guide

## Common Errors
[200 lines of detailed troubleshooting]
```

### Pattern 2: Extract Examples
**What to Move**: Extensive examples section
**Target**: `references/examples.md`
**Keep in SKILL.md**: Core examples only

### Pattern 3: Extract Patterns
**What to Move**: Advanced patterns and variations
**Target**: `references/patterns.md`
**Keep in SKILL.md**: Basic patterns with links

### Pattern 4: Extract Integration Details
**What to Move**: Complex integration instructions
**Target**: `references/integration.md`
**Keep in SKILL.md**: Simple integration steps

## Input/Output Examples

### Example 1: Perfect Progressive Disclosure
**Structure**:
```
.claude/skill-name/
├── SKILL.md (450 lines)
└── references/
    ├── troubleshooting.md (200 lines)
    ├── patterns.md (150 lines)
    └── examples.md (250 lines)
```

**SKILL.md** (450 lines):
```markdown
# Skill Name

## Description
Brief description (Tier 1: ~100 tokens)

## Core Workflows
[Workflow examples - 200 lines]

## Integration
[Basic integration - 100 lines]

## Examples
[Basic examples - 100 lines]

## Advanced
See [references/patterns.md](references/patterns.md) for advanced patterns.

## Troubleshooting
See [references/troubleshooting.md](references/troubleshooting.md) for detailed troubleshooting.

## References
- [patterns.md](references/patterns.md)
- [examples.md](references/examples.md)
- [troubleshooting.md](references/troubleshooting.md)
```

### Example 2: Refactoring Oversized SKILL.md
**Before** (845 lines - test-runner violation):
```
.claude/skills/test-runner/
└── SKILL.md (845 lines)
```

**After** (proper structure):
```
.claude/skills/test-runner/
├── SKILL.md (450 lines)
└── references/
    ├── execution-patterns.md (200 lines)
    ├── autonomy-testing.md (150 lines)
    ├── troubleshooting.md (180 lines)
    └── integration-guide.md (165 lines)
```

**Refactoring Steps**:
1. Count current lines: 845
2. Identify content types:
   - Core workflows: 200 lines
   - Examples: 150 lines
   - Execution patterns: 200 lines
   - Autonomy testing: 150 lines
   - Troubleshooting: 145 lines
3. Extract to references/:
   - execution-patterns.md
   - autonomy-testing.md
   - troubleshooting.md
4. Keep in SKILL.md:
   - Core workflows: 200 lines
   - Basic examples: 100 lines
   - Integration: 100 lines
   - Links to references: 50 lines
5. Total SKILL.md: 450 lines ✓

### Example 3: Ralph-Orchestrator-Expert Refactor
**Before** (573 lines):
```
.claude/skills/ralph-orchestrator-expert/
└── SKILL.md (573 lines)
```

**Action**: Extract 73+ lines to references/
**Target**:
```
.claude/skills/ralph-orchestrator-expert/
├── SKILL.md (499 lines)
└── references/
    ├── workflow-coordination.md
    ├── multi-session-patterns.md
    └── advanced-orchestration.md
```

## Edge Cases and Error Conditions

### E1: SKILL.md Significantly Over Limit
**Condition**: SKILL.md >1000 lines
**Example**: ralph-orchestrator-expert was 1730 lines (reduced to 573)
**Error**: `PROGRESSIVE_DISCLOSURE_VIOLATION`
**Resolution**:
1. Audit all content for tier classification
2. Extract all Tier 3 content to references/
3. Aggressive refactoring may be needed
4. Verify each reference file <500 lines

### E2: Empty References Directory
**Condition**: references/ directory exists but empty
**Error**: `ORPHANED_REFERENCES` - Directory created but unused
**Resolution**:
1. Remove empty references/ directory
2. Or populate with extracted content
3. Don't create references/ unless needed

### E3: References Exceed Practical Limits
**Condition**: references/ directory itself becomes unwieldy
**Example**: Largest reference file is 1043 lines
**Error**: `REFERENCES_OVERFLOW` - References need subdivision
**Resolution**:
1. Further subdivide large reference files
2. Create subdirectories in references/ if needed
3. Maintain <500 lines per reference file

### E4: Missing Links to References
**Condition**: references/ exist but SKILL.md doesn't link to them
**Error**: `ORPHANED_REFERENCES` - References not discoverable
**Resolution**:
1. Add links in SKILL.md
2. Create references section
3. Ensure discoverability

### E5: Tier 1 Bloat
**Condition**: YAML frontmatter description >100 tokens
**Error**: `TIER1_BLOAT` - Wastes token budget
**Resolution**:
1. Condense description to 1-2 sentences
2. Move details to SKILL.md
3. Keep frontmatter minimal

## Implementation Guidelines

### Step 1: Audit Current State
```bash
# Count lines in all SKILL.md files
find .claude/skills -name "SKILL.md" -exec wc -l {} | sort -nr

# Identify violations
find .claude/skills -name "SKILL.md" -exec sh -c 'if [ $(wc -l < "$1") -gt 500 ]; then echo "$1: $(wc -l < "$1") lines"; fi' _ {} \;
```

### Step 2: Content Classification
**Classify each section**:
- Tier 1: YAML frontmatter only
- Tier 2: Core workflows, examples, integration (<500 lines)
- Tier 3: Deep details, troubleshooting, patterns

### Step 3: Extract to References
**Create references/ directory**:
```bash
mkdir .claude/skills/skill-name/references
```

**Extract content**:
1. Create descriptive filenames
2. Move Tier 3 content
3. Maintain logical grouping
4. Keep each reference <500 lines

### Step 4: Update SKILL.md
**Add references section**:
```markdown
## References
- [Advanced Patterns](references/patterns.md)
- [Troubleshooting](references/troubleshooting.md)
- [Examples](references/examples.md)
```

**Link within document**:
```markdown
For detailed troubleshooting, see [references/troubleshooting.md](references/troubleshooting.md).
```

### Step 5: Verify Compliance
```bash
# Verify SKILL.md <500 lines
wc -l .claude/skills/skill-name/SKILL.md

# Verify references/ exists and has content
ls -la .claude/skills/skill-name/references/

# Verify each reference <500 lines
find .claude/skills/skill-name/references -name "*.md" -exec wc -l {} \;
```

## Quality Framework Integration

### Discoverability
- Clear tier structure
- References easily found
- Links within SKILL.md
- Descriptive filenames

### Maintainability
- Easy to find content
- Clear separation of concerns
- Logical grouping
- Simple addition of new references

### Standards Compliance
- Follows Agent Skills specification
- Maintains <500 line limit
- Proper tier classification
- References structure correct

## Anti-Patterns to Avoid

### ❌ Pattern 1: No References Despite Size
**Problem**: SKILL.md = 800 lines, no references/
**Violation**: Progressive disclosure rule broken
**Solution**: Extract to references/ immediately

### ❌ Pattern 2: All Content in References
**Problem**: SKILL.md = 50 lines, references/ = 800 lines
**Issue**: Tier 2 lacks essential content
**Solution**: Keep core workflows in SKILL.md

### ❌ Pattern 3: Missing Links
**Problem**: references/ exist but no links in SKILL.md
**Issue**: References not discoverable
**Solution**: Add references section with links

### ❌ Pattern 4: Over-Extraction
**Problem**: SKILL.md too minimal (<200 lines)
**Issue**: Tier 2 lacks completeness
**Solution**: Keep essential content in SKILL.md

### ❌ Pattern 5: Unclear Naming
**Problem**: references/section1.md, section2.md
**Issue**: Poor discoverability
**Solution**: Use descriptive names: troubleshooting.md

## Benefits of Progressive Disclosure

### Token Efficiency
- Tier 1 loads ~100 tokens (minimal)
- Tier 2 loads ~4000 tokens when needed
- Tier 3 loads on-demand only
- Reduces overall token consumption

### Skill Discoverability
- Quick skill identification
- Clear tier structure
- Easy navigation
- Better user experience

### Maintainability
- Logical content organization
- Easy updates and changes
- Clear ownership
- Simplified testing

## Current Implementation Status

### ✅ Compliant Skills
- Most skills (16/18) maintain proper structure
- References/ directories used appropriately
- Tier 1/2/3 structure maintained

### ❌ Non-Compliant (Critical)
- test-runner: 845 lines (VIOLATION)
- ralph-orchestrator-expert: 573 lines (VIOLATION)

### 📋 Refactoring Status
- ralph-orchestrator-expert: Reduced from 1730 to 573 lines
- test-runner: Needs extraction to references/

## Fix Priority

### Immediate (Critical)
1. Refactor test-runner: Extract 345+ lines to references/
2. Refactor ralph-orchestrator-expert: Extract 73+ lines to references/
3. Verify both <500 lines after refactor
4. Test skills still function correctly

### Short-term (High)
5. Audit all skills for compliance
6. Create automated line count validation
7. Add progressive disclosure to quality framework
8. Train developers on tier structure

### Medium-term (Medium)
9. Build validation tools
10. Create refactoring automation
11. Monitor compliance over time
12. Establish progressive disclosure best practices

## Validation Process

### Automated Check
```bash
# Check all SKILL.md files
find .claude/skills -name "SKILL.md" | while read file; do
  lines=$(wc -l < "$file")
  if [ $lines -gt 500 ]; then
    echo "VIOLATION: $file has $lines lines"
  fi
done
```

### Manual Review
1. Verify tier structure makes sense
2. Check references/ links exist
3. Ensure core content in SKILL.md
4. Validate references are discoverable

## Out of Scope

### Not Covered by This Specification
- Content quality within tiers
- WIN CONDITION markers
- Autonomy requirements
- Context fork patterns

## References
- Quality framework: `.claude/rules/quality-framework.md`
- Architecture rules: `.claude/rules/architecture.md`
- Skills specification: `specs/skills.spec.md`
- Test-runner skill: `.claude/skills/test-runner/SKILL.md`
- Ralph orchestrator: `.claude/skills/ralph-orchestrator-expert/SKILL.md`
