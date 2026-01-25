---
name: context-aware-analyzer
description: "Dynamic context analyzer for project-specific insights. Use when analyzing codebases, configurations, or systems with specific context parameters."
user-invocable: true
context: fork
---

# Context-Aware Analyzer

## Purpose
Analyze projects, codebases, or systems with dynamic context injection for tailored insights and recommendations.

## Context Parameters
The analyzer receives context via arguments in the format:
```
key1=value1 key2=value2 project_type=javascript language=typescript
```

## Autonomous Workflow

1. **Parse Context**: Extract all parameters from arguments
2. **Scan Project**: Identify project structure, files, and configuration
3. **Context-Aware Analysis**: Apply analysis patterns based on context
4. **Tailored Recommendations**: Generate insights specific to the context
5. **Format Output**: Structured findings with context-specific guidance

## Analysis Patterns by Context

### Web Development Context
- Frontend: React, Vue, Angular patterns
- Backend: Node.js, Express, API structures
- Testing: Jest, Cypress, testing frameworks
- Build: Webpack, Vite, bundler configuration

### Data Science Context
- Analysis: Pandas, NumPy, statistical patterns
- ML: Scikit-learn, TensorFlow, model structures
- Visualization: Matplotlib, Plotly, data presentation
- Notebooks: Jupyter, interactive analysis

### DevOps Context
- Infrastructure: Docker, Kubernetes, cloud configs
- CI/CD: GitHub Actions, GitLab CI, pipeline patterns
- Monitoring: Logging, metrics, observability
- Security: Secrets, access control, compliance

### General Purpose Context
- Architecture: File organization, module structure
- Dependencies: Package management, version control
- Documentation: README, API docs, code comments
- Code Quality: Linting, formatting, best practices

## Success Criteria
- Context successfully parsed from arguments
- Analysis tailored to specified context parameters
- Recommendations reflect context-specific best practices
- Findings organized by relevance and priority

## Completion Marker
```
## CONTEXT_AWARE_ANALYZER_COMPLETE
```
