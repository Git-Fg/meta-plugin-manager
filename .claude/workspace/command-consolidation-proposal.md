# Command Consolidation Proposal

**Date**: 2026-01-28
**Status**: Draft
**Purpose**: Reduce command surface area through intelligent consolidation

---

## Executive Summary

**Current state**: 63 commands across multiple namespaces
**Proposed state**: ~35 commands (45% reduction)
**Strategy**: Auto-detection + context routing (following `/plan:` pattern)

---

## Consolidation Opportunities

### Priority 1: Clear Duplicates

#### 1. Handoff Commands (3 → 1)

**Current**:

- `/whats-next` - DEPRECATED (points to `/plan:handoff`)
- `/plan:handoff` - Planning-specific handoffs
- `/handoff:create` - General session handoffs

**Proposal**: `/handoff` (auto-detects context)

- Detects if in planning context → uses planning handoff format
- Otherwise → uses general handoff format
- Unified location: `.claude/workspace/handoffs/`

**Savings**: 2 commands

---

#### 2. Audit Commands (5 → 1)

**Current**:

- `/audit-skill` - Generic skill audit
- `/audit-slash-command` - Generic command audit
- `/audit-subagent` - Generic subagent audit
- `/toolkit/command/audit` - Toolkit command audit
- `/toolkit/skill/audit` - Toolkit skill audit

**Proposal**: `/audit` (auto-detects target)

```
Context detection:
- Recent component creation → audit that component
- User specifies path → audit that path
- "audit all" → bulk audit via qa/audit-skills
- Auto-detects component type (skill/command/agent)
```

**Savings**: 4 commands

---

#### 3. Meta-Critic Commands (2 → 1)

**Current**:

- `/toolkit/command/metacritic` - Command meta-critic
- `/toolkit/skill/metacritic` - Skill meta-critic

**Proposal**: `/metacritic` (auto-detects target)

- Same logic as audit consolidation
- Auto-detects component type
- Unified three-way review process

**Savings**: 1 command

---

### Priority 2: High-Value Mergers

#### 4. Execute Commands (2 → 1)

**Current**:

- `/plan:execute` - Execute single PLAN.md
- `/plan:execute-all` - Execute all incomplete plans

**Proposal**: `/plan:execute` (with smart defaults)

```
/plan:execute              → auto-detects next incomplete plan
/plan:execute --all        → execute all incomplete plans
/plan:execute <path>       → execute specific plan
```

**Savings**: 1 command

---

#### 5. Analysis Commands (3 → 1)

**Current**:

- `/analysis:diagnose` - Diagnose issues
- `/analysis:explore` - Explore through questioning
- `/analysis:reason` - Strategic analysis

**Proposal**: `/analyze` (routes to appropriate workflow)

```
Context detection:
- "diagnose" / "what went wrong" → diagnose workflow
- "explore" / "understand" → explore workflow
- "stuck" / "try again" → reason workflow
```

**Savings**: 2 commands

---

#### 6. Create Commands (2 → 1)

**Current**:

- `/toolkit/command/create` - Create commands
- `/toolkit/skill/create` - Create skills

**Proposal**: `/create` (auto-detects type)

```
Context detection:
- "command" in request → create command
- "skill" in request → create skill
- "rooter" / "package" → invoke /toolkit:rooter
```

**Implementation**: Could use `/toolkit:rooter` as the unified entry point

**Savings**: 1 command

---

### Priority 3: Component Architecture Consolidation

#### 7. Component Selection Commands (3 → 1)

**Current**:

- `/component:which` - Determine component type
- `/component:component-architect` - Route to development skill
- `/component:build` - Orchestrate development

**Proposal**: `/component` (unified workflow)

```
/component              → auto-detect need → route to appropriate skill
/component <type>       → create specific component type
```

**Rationale**: All three commands analyze and route - single entry point clearer

**Savings**: 2 commands

---

### Priority 4: Resume Consolidation

#### 8. Resume Commands (2 → 1)

**Current**:

- `/plan:resume` - Resume from planning handoff
- `/continue` - Continue through clarifying questions

**Proposal**: `/resume` (unified)

```
Context detection:
- Handoff file exists → load handoff
- Otherwise → clarify intent through questions
```

