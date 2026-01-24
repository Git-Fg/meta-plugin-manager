# Hook Implementation Concepts

Core concepts for implementing hooks in your local project. Trust AI to make intelligent decisions based on these principles.

## Core Philosophy: Trust AI Intelligence

**This reference teaches concepts, not prescriptive templates:**

1. **Project-First Approach**: Always create hooks in your project's `.claude/` directory
2. **Trust AI Reasoning**: Provide concepts, AI makes intelligent implementation decisions
3. **Autonomous Execution**: Skills work without user interaction
4. **Minimal Prescriptiveness**: Focus on principles, not rigid patterns
5. **Clean Architecture**: Remove deprecated patterns and legacy knowledge

## Fundamental Concepts

### Hook Configuration Structure

```json
{
  "hooks": {
    "EventName": [{
      "matcher": "ToolPattern",
      "hooks": [{
        "type": "command",
        "command": "your-script.sh"
      }]
    }]
  }
}
```

**Key Elements**:
- **EventName**: Which hook event to respond to
- **ToolPattern**: Which tools to match (use patterns, AI handles specificity)
- **Command**: Script to execute (use CLAUDE_PROJECT_DIR for portability)

### Event Selection Concept

**Trust AI to choose appropriate events based on use case**:

**For Validation**:
- PreToolUse: Validate before operations
- AI decides: Which specific tools to validate

**For Automation**:
- PostToolUse: Process after operations
- AI decides: What automation is appropriate

**For Lifecycle**:
- SessionStart/End: Session management
- AI decides: What session context is needed

### Matcher Pattern Concept

**Trust AI to choose appropriate patterns**:

**Simple Matching**:
- `"Bash"` - Exact match for bash tool
- `"Write|Edit"` - Multiple specific tools
- `"*"` - All tools (AI decides when appropriate)

**Pattern Matching**:
- Regex patterns for complex matching
- File path patterns for specific files
- Command patterns for specific operations

## Core Implementation Patterns

### Pattern 1: Validation Hooks

**Concept**: Validate operations before execution

**When AI Should Use**:
- Need to prevent dangerous operations
- Want to validate file operations
- Need to check environment state

**Implementation Guidance**:
- Use PreToolUse for validation
- Trust AI to choose appropriate tools to validate
- AI decides validation logic based on project context
- Use exit 2 to block dangerous operations

### Pattern 2: Security Guardrails

**Concept**: Prevent unauthorized or dangerous actions

**When AI Should Use**:
- Projects with sensitive files (.env, secrets)
- Production deployment scenarios
- Database operations
- System-level commands

**Implementation Guidance**:
- Trust AI to identify sensitive patterns in project
- Use PreToolUse for prevention
- AI decides specific security rules based on project type
- Component-scoped hooks preferred for auto-cleanup

### Pattern 3: Automation Hooks

**Concept**: Automate repetitive tasks after operations

**When AI Should Use**:
- Need to format code after edits
- Want to log operations for audit
- Need to update project state
- Want to trigger follow-up actions

**Implementation Guidance**:
- Use PostToolUse for automation
- Trust AI to identify automation opportunities
- AI decides automation logic based on project needs
- Use once: true for one-time setup hooks

### Pattern 4: Session Management

**Concept**: Manage session lifecycle and context

**When AI Should Use**:
- Need to set up environment on session start
- Want to persist state between sessions
- Need cleanup on session end
- Want to initialize project context

**Implementation Guidance**:
- Use SessionStart/End for lifecycle management
- Trust AI to determine session needs
- AI decides what context to load/persist
- Use CLAUDE_ENV_FILE for environment persistence

## Configuration Location Strategy

### Local Project (Default)

**Location**: `.claude/settings.json`

**When AI Should Use**:
- Project-specific automation
- Team collaboration needed
- Version-controlled settings
- Project security policies

**Benefits**:
- AI understands project context
- Appropriate for project-specific needs
- Team sharing through git

### Component-Scoped (Preferred for Auto-Cleanup)

**Location**: YAML frontmatter in skills/agents

**When AI Should Use**:
- Skill-specific validation
- Temporary or experimental hooks
- Need auto-cleanup
- Avoid global impact

**Benefits**:
- Auto-cleanup when component finishes
- Scoped to specific use cases
- No global side effects

## Environment Variable Usage

**Core Principle**: Use CLAUDE_PROJECT_DIR for portable scripts

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/scripts/validate.sh"
      }]
    }]
  }
}
```

**AI Should Handle**:
- Determining appropriate script locations
- Setting up project-specific variables
- Managing environment persistence

## Exit Code Strategy

**Standard Convention**:
- `0`: Success, operation allowed
- `1`: Warning, operation allowed
- `2`: Blocking error, operation denied

**AI Should Decide**:
- When to block vs warn
- What constitutes dangerous operations
- Appropriate error messaging

## Performance Considerations

**Core Principles**:
- Keep hooks fast (<100ms)
- Use specific matchers, not broad patterns
- Trust AI to optimize performance

**AI Should Handle**:
- Determining optimal matcher specificity
- Identifying performance bottlenecks
- Deciding when to cache validation results

## Security Best Practices

**Core Principles**:
- Validate inputs before processing
- Use whitelist over blacklist when possible
- Provide clear error messages
- Trust AI to identify security needs

**AI Should Handle**:
- Identifying security-sensitive operations in project
- Determining appropriate validation rules
- Choosing security patterns based on project type

## When NOT to Use Hooks

**Trust AI to recognize these cases**:
- Complex logic requiring user interaction (use skills instead)
- Temporary needs (use commands instead)
- Operations requiring external dependencies
- Cross-session state management (use other mechanisms)

## AI Decision Framework

**For Hook Implementation**:

1. **Assess Project Context**:
   - What type of project is this?
   - What security concerns exist?
   - What automation opportunities are present?

2. **Choose Appropriate Events**:
   - Validation needs → PreToolUse
   - Automation needs → PostToolUse
   - Lifecycle needs → SessionStart/End

3. **Select Configuration Scope**:
   - Project-wide policies → settings.json
   - Component-specific → frontmatter hooks
   - Personal preferences → settings.local.json

4. **Implement with AI Intelligence**:
   - Trust AI to write appropriate scripts
   - Let AI choose specific validation logic
   - Allow AI to optimize for project needs

## Quality Indicators

**High-Quality Hook Implementation**:
- ✅ Uses appropriate event for use case
- ✅ Configured at appropriate scope
- ✅ Includes proper error handling
- ✅ Performs efficiently
- ✅ Provides clear feedback

**Trust AI to Achieve**:
- Appropriate event selection
- Smart scope choice
- Intelligent validation logic
- Optimal performance
- Clear user feedback

---

## Reference

**For complete event documentation**: See [events.md](events.md)

**For configuration guidance**: See [hook-types.md](../hooks-architect/references/hook-types.md)

**Key Principle**: Provide concepts, trust AI to make intelligent implementation decisions based on project context and requirements.
