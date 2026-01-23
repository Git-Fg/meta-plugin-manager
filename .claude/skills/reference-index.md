# Cross-Skill Reference Index

Comprehensive index of all reference files across the skills ecosystem with cross-references for related content.

## Quality & Scoring Frameworks

| Skill | Reference | Focus | Dimensions |
|-------|-----------|-------|------------|
| **claude-md-manager** | [quality-framework.md](claude-md-manager/references/quality-framework.md) | CLAUDE.md files | 7 dimensions (0-100) |
| **skills-architect** | [quality-framework.md](skills-architect/references/quality-framework.md) | Skill quality | 11 dimensions (0-160) |
| **toolkit-architect** | [scoring-breakdown.md](toolkit-architect/references/scoring-breakdown.md) | Component scoring | Multi-dimensional |

**Related**: All frameworks score quality but for different domains. Use the most specific one for your use case.

## Security Patterns

| Skill | Reference | Focus | Use Case |
|-------|-----------|-------|----------|
| **hooks-architect** | [security-patterns.md](hooks-architect/references/security-patterns.md) | Guardrails | Project protection |
| **hooks-knowledge** | [security-patterns.md](hooks-knowledge/references/security-patterns.md) | Hook security | Event validation |

**Cross-Reference**: Both cover hook security from different angles (architect vs knowledge).

## Delta Standard & Context Engineering

| Skill | Reference | Focus | Application |
|-------|-----------|-------|-------------|
| **claude-md-manager** | [delta-standard.md](claude-md-manager/references/delta-standard.md) | Memory filtering | CLAUDE.md content |

**Concept**: Delta Standard = Expert Knowledge - What Claude Already Knows

## Workflow Patterns

### Multi-Workflow Detection

| Skill | Workflows | Detection |
|-------|-----------|-----------|
| **hooks-architect** | INIT → SECURE → AUDIT → REMEDIATE | Security context |
| **subagents-architect** | DETECT → CREATE → VALIDATE → OPTIMIZE | Configuration context |
| **mcp-architect** | DISCOVER → INTEGRATE → VALIDATE → OPTIMIZE | Protocol context |
| **skills-architect** | ASSESS → CREATE → EVALUATE → ENHANCE | Quality context |

**Pattern**: All architect skills use 4-workflow detection with trust-in-AI reasoning.

## Compliance & Validation

| Skill | Reference | Focus | Score |
|-------|-----------|-------|-------|
| **hooks-architect** | [compliance-framework.md](hooks-architect/references/compliance-framework.md) | Hook compliance | 5 dimensions |
| **mcp-architect** | [compliance-framework.md](mcp-architect/references/compliance-framework.md) | MCP protocol | 5 dimensions |
| **subagents-architect** | [validation-framework.md](subagents-architect/references/validation-framework.md) | Configuration | 6 dimensions |

## Architecture Patterns

### Layer Selection

| Reference | Purpose | Use When |
|-----------|---------|----------|
| [layer-selection.md](meta-architect-claudecode/references/layer-selection.md) | Choose between CLAUDE.md, skills, subagents, hooks, MCP | Unclear what layer to use |
| [orchestration-patterns.md](meta-architect-claudecode/references/orchestration-patterns.md) | Linear, Hub-Spoke, Worker patterns | Need to orchestrate multiple components |

### Progressive Disclosure

| Skill | Reference | Focus |
|-------|-----------|-------|
| **skills-architect** | [progressive-disclosure.md](skills-architect/references/progressive-disclosure.md) | Tier 1/2/3 structure |
| **meta-architect-claudecode** | [common.md](meta-architect-claudecode/references/common.md) | Core principles |

## Implementation Guides

### Hooks

| Skill | Reference | Focus |
|-------|-----------|-------|
| **hooks-knowledge** | [implementation-patterns.md](hooks-knowledge/references/implementation-patterns.md) | Detailed patterns |
| **hooks-knowledge** | [examples.md](hooks-knowledge/references/examples.md) | Step-by-step |
| **hooks-architect** | [script-templates.md](hooks-architect/references/script-templates.md) | Copy-paste scripts |

### MCP

| Skill | Reference | Focus |
|-------|-----------|-------|
| **mcp-knowledge** | [tools.md](mcp-knowledge/references/tools.md) | Tool development |
| **mcp-knowledge** | [resources.md](mcp-knowledge/references/resources.md) | Resource patterns |
| **mcp-architect** | [component-templates.md](mcp-architect/references/component-templates.md) | Server templates |

### Skills

| Skill | Reference | Focus |
|-------|-----------|-------|
| **skills-knowledge** | [creation.md](skills-knowledge/references/creation.md) | Complete building guide |
| **skills-knowledge** | [patterns.md](skills-knowledge/references/patterns.md) | Design patterns |
| **skills-architect** | [extraction-methods.md](skills-architect/references/extraction-methods.md) | Golden path |

### Subagents

| Skill | Reference | Focus |
|-------|-----------|-------|
| **subagents-knowledge** | [when-to-use.md](subagents-knowledge/references/when-to-use.md) | Decision guide |
| **subagents-knowledge** | [coordination.md](subagents-knowledge/references/coordination.md) | Multi-agent patterns |
| **subagents-architect** | [configuration-guide.md](subagents-architect/references/configuration-guide.md) | Valid fields |

## Common Concepts Across Skills

### Autonomy Design

**Present in**: skills-architect, subagents-knowledge, meta-architect-claudecode
- 80-95% completion without questions
- Trust-in-AI reasoning
- Context detection

### Completion Markers

**Used in**: All architect skills
- Clear workflow verification
- Standardized output format
- Win condition patterns

### Progressive Disclosure

**Present in**: All skills
- Tier 1: Metadata (~100 tokens)
- Tier 2: SKILL.md (<500 lines)
- Tier 3: References (on-demand)

## Finding Related Content

### By Topic

**Security**: hooks-architect/security-patterns → hooks-knowledge/security-patterns
**Quality**: skills-architect/quality-framework → toolkit-architect/scoring-breakdown
**Delta Standard**: claude-md-manager/delta-standard
**Workflows**: meta-architect-claudecode/orchestration-patterns → [all architect skills]

### By Pattern

**Multi-Workflow**: All architect skills (hooks, subagents, mcp, skills)
**Templates**: hooks-architect/script-templates → mcp-architect/component-templates
**Examples**: toolkit-architect/real-world-examples → skills-knowledge/patterns

## Navigation Tips

1. **Start with architect skills** for workflow detection
2. **Use knowledge skills** for implementation details
3. **Check reference index** for cross-skill concepts
4. **Follow progressive disclosure** (Tier 1 → 2 → 3)

## Maintenance Note

This index should be updated when new reference files are added or existing ones are modified. It serves as the master catalog of all knowledge in the skills ecosystem.