**Savings**: 1 command

---

### Priority 5: QA Consolidation

#### 9. Verify Commands (2 → 1)

**Current**:

- `/qa:verify` - Comprehensive verification
- `/qa:code-review` - Security and quality review

**Proposal**: `/verify` (smart routing)

```
/verify                 → full verification (build, test, security, diff)
/verify --security      → security-focused review
/verify --quick         → essential checks only
```

**Rationale**: Both commands perform quality checks - unify with flags

**Savings**: 1 command

---

## Commands to Keep Separate

### Consider Commands (12 commands)

**Rationale**: Each command implements a specific mental model/framework

- Simple, focused, single-purpose
- User knows exactly which mental model they're invoking
- Auto-detection would be ambiguous

**Namespaces**: `/consider:pareto`, `/consider:swot`, `/consider:5-whys`, etc.

---

### Learning Commands (5 commands)

**Rationale**: Each has distinct purpose

- `archive` - Capture discoveries
- `context-drift` - Centralize scattered knowledge
- `list-skills` - List available skills
- `pattern-extractor` - Extract patterns
- `refine-rules` - Analyze documentation quality

**Potential consolidation**: `pattern-extractor` could be merged into `archive`

---

### Retrieval Command (1 command)

**Status**: Already optimized as single `/retrieval:search` command

---

## Proposed Namespace Structure

### Before (current):

```
/plan:create
/plan:execute
/plan:execute-all
/plan:handoff
/plan:resume
/analysis:diagnose
/analysis:explore
/analysis:reason
/audit-skill
/audit-slash-command
/audit-subagent
/toolkit/command/create
/toolkit/skill/create
/toolkit/command/audit
/toolkit/skill/audit
... (63 total)
```

### After (proposed):

```
/plan                   # All planning operations
/handoff                # All handoff operations
/analyze                # All analysis workflows
/audit                  # All audit operations
/metacritic             # All meta-critic reviews
/create                 # All component creation
/component              # All component workflows
/resume                 # All resume operations
/verify                 # All verification workflows
/consider:*             # 12 mental model commands (keep separate)
/learning:*             # 5 learning commands (keep mostly separate)
/retrieval:search       # Single search command
```

**Reduction**: 63 → ~35 commands (45% reduction)

---

## Implementation Strategy

### Phase 1: High-Impact Consolidations

1. **Merge execute commands** (1 command)
   - Add `--all` flag to `/plan:execute`
   - Deprecate `/plan:execute-all`

2. **Merge audit commands** (4 commands)
   - Create `/audit` with auto-detection
   - Deprecate individual audit commands

3. **Merge handoff commands** (2 commands)
   - Create `/handoff` with context detection
   - Keep `/plan:handoff` as deprecated alias

### Phase 2: Namespace Consolidations

4. **Merge analysis commands** (2 commands)
5. **Merge create commands** (1 command)
6. **Merge component commands** (2 commands)

### Phase 3: Final Polish

7. **Merge resume commands** (1 command)
8. **Merge verify commands** (1 command)
9. **Update all documentation**

---

## Migration Guide

For each consolidation:

1. **Create new unified command** with auto-detection
2. **Add deprecation notice** to old commands
3. **Update documentation** (CLAUDE.md, skills)
4. **Wait 1-2 releases** before removing deprecated commands
5. **Communicate changes** clearly in commit messages

---

## Success Criteria

- [ ] 45% reduction in command count (63 → ~35)
- [ ] All consolidated commands use auto-detection
- [ ] No loss of functionality
- [ ] Clear deprecation paths
- [ ] Documentation updated
- [ ] User feedback positive

---

## Open Questions

1. Should `/toolkit:rooter` become the unified `/create` command?
2. Should consider commands be consolidated under `/mental-model` namespace?
3. Should we create `/workflow` namespace for complex multi-step operations?

---

## Next Steps

1. ✅ Review complete command inventory
2. **Get user approval** on consolidation priorities
3. **Begin Phase 1** implementations
4. **Test consolidated commands** thoroughly
5. **Monitor for issues** and iterate

---

**Prepared by**: Command consolidation analysis
**Review date**: 2026-01-28
