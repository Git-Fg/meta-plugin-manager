# Review Modes Data Library

## Mode Reference

Four review modes available for plugin assessment:

| Mode | Duration | Use Case |
|------|----------|----------|
| **Quick** | 2-3 min | Initial assessment, screening |
| **Standard** | 5-10 min | Complete quality check |
| **Detailed** | 10-15 min | Pre-refinement planning |
| **Component** | Variable | Targeted improvements |

## Quick Mode

**Purpose**: Fast initial assessment

**Scope**: Major issues only
- Plugin manifest validation
- Directory structure basics
- Architecture violations
- Critical security issues

**Output format**:
```
Score: X.X/10
Status: [Fair/Good/Very Good]
Major Issues: [List]
Quick Actions: [List]
```

## Standard Mode

**Purpose**: Comprehensive assessment

**Scope**: All components
- Architecture analysis
- Component review (skills, commands, agents, hooks)
- Standards compliance
- Progressive disclosure check

**Output format**:
```
Score: X.X/10
Grade: [A/B/C/D]
Detailed Findings: [By component]
Recommendations: [Priority ordered]
```

## Detailed Mode

**Purpose**: In-depth analysis

**Scope**: Code-level examination
- Pattern analysis
- Performance optimization
- Security audit
- Technical debt assessment

**Output format**:
```
Score: X.X/10
Grade: [A/B/C/D]
Technical Analysis: [Skill-by-skill]
Optimization Opportunities: [List]
Best Practices: [Recommendations]
```

## Component Mode

**Purpose**: Focused review

**Types**: skills, commands, agents, hooks, or combined

**Scope**: Selected component types
- Type-specific validation
- Integration quality
- Orchestration effectiveness

**Output format**:
```
Component Review: [Type]
Skills Found: X
Analyzed: X
Issues: X
Recommendations: X
Skill-by-Skill Analysis: [Details]
Priority Actions: [By priority]
```

## Decision Guide

**Quick** → Initial scan, time-constrained
**Standard** → Regular quality check, before refinement
**Detailed** → Planning, optimization, expert review
**Component** → Targeted improvements, specific issues

## Workflow Pattern

1. Quick Review → Identify if detailed work needed
2. Standard Review → Full assessment with recommendations
3. Component Review → Focus on problem areas
4. Detailed Review → Pre-refinement planning
