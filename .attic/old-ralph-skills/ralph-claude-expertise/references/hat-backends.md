# Per-Hat Backend Configuration

Different hats can use different backends for specialized tasks. This enables multi-model orchestration within a single Ralph workflow.

---

## Overview

By default, all hats use the backend specified in `cli.backend`. You can override this per-hat to:
- Use different models for different tasks
- Leverage specialized backends (Kiro with MCP tools)
- Optimize costs (cheaper models for simple tasks)
- Get fresh perspectives (different model for review)

---

## Backend Types

### Named Backend

Use a named backend from the supported list.

```yaml
hats:
  builder:
    name: "Builder"
    description: "Implements code using Claude"
    triggers: ["build.task"]
    publishes: ["build.done"]
    backend: "claude"  # Uses default Claude backend
```

### Kiro Agent

Use Kiro with a specific agent configuration (MCP tools).

```yaml
hats:
  aws_deployment:
    name: "AWS Deployment"
    description: "Deploys to AWS using Kiro with MCP tools"
    triggers: ["deploy.aws"]
    publishes: ["deploy.complete"]
    backend:
      type: "kiro"
      agent: "aws-deployer"  # Kiro agent with AWS MCP tools
```

### Custom Backend

Use a custom command as the backend.

```yaml
hats:
  custom_tool:
    name: "Custom Tool"
    description: "Runs custom deployment script"
    triggers: ["deploy.custom"]
    publishes: ["deploy.done"]
    backend:
      command: "/path/to/script.sh"
      args: ["--arg1", "--arg2"]
```

---

## Supported Backends

| Backend | Description | Best For |
|---------|-------------|----------|
| `claude` | Anthropic Claude (default) | General purpose, complex reasoning |
| `kiro` | Kiro with MCP tools | AWS/cloud tasks with tool support |
| `gemini` | Google Gemini | Fresh perspective, cost optimization |
| `codex` | OpenAI Codex | Legacy compatibility |
| `amp` | AMP backend | Specific use cases |
| `copilot` | GitHub Copilot | Alternative model |
| `opencode` | OpenCode backend | Open source focus |
| `custom` | Custom command | Internal tools, specialized workflows |

---

## Configuration Examples

### Default Backend (All Hats Use Same)

```yaml
cli:
  backend: "claude"  # Default for all hats

hats:
  planner:
    name: "Planner"
    triggers: ["task.start"]
    publishes: ["plan.ready"]
    # No backend override - uses "claude"

  builder:
    name: "Builder"
    triggers: ["plan.ready"]
    publishes: ["build.done"]
    # No backend override - uses "claude"

  reviewer:
    name: "Reviewer"
    triggers: ["build.done"]
    publishes: ["review.approved"]
    # No backend override - uses "claude"
```

### Mixed Backends (Different Models)

```yaml
cli:
  backend: "claude"  # Default

hats:
  builder:
    name: "Builder"
    description: "Implements code with Claude"
    triggers: ["build.task"]
    publishes: ["build.done"]
    backend: "claude"  # Explicit, same as default

  reviewer:
    name: "Reviewer"
    description: "Reviews with Gemini for fresh perspective"
    triggers: ["build.done"]
    publishes: ["review.approved"]
    backend: "gemini"  # Different model for review

  summarizer:
    name: "Summarizer"
    description: "Summarizes with faster model"
    triggers: ["review.approved"]
    publishes: ["summary.done"]
    backend: "haiku"  # Faster/cheaper for simple tasks
```

### Kiro with MCP Tools

```yaml
cli:
  backend: "claude"  # Default

hats:
  developer:
    name: "Developer"
    description: "Implements features"
    triggers: ["feature.start"]
    publishes: ["feature.built"]
    backend: "claude"

  aws_deployer:
    name: "AWS Deployer"
    description: "Deploys to AWS using Kiro with AWS MCP tools"
    triggers: ["deploy.aws"]
    publishes: ["deploy.complete"]
    backend:
      type: "kiro"
      agent: "aws-deployer"  # Kiro agent configured with AWS MCP tools

  cloud_validator:
    name: "Cloud Validator"
    description: "Validates cloud resources"
    triggers: ["deploy.complete"]
    publishes: ["validation.done"]
    backend:
      type: "kiro"
      agent: "cloud-validator"  # Kiro agent with cloud validation tools
```

### Cost Optimization

```yaml
cli:
  backend: "claude"  # Default for complex tasks

hats:
  planner:
    name: "Planner"
    description: "Creates detailed plan"
    triggers: ["task.start"]
    publishes: ["plan.ready"]
    backend: "claude"  # Complex reasoning needs Claude

  implementer:
    name: "Implementer"
    description: "Implements simple code changes"
    triggers: ["plan.ready"]
    publishes: ["code.done"]
    backend: "haiku"  # Faster/cheaper for simple implementation

  reviewer:
    name: "Reviewer"
    description: "Reviews code changes"
    triggers: ["code.done"]
    publishes: ["review.approved"]
    backend: "gemini"  # Cheaper alternative for review

  summarizer:
    name: "Summarizer"
    description: "Creates summary"
    triggers: ["review.approved"]
    publishes: ["summary.done"]
    backend: "haiku"  # Fastest for simple summarization
```

