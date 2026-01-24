# Knowledge Extraction Mapping

**Migration Date**: 2026-01-24
**Source**: v3 Architect Skills
**Destination**: v4 Knowledge Skills

---

## Overview

This document maps all knowledge content from the v3 "architect skills" to the new v4 "knowledge skills". Each reference file is mapped to its destination, with notes on content type.

---

## skill-architect → knowledge-skills

### Source: `.attic/architect-skills-archive-*/skill-architect/`

| Source File | Content | Destination | Notes |
|-------------|---------|-------------|-------|
| SKILL.md | Delta Standard, Progressive Disclosure patterns, Quality Framework concepts, Anti-pattern recognition | knowledge-skills/SKILL.md | Extract core knowledge, remove workflow logic |
| references/progressive-disclosure.md | Tier 1/2/3 structure, decision trees | knowledge-skills/references/progressive-disclosure.md | Direct copy |
| references/quality-framework.md | 11-dimensional scoring system (0-160 scale) | knowledge-skills/references/quality-framework.md | Direct copy |
| references/description-guidelines.md | What-When-Not framework | knowledge-skills/references/description-guidelines.md | Direct copy |
| references/autonomy-design.md | 80-95% autonomy patterns | knowledge-skills/references/autonomy-design.md | Direct copy |
| references/orchestration-patterns.md | Hub-and-spoke, context fork, workflows | knowledge-skills/references/orchestration-patterns.md | Direct copy |
| references/anti-patterns.md | Complete anti-pattern catalog | knowledge-skills/references/anti-patterns.md | Direct copy |

**Total Files**: 1 SKILL.md + 6 reference files = 7 files

**Knowledge to Extract** (from SKILL.md):
- Delta Standard philosophy
- Progressive Disclosure tiers
- Quality Framework dimensions
- What-When-Not description framework
- Autonomy design patterns
- Architectural patterns (Hub-and-Spoke, Context Fork)
- Anti-patterns recognition

**Execution Logic to Remove** (from SKILL.md):
- Workflow detection logic
- Creation guidance steps
- Evaluation instructions
- Enhancement recommendations
- Multi-workflow detection engine

---

## mcp-architect → knowledge-mcp

### Source: `.attic/architect-skills-archive-*/mcp-architect/`

| Source File | Content | Destination | Notes |
|-------------|---------|-------------|-------|
| SKILL.md | MCP protocol knowledge, transport mechanisms, primitives, integration patterns | knowledge-mcp/SKILL.md | Extract core knowledge, remove workflows |
| references/integration.md | Decision guide for MCP usage | knowledge-mcp/references/integration.md | Direct copy |
| references/servers.md | Server configuration and deployment | knowledge-mcp/references/servers.md | Direct copy |
| references/tools.md | Tool development and schemas | knowledge-mcp/references/tools.md | Direct copy |
| references/resources.md | Resources and prompts implementation | knowledge-mcp/references/resources.md | Direct copy |
| references/protocol-guide.md | Protocol definition and transport mechanisms | knowledge-mcp/references/protocol-guide.md | Direct copy |
| references/compliance-framework.md | Quality scoring system | knowledge-mcp/references/compliance-framework.md | Direct copy |
| references/transport-mechanisms.md | Transport types (stdio/http) | knowledge-mcp/references/transport-mechanisms.md | Direct copy |
| references/component-templates.md | Tool/Resource/Prompt templates | knowledge-mcp/references/component-templates.md | Direct copy |
| references/output-contracts.md | Workflow output formats | knowledge-mcp/references/output-contracts.md | Direct copy |
| references/tasklist-compliance.md | TaskList integration patterns | knowledge-mcp/references/tasklist-compliance.md | Direct copy |

**Total Files**: 1 SKILL.md + 10 reference files = 11 files

**Knowledge to Extract** (from SKILL.md):
- MCP protocol specification
- Transport mechanisms (stdio/streamable-http)
- MCP primitives (tools/resources/prompts)
- Integration patterns
- Server configuration standards

**Execution Logic to Remove** (from SKILL.md):
- DISCOVER/INTEGRATE/VALIDATE/OPTIMIZE workflows
- Detection engine logic
- Configuration merge strategies
- Quality scoring execution
- Output contract execution

---

## hooks-architect → knowledge-hooks

### Source: `.attic/architect-skills-archive-*/hooks-architect/`

