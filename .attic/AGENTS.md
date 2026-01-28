# AGENTS.md: The Seed System

<meta_control>
<project>The Seed System v3</project>
<role>Meta-toolkit for Claude Code configuration</role>
<invariant>Every component MUST work with zero .claude/rules dependencies</invariant>
</meta_control>

Meta-toolkit for Claude Code with dual-role architecture: **health maintenance** + **portable component factory**.

**For philosophical foundation**, see the project rules directory.

---

## Core Philosophy

<pattern name="dual_role">
  <health_maintenance>
    - Maintains consistency across rules, skills, documentation
    - Target: 80-95% autonomy (0-5 questions per session)
  </health_maintenance>
  <component_factory>
    - Builds portable, self-sufficient components
    - Zero external dependencies required
    - Bundles condensed philosophy in outputs
  </component_factory>
</pattern>

## The Portability Invariant

<critical_constraint>
MANDATORY: Every component MUST be self-contained and work in a project with ZERO .claude/rules.
</critical_constraint>

## Dual-Layer Architecture

<layer_a>
**Behavioral Rules** - Session-only, not embedded in components
</layer_a>

<layer_b>
**Construction Standards** - Embedded in components as "genetic code"
</layer_b>

**Key Insight**: The agent's "soul" (Layer A) teaches it to embed its "brain" (Layer B) into every component it builds.

---

## Essential References

| For...                  | Read...                                         |
| ----------------------- | ----------------------------------------------- |
| Core principles         | .claude/rules/principles.md                     |
| Implementation patterns | .claude/rules/patterns.md                       |
| Anti-patterns           | .claude/rules/anti-patterns.md                  |
| Voice & freedom         | .claude/rules/voice-and-freedom.md              |
| Question strategies     | .claude/rules/askuserquestion-best-practices.md |

## Quick Navigation

<decision_tree>
**Health Maintenance** (current session):

- Update rules → Check .claude/rules/ for consistency
- Audit quality → Use meta-critic skill
- Fix autonomy issues → Review askuserquestion-best-practices.md

**Component Factory** (building offspring):

- Create skill → skill-development
- Add command → command-development
- Create agent → agent-development
- Add hook → hook-development
- Add MCP → mcp-development
  </decision_tree>

---

## Two-Stage Review Process

<two_stage_review>
<stage_1>
<name>Spec Review</name>
<trigger>Before code implementation</trigger>
<checks> - Requirements satisfied - Edge cases considered - Interface contracts defined - Success criteria met
</checks>
</stage_1>
<stage_2>
<name>Quality Review</name>
<trigger>After spec compliance</trigger>
<checks> - Code quality gates pass - Tests coverage adequate - Documentation updated - Portability verified
</checks>
</stage_2>
</two_stage_review>

<critical_constraint>
MANDATORY: Complete Spec Review BEFORE Quality Review
</critical_constraint>

## Session Commands

- `/reflect` - Review behavior, identify improvement opportunities
- `/handoff` - Create session handoff document
- `/whats-next` - Analyze conversation for continuation
- `/plan` - Enter plan mode for complex tasks

---

## Plan Mode Workflow (CRITICAL)

**MANDATORY: Always use ExitPlanMode before proceeding to implementation.**

1. **Phase 1** - Understand requirements
2. **Phase 2** - Design approach
3. **Phase 3** - Get user approval
4. **Phase 4** - Execute plan
5. **Phase 5** - Verify and complete

---

<critical_constraint>
MANDATORY: No completion claims without fresh verification evidence
</critical_constraint>

<critical_constraint>
MANDATORY: Use ExitPlanMode before implementation
</critical_constraint>

<critical_constraint>
MANDATORY: Every component MUST work with zero .claude/rules dependencies
</critical_constraint>