---

## When to Use Different Backends

| Scenario | Recommended Backend | Rationale |
|----------|---------------------|-----------|
| Complex coding | Claude (default) | Best reasoning and code generation |
| AWS/cloud tasks | Kiro with agent | MCP tools provide cloud access |
| Code review | Different model (Gemini) | Fresh perspective, catches different issues |
| Simple summarization | Haiku | Faster, cheaper for simple tasks |
| Cost optimization | Mix of models | Reserve Claude for complex tasks |
| Internal tools | Custom backend | Integrate with existing workflows |
| Legacy compatibility | Codex | Match existing behavior |

---

## Backend Configuration Best Practices

### 1. Use Default for Most Hats

```yaml
# Good: Most hats use default
cli:
  backend: "claude"

hats:
  planner:
    triggers: ["task.start"]
    publishes: ["plan.ready"]
    # Uses default "claude"

  builder:
    triggers: ["plan.ready"]
    publishes: ["build.done"]
    # Uses default "claude"

  reviewer:
    triggers: ["build.done"]
    publishes: ["review.approved"]
    backend: "gemini"  # Only reviewer differs
```

### 2. Document Backend Choice

```yaml
hats:
  reviewer:
    name: "Reviewer"
    description: "Reviews with Gemini for fresh perspective and cost optimization"
    triggers: ["build.done"]
    publishes: ["review.approved"]
    backend: "gemini"  # Fresh perspective, cheaper than Claude
```

### 3. Test Backend Configuration

```bash
# Test with single iteration
ralph run --iterations 1 --verbose

# Verify each hat uses correct backend
ralph run --dry-run
```

---

## Backend-Specific Considerations

### Claude

- Best for: Complex reasoning, code generation, architectural decisions
- Pros: Highest quality, best at following instructions
- Cons: More expensive than alternatives
- Use when: Quality matters more than cost

### Gemini

- Best for: Code review, fresh perspectives, cost optimization
- Pros: Different model catches different issues, cheaper
- Cons: May follow instructions differently
- Use when: Want alternative perspective or cost savings

### Haiku

- Best for: Simple tasks, summarization, classification
- Pros: Fastest, cheapest
- Cons: Less capable for complex reasoning
- Use when: Task is straightforward and speed matters

### Kiro

- Best for: AWS/cloud tasks with MCP tools
- Pros: Direct access to cloud resources via MCP
- Cons: Requires Kiro setup and agent configuration
- Use when: Need to interact with external services

### Custom

- Best for: Internal tools, specialized workflows
- Pros: Full control over behavior
- Cons: Requires maintenance and debugging
- Use when: Existing tool or specialized requirement

---

## Complete Example

```yaml
# ralph.yml

cli:
  backend: "claude"

event_loop:
  completion_promise: "LOOP_COMPLETE"
  max_iterations: 50
  starting_event: "workflow.start"

hats:
  # Phase 1: Planning (Claude - complex reasoning)
  planner:
    name: "Planner"
    description: "Creates detailed implementation plan"
    triggers: ["workflow.start"]
    publishes: ["plan.ready"]
    backend: "claude"

  # Phase 2: Implementation (Haiku - cost optimization)
  implementer:
    name: "Implementer"
    description: "Implements straightforward code changes"
    triggers: ["plan.ready"]
    publishes: ["code.done"]
    backend: "haiku"

  # Phase 3: Review (Gemini - fresh perspective)
  reviewer:
    name: "Reviewer"
    description: "Reviews code with different model"
    triggers: ["code.done"]
    publishes: ["review.approved"]
    backend: "gemini"

  # Phase 4: Deployment (Kiro - AWS MCP tools)
  deployer:
    name: "AWS Deployer"
    description: "Deploys to AWS using MCP tools"
    triggers: ["review.approved"]
    publishes: ["deploy.complete"]
    backend:
      type: "kiro"
      agent: "aws-deployer"

  # Phase 5: Validation (Custom - internal tool)
  validator:
    name: "Validator"
    description: "Validates deployment with internal tool"
    triggers: ["deploy.complete"]
    publishes: ["validation.done", "LOOP_COMPLETE"]
    backend:
      command: "/opt/scripts/validate-deployment.sh"
      args: ["--environment", "production"]
```

---

## Troubleshooting

### Backend Not Found

**Error**: `Unknown backend: xyz`

**Solution**: Check backend name spelling. Use supported backends only.

```yaml
# Bad
backend: "claud"  # Typo

# Good
backend: "claude"
```

### Kiro Agent Not Found

**Error**: `Kiro agent not found: xyz`

**Solution**: Verify Kiro agent exists and is configured.

```bash
# List available Kiro agents
kiro --list-agents
```

### Custom Backend Fails

**Error**: Custom backend command fails

**Solution**: Test command independently first.

```bash
# Test command
/path/to/script.sh --arg1 --arg2

# Check permissions
ls -la /path/to/script.sh
```

---

## See Also

- `references/configuration.md` - Complete configuration schema
- `references/coordination-patterns.md` - Multi-hat workflow patterns
- `references/claude-automation.md` - Programmatic Claude execution
