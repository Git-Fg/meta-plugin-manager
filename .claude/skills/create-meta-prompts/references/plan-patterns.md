## Overview

Prompt patterns for creating approaches, roadmaps, and strategies that will be consumed by subsequent prompts.

<prompt_template>
```xml

## Objective

Create a {plan type} for {topic}.

Purpose: {What decision/implementation this enables}
Input: {Research or context being used}
Output: {topic}-plan.md with actionable phases/steps

## Context

Research findings: @.prompts/{num}-{topic}-research/{topic}-research.md
{Additional context files}

<planning_requirements>
{What the plan needs to address}
{Constraints to work within}
{Success criteria for the planned outcome}

<output_structure>
Save to: `.prompts/{num}-{topic}-plan/{topic}-plan.md`

Structure the plan using this XML format:

```xml
<plan>
  
## Summary

{One paragraph overview of the approach}
  

  <phases>
    
#### Example 1

## Objective

{What this phase accomplishes}
      
## Tasks

<task priority="high">{Specific actionable task}
        <task priority="medium">{Another task}
      
      <deliverables>
        <deliverable>{What's produced}
      
      
## Dependencies

{What must exist before this phase}
    
    <!-- Additional phases -->
  

  <metadata>
    
### {high|medium|low}

{Why this confidence level}
    
    
## Dependencies

{External dependencies needed}
    
    <open_questions>
      {Uncertainties that may affect execution}
    
    
## Assumptions

{What was assumed in creating this plan}
    
  

```

<summary_requirements>
Create `.prompts/{num}-{topic}-plan/SUMMARY.md`

Load template: [summary-template.md](summary-template.md)

For plans, emphasize phase breakdown with objectives and assumptions needing validation. Next step typically: Execute first phase.

## Success Criteria

- Plan addresses all requirements
- Phases are sequential and logical
- Tasks are specific and actionable
- Metadata captures uncertainties
- SUMMARY.md created with phase overview
- Ready for implementation prompts to consume

```

<key_principles>

<reference_research>
Plans should build on research findings:
```xml

## Context

Research findings: @.prompts/001-auth-research/auth-research.md

Key findings to incorporate:
- Recommended approach from research
- Constraints identified
- Best practices to follow

```

<prompt_sized_phases>
Each phase should be executable by a single prompt:
```xml

#### Example 1

## Objective

Create base auth structure and types
  
## Tasks

<task>Create auth module directory
    <task>Define TypeScript types for tokens
    <task>Set up test infrastructure
  

```

<execution_hints>
Help the next Claude understand how to proceed:
```xml

#### Example 2

<execution_notes>
    This phase modifies files from phase 1.
    Reference the types created in phase 1.
    Run tests after each major change.
  

```

<plan_types>

<implementation_roadmap>
For breaking down how to build something:

```xml

## Objective

Create implementation roadmap for user authentication system.

Purpose: Guide phased implementation with clear milestones
Input: Authentication research findings
Output: auth-plan.md with 4-5 implementation phases

## Context

Research: @.prompts/001-auth-research/auth-research.md

<planning_requirements>
- Break into independently testable phases
- Each phase builds on previous
- Include testing at each phase
- Consider rollback points

```

<decision_framework>
For choosing between options:

```xml

## Objective

Create decision framework for selecting database technology.

Purpose: Make informed choice between PostgreSQL, MongoDB, and DynamoDB
Input: Database research findings
Output: database-plan.md with criteria, analysis, recommendation

<output_structure>
Structure as decision framework:

```xml
<decision_framework>
  
## Options

### PostgreSQL

## Pros

{List}
      
## Cons

{List}
      <fit_score criteria="scalability">8/10
      <fit_score criteria="flexibility">6/10
    
    <!-- Other options -->
  

  <recommendation>
    <choice>{Selected option}
    
## Rationale

{Why this choice}
    <risks>{What could go wrong}
    <mitigations>{How to address risks}
  

  <metadata>
    
### high

Clear winner based on requirements
    
    
## Assumptions

- Expected data volume: 10M records
      - Team has SQL experience
    
  

```

```

<process_definition>
For defining workflows or methodologies:

```xml

## Objective

Create deployment process for production releases.

Purpose: Standardize safe, repeatable deployments
Input: Current infrastructure research
Output: deployment-plan.md with step-by-step process

<output_structure>
Structure as process:

```xml

## Process

## Overview

{High-level flow}

  <steps>
    
#### Example 1

<actions>
        <action>Run full test suite
        <action>Create database backup
        <action>Notify team in #deployments
      
      <checklist>
        <item>Tests passing
        <item>Backup verified
        <item>Team notified
      
      <rollback>N/A - no changes yet
    
    <!-- Additional steps -->
  

  <metadata>
    
## Dependencies

- CI/CD pipeline configured
      - Database backup system
      - Slack webhook for notifications
    
    <open_questions>
      - Blue-green vs rolling deployment?
      - Automated rollback triggers?
    
  

```

```

## Metadata Guidelines

Load: [metadata-guidelines.md](metadata-guidelines.md)