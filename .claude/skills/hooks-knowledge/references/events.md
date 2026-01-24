# Hook Events Reference

Essential concepts for hook events in Claude Code. Trust AI to understand event patterns and make intelligent implementation decisions.

## Core Philosophy: Trust AI Intelligence

**This reference teaches event concepts, not prescriptive patterns:**

1. **Trust AI Understanding**: AI grasps event concepts and makes intelligent decisions
2. **Focus on Principles**: Provide concepts, AI handles implementation specifics
3. **Autonomous Execution**: AI completes tasks without user interaction
4. **Minimal Prescriptiveness**: Let AI choose appropriate events based on needs
5. **Project Context**: AI understands when to use which events

## Essential Events

### PreToolUse
**Purpose**: Validate before operations
**AI Should Use For**:
- Security validation and guardrails
- Dangerous operation prevention
- Environment checks
- Permission handling

**AI Decision Framework**:
- AI determines which tools need validation
- AI chooses appropriate validation logic
- AI decides blocking vs warning behavior

### PostToolUse
**Purpose**: Process after successful operations
**AI Should Use For**:
- Logging and audit trails
- Code formatting and cleanup
- State updates and notifications
- Follow-up automation

**AI Decision Framework**:
- AI identifies automation opportunities
- AI chooses appropriate follow-up actions
- AI determines notification and logging needs

### Stop
**Purpose**: Final validation and cleanup
**AI Should Use For**:
- Final security checks
- State persistence
- Cleanup operations
- Completion validation

**AI Decision Framework**:
- AI determines what final validation is needed
- AI decides what state to persist
- AI chooses appropriate cleanup actions

## Lifecycle Events

### SessionStart
**Purpose**: Session initialization
**AI Should Use For**:
- Environment setup
- Context loading
- Project initialization
- State restoration

**AI Decision Framework**:
- AI determines what session context is needed
- AI chooses appropriate initialization logic
- AI decides what to persist for session

### SessionEnd
**Purpose**: Session termination cleanup
**AI Should Use For**:
- Resource cleanup
- State saving
- Final logging
- Session summary generation

**AI Decision Framework**:
- AI determines appropriate cleanup scope
- AI decides what state to save
- AI chooses appropriate final actions

### UserPromptSubmit
**Purpose**: User input validation
**AI Should Use For**:
- Prompt security filtering
- Context injection
- Input validation
- Request appropriateness checks

**AI Decision Framework**:
- AI determines appropriate security filters
- AI decides what context to inject
- AI chooses validation logic based on project needs

## Specialized Events

### PermissionRequest
**Purpose**: Permission handling
**AI Should Use For**:
- Custom permission logic
- Automated approval
- Permission context validation

**AI Decision Framework**:
- AI determines appropriate permission policies
- AI decides automated vs manual approval
- AI chooses permission logic based on security requirements

### Notification
**Purpose**: Custom notification handling
**AI Should Use For**:
- Notification filtering
- Custom alert handling
- Integration with external systems

**AI Decision Framework**:
- AI determines appropriate notification handling
- AI decides what notifications to process
- AI chooses integration logic based on project needs

### SubagentStart/Stop
**Purpose**: Subagent lifecycle management
**AI Should Use For**:
- Subagent configuration
- Result collection
- State merging
- Cleanup coordination

**AI Decision Framework**:
- AI determines appropriate subagent coordination
- AI decides what state to merge
- AI chooses cleanup logic based on subagent needs

### Setup
**Purpose**: Repository initialization
**AI Should Use For**:
- One-time setup operations
- Dependency installation
- Configuration initialization

**AI Decision Framework**:
- AI determines appropriate setup operations
- AI decides what to initialize
- AI chooses setup logic based on project type

## Event Selection Framework

**Trust AI to choose appropriate events based on use case**:

### For Validation Needs
- **Primary**: PreToolUse
- **Supporting**: Stop (final validation)
- **AI Decides**: Which tools to validate, validation logic

### For Automation Needs
- **Primary**: PostToolUse
- **Supporting**: SessionStart (initialization)
- **AI Decides**: What automation to perform, timing

### For Security Needs
- **Primary**: PreToolUse, PermissionRequest
- **Supporting**: Stop (final security check)
- **AI Decides**: Security policies, blocking logic

### For Lifecycle Management
- **Primary**: SessionStart, SessionEnd
- **Supporting**: Setup (initialization)
- **AI Decides**: What lifecycle management is needed

## Key Concepts

### Matcher Patterns
**Trust AI to choose appropriate patterns**:

**Simple Matching**:
- Exact tool names: `"Bash"`, `"Write"`
- Multiple tools: `"Write|Edit"`
- All tools: `"*"`

**Pattern Matching**:
- Regex patterns for complex matching
- File patterns for specific files
- Command patterns for specific operations

### Exit Code Convention
**Standard Practice**:
- `0`: Success, operation allowed
- `1`: Warning, operation allowed
- `2`: Blocking error, operation denied

**AI Should Decide**:
- When to block vs warn
- What constitutes dangerous operations
- Appropriate error messaging

### Environment Variables
**Core Variable**: `CLAUDE_PROJECT_DIR` for portable scripts

**AI Should Handle**:
- Determining appropriate script locations
- Setting up project-specific variables
- Managing environment persistence

## Implementation Guidance

### Trust AI Intelligence
**AI Should Make Intelligent Decisions About**:
- Which events to use for specific use cases
- How to implement event logic appropriately
- When to combine multiple events
- How to optimize for performance and clarity

### Local Project Focus
**Implementation Principles**:
- Create hooks in your project directory
- Use component-scoped hooks for auto-cleanup
- Trust AI to choose appropriate scope
- Let AI optimize for project needs

### Performance Considerations
**Core Principles**:
- Keep hooks fast (<100ms)
- Use specific matchers, not broad patterns
- Trust AI to optimize performance

## Best Practices

### Trust AI Implementation
**Let AI Decide**:
- Specific validation logic
- Appropriate error handling
- Optimal performance optimization
- Clear user feedback mechanisms

### Autonomous Execution
**Ensure AI Can**:
- Complete tasks without user interaction
- Make intelligent decisions based on context
- Implement appropriate error handling
- Optimize for project-specific needs

### Quality Indicators
**High-Quality Implementation**:
- ✅ Uses appropriate events for use case
- ✅ Includes proper error handling
- ✅ Performs efficiently
- ✅ Provides clear feedback
- ✅ Configured at appropriate scope

**Trust AI to Achieve**:
- Appropriate event selection
- Smart implementation logic
- Optimal performance
- Clear user experience

---

## Reference

**For implementation patterns**: See [implementation-patterns.md](implementation-patterns.md)

**For configuration guidance**: See [hook-types.md](../hooks-architect/references/hook-types.md)

**Key Principle**: Provide event concepts, trust AI to make intelligent implementation decisions based on project context and requirements.
