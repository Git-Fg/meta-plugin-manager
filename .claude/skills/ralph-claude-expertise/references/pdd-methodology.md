# Prompt-Driven Development (PDD)

Transform rough ideas into detailed designs with implementation plans.

## Overview

PDD is a structured methodology for:
1. **Clarifying** rough ideas through guided questions
2. **Researching** relevant technologies and patterns
3. **Designing** comprehensive solutions
4. **Planning** incremental implementation steps

## Quick Start

```bash
ralph plan              # Start PDD session
```

## Directory Structure

```
{project_dir}/
├── rough-idea.md           # Original concept
├── idea-honing.md          # Q&A requirements clarification
├── research/
│   ├── existing-code.md
│   ├── technologies.md
│   └── external-solutions.md
├── design/
│   └── detailed-design.md
├── implementation/
│   └── plan.md             # Checklist + steps
└── summary.md
```

## Workflow Phases

### Phase 1: Requirements Clarification

Ask **ONE question at a time**, wait for answer, record in `idea-honing.md`:

```markdown
## Question 1
How should users authenticate?

### Answer
OAuth2 with Google and email/password fallback.

---

## Question 2
What data needs to persist across sessions?

### Answer
User preferences, saved templates, and recent documents.
```

**Key questions to cover:**
- Core functionality and user goals
- Edge cases and error scenarios
- Technical constraints and preferences
- Success criteria and metrics
- Integration requirements

### Phase 2: Research

Document findings in `research/` directory:

| File | Content |
|------|---------|
| `existing-code.md` | Relevant patterns in current codebase |
| `technologies.md` | Library/framework options with pros/cons |
| `external-solutions.md` | How others solved similar problems |

Include:
- Mermaid diagrams for architectures
- Links to sources
- Code snippets from reference implementations

### Phase 3: Detailed Design

Create `design/detailed-design.md` with these sections:

```markdown
# [Feature Name] Design

## Overview
[Brief description]

## Detailed Requirements
[Consolidated from idea-honing.md]

## Architecture Overview
[Mermaid diagram]

## Components and Interfaces
[Each component with responsibilities]

## Data Models
[Schemas and relationships]

## Error Handling
[Error types and recovery strategies]

## Testing Strategy
[Unit, integration, E2E approach]

## Appendices
- Technology Choices
- Research Findings
- Alternative Approaches Considered
```

### Phase 4: Implementation Plan

Create `implementation/plan.md`:

```markdown
# Implementation Plan

## Checklist
- [ ] Step 1: Core data models
- [ ] Step 2: Validation layer
- [ ] Step 3: API endpoints
- [ ] Step 4: Frontend integration
- [ ] Step 5: Error handling
- [ ] Step 6: Tests and documentation

---

## Step 1: Core Data Models

**Objective:** Create foundational data structures

**Guidance:**
- Follow existing model patterns in `src/models/`
- Include validation annotations
- Add migration script

**Tests:**
- Model serialization/deserialization
- Constraint validation

**Demo:** Working models that can create, validate, and persist data.

---

## Step 2: Validation Layer
...
```

## Integration with Ralph

### Generate PROMPT.md

After PDD completes, create a minimal PROMPT.md:

```markdown
## Objective
Implement [feature] as designed in {project_dir}/design/detailed-design.md

## Key Requirements
- [Bullet 1]
- [Bullet 2]
- [Bullet 3]

## Acceptance Criteria
- All steps in implementation/plan.md completed
- Tests pass
- Documentation updated

## Reference
Read: {project_dir}/design/detailed-design.md
```

### Run Implementation

```bash
ralph run -P PROMPT.md
```

## Iteration Checkpoints

PDD is iterative. At each phase transition:

1. **Summarize** current state
2. **Ask** user if they want to:
   - Proceed to next phase
   - Return to previous phase
   - Conduct more research
3. **Wait** for explicit confirmation

Never auto-proceed without user direction.

## Best Practices

1. **One question at a time** - Wait for complete answers
2. **Record everything** - All decisions go in idea-honing.md
3. **Research before design** - Don't assume, verify
4. **Incremental steps** - Each step should be demoable
5. **Keep PROMPT.md minimal** - Ralph reads the design