| Source File | Content | Destination | Notes |
|-------------|---------|-------------|-------|
| SKILL.md | Hook events, security patterns, exit codes, configuration types | knowledge-hooks/SKILL.md | Extract core knowledge, remove workflows |
| references/security-patterns.md | Common security guardrails | knowledge-hooks/references/security-patterns.md | Direct copy |
| references/hook-types.md | Event types, use cases | knowledge-hooks/references/hook-types.md | Direct copy |
| references/hook-patterns.md | Hook implementation patterns | knowledge-hooks/references/hook-patterns.md | Direct copy |
| references/script-templates.md | Validation script patterns | knowledge-hooks/references/script-templates.md | Direct copy |
| references/implementation-patterns.md | Hook implementation patterns | knowledge-hooks/references/implementation-patterns.md | Direct copy |
| references/compliance-framework.md | Quality scoring system | knowledge-hooks/references/compliance-framework.md | Direct copy |
| references/events.md | Detailed event documentation | knowledge-hooks/references/events.md | Direct copy |

**Total Files**: 1 SKILL.md + 7 reference files = 8 files

**Knowledge to Extract** (from SKILL.md):
- Hook events (PreToolUse/PostToolUse/Stop)
- Security patterns
- Exit code conventions (0=success, 2=blocking)
- Configuration types (settings.json vs component-scoped)
- Script templates

**Execution Logic to Remove** (from SKILL.md):
- INIT/SECURE/AUDIT/REMEDIATE workflows
- Security detection logic
- Configuration creation steps
- Script scaffolding execution

---

## subagents-architect → knowledge-subagents

### Source: `.attic/architect-skills-archive-*/subagents-architect/`

| Source File | Content | Destination | Notes |
|-------------|---------|-------------|-------|
| SKILL.md | Agent types, frontmatter fields, context detection, coordination patterns | knowledge-subagents/SKILL.md | Extract core knowledge, remove workflows |
| references/configuration-guide.md | Valid frontmatter fields | knowledge-subagents/references/configuration-guide.md | Direct copy |
| references/context-detection.md | Project vs plugin vs user context | knowledge-subagents/references/context-detection.md | Direct copy |
| references/coordination-patterns.md | Multi-agent orchestration | knowledge-subagents/references/coordination-patterns.md | Direct copy |
| references/coordination.md | Agent coordination patterns | knowledge-subagents/references/coordination.md | Direct copy |
| references/validation-framework.md | 6-dimensional quality scoring | knowledge-subagents/references/validation-framework.md | Direct copy |
| references/when-to-use.md | Guidelines for agent usage | knowledge-subagents/references/when-to-use.md | Direct copy |

**Total Files**: 1 SKILL.md + 6 reference files = 7 files

**Knowledge to Extract** (from SKILL.md):
- Agent types (general-purpose/bash/explore/plan)
- Valid frontmatter fields
- Context detection patterns (project/plugin/user)
- Coordination patterns
- Tool restrictions

**Execution Logic to Remove** (from SKILL.md):
- DETECT/CREATE/VALIDATE/OPTIMIZE workflows
- Context detection logic
- Configuration validation execution
- Agent creation steps

---

## Summary Statistics

| Metric | Count |
|--------|-------|
| **Total Source Files** | 33 (4 SKILL.md + 29 references) |
| **Total Destination Files** | 33 (4 SKILL.md + 29 references) |
| **Knowledge Skills Created** | 4 |
| **Reference Files Migrated** | 29 |

### By Domain

| Domain | SKILL.md Lines (est.) | Reference Files | Total Knowledge |
|--------|---------------------|-----------------|-----------------|
| knowledge-skills | ~150 (extracted from 370) | 6 | Skill standards |
| knowledge-mcp | ~100 (extracted from 514) | 10 | MCP protocol |
| knowledge-hooks | ~80 (extracted from 546) | 7 | Hook patterns |
| knowledge-subagents | ~100 (extracted from 592) | 6 | Agent config |

---

## Migration Strategy

### Step 1: Copy Reference Files
```bash
# Copy all reference files directly
cp -r .attic/architect-skills-archive-*/skill-architect/references/* \
      .claude/skills/knowledge-skills/references/
cp -r .attic/architect-skills-archive-*/mcp-architect/references/* \
      .claude/skills/knowledge-mcp/references/
cp -r .attic/architect-skills-archive-*/hooks-architect/references/* \
      .claude/skills/knowledge-hooks/references/
cp -r .attic/architect-skills-archive-*/subagents-architect/references/* \
      .claude/skills/knowledge-subagents/references/
```

### Step 2: Create New SKILL.md Files
Extract knowledge from archived SKILL.md files, removing:
- Workflow detection logic
- Execution instructions
- Process steps
- Multi-workflow engines

Keep only:
- Core concepts and definitions
- Quick reference tables
- Reference file links
- Usage patterns (conceptual, not execution)

### Step 3: Verify Knowledge Purity
Ensure no execution logic remains:
- No "workflow", "execute", "create file" instructions
- No step-by-step processes
- No tool invocation guidance
- Pure reference content only

---

## Completion Criteria

- ✅ All 29 reference files copied to knowledge skills
- ✅ All 4 SKILL.md files created with <500 lines
- ✅ No execution logic in knowledge skills
- ✅ All reference files properly linked from SKILL.md
- ✅ Knowledge-only content verified
