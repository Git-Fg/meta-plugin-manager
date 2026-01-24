# Security Patterns and Model Selection Analysis

## Security Patterns (from hooks-architect)

### Security Framework
**Source**: `hooks-architect/SKILL.md:258-274`

```
Scoring system (0-100 points):

| Dimension | Points | Focus |
|-----------|--------|-------|
| 1. Security Coverage | 25 | Hooks protect critical operations |
| 2. Validation Patterns | 20 | Proper input validation and sanitization |
| 3. Exit Code Usage | 15 | Correct exit codes (0=success, 2=blocking) |
| 4. Script Quality | 20 | Well-written, maintainable scripts |
| 5. Configuration Hierarchy | 20 | Modern configuration approach |

Quality Thresholds:
- A (90-100): Exemplary security posture
- B (75-89): Good security with minor gaps
- C (60-74): Adequate security, needs improvement
- D (40-59): Poor security, significant issues
- F (0-39): Failing security, critical vulnerabilities
```

**Four Security Workflows**:
1. **INIT**: Fresh project setup
2. **SECURE**: Enhance existing security
3. **AUDIT**: Security assessment
4. **REMEDIATE**: Fix security issues

**Security Keywords Detection**:
- Conversation: "security", "protect", "guard", "validate"
- Project: .env files, cloud configs, CI/CD configs

**COMPLIANCE**: ✅ Security patterns well-implemented

## Model Selection Patterns

### hooks-architect Model Selection
**Source**: `hooks-architect/SKILL.md:47-72`

```
Model Selection for Security Workflows:

Simple Security Tasks (haiku):
- Individual hook validation
- Basic script syntax checks
- Single hook testing
- Quick security scans
- Routine validation checks

Default Security Tasks (sonnet):
- Security audit workflows
- Standard compliance validation
- Typical remediation projects
- Multi-hook validation
- Balanced performance for most security work

Complex Security Tasks (opus):
- Complex security architecture design
- Multi-phase remediation planning
- Critical vulnerability analysis
- Cross-component dependency resolution
- High-stakes security decisions

Security Criticality: Escalate to opus for critical security decisions, use haiku for routine validation.
```

### mcp-architect Model Selection
**Source**: `mcp-architect/SKILL.md:54-82`

```
Model Selection for MCP Workflows:

Simple MCP Tasks (haiku):
- Single server validation
- Basic transport configuration checks
- Simple tool schema validation
- Quick compliance scans
- Cost-sensitive validation

Default MCP Tasks (sonnet):
- Multi-server setup and validation
- Standard compliance validation
- Typical integration workflows
- Protocol adherence checking
- Balanced performance for most MCP work

Complex MCP Tasks (opus):
- Multi-server architecture design
- Complex protocol compliance remediation
- Multi-phase optimization workflows
- Cross-server dependency management
- Critical security decisions

Cost Optimization: Use haiku for quick validation scans, escalate to opus only for complex architecture decisions.
```

## Model Selection Knowledge Elements

**Pattern 1: Three-Tier Model Selection**
- haiku: Simple, routine, cost-sensitive tasks
- sonnet: Default for most workflows (balanced)
- opus: Complex, critical, architecture decisions

**Pattern 2: Cost Optimization**
- Use haiku for validation scans
- Use sonnet for standard workflows
- Use opus only when necessary

**Pattern 3: Security Criticality**
- Escalate to opus for critical decisions
- Use haiku for routine validation

**Pattern 4: Task Categorization**
- Individual validations → haiku
- Multi-component workflows → sonnet
- Architecture design → opus

## Compliance Assessment

| Component | Model Selection | Cost Optimization | Compliance |
|-----------|-----------------|-------------------|------------|
| hooks-architect | ✅ 3-tier | ✅ Haiku for routine | ✅ FULL |
| mcp-architect | ✅ 3-tier | ✅ Haiku for validation | ✅ FULL |

## Summary

**Security Patterns**: 5 extracted, 100% compliance
**Model Selection Patterns**: 4 extracted, 100% compliance
**Violations**: 0

Security and model selection knowledge is well-implemented. Both hooks-architect and mcp-architect follow 3-tier model selection with cost optimization. No violations found.
