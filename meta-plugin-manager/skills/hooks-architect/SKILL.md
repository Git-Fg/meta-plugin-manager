---
name: hooks-architect
description: "Router for hooks domain expertise. Use for creating, auditing, or refining hooks for event automation and infrastructure integration. Routes to hooks-knowledge."
disable-model-invocation: true
---

# Hooks Architect

Domain router for hooks development with event automation and infrastructure integration focus.

## Actions

### create
**Creates new hooks** for event-driven automation

**Router Logic**:
1. Load: hooks-knowledge
2. Determine hook type:
   - Session initialization
   - Pre/Post tool use
   - File watchers
   - Validation hooks
3. Generate hook with:
   - hooks.json configuration
   - Event handlers
   - Security considerations
4. Validate: Event matching, security

**Output Contract**:
```
## Hook Created: {hook_name}

### Event Triggers
- {event_type}: {pattern}
- {event_type}: {pattern}

### Security Level: {level}
- Validation: ✅
- Safety checks: ✅

### Automation Scope
- {automation_1}
- {automation_2}
```

### audit
**Audits hooks** for security and effectiveness

**Router Logic**:
1. Load: hooks-knowledge
2. Check:
   - Event matching appropriateness
   - Security implementation
   - Performance impact
   - Error handling
3. Generate audit with security scoring

**Output Contract**:
```
## Hook Audit: {hook_name}

### Security Assessment
- Validation present: ✅/❌
- Safety checks: ✅/❌
- Input sanitization: ✅/❌

### Event Matching
- Pattern: {pattern}
- Scope: {scope}

### Performance Impact
- Latency: {latency}ms
- Resource usage: {usage}

### Issues
- {issue_1}
- {issue_2}
```

### refine
**Improves hooks** based on audit findings

**Router Logic**:
1. Load: hooks-knowledge
2. Enhance:
   - Security hardening
   - Event matching optimization
   - Error handling
   - Performance optimization
3. Validate improvements

**Output Contract**:
```
## Hook Refined: {hook_name}

### Security Enhancements
- {enhancement_1}
- {enhancement_2}

### Performance Improvements
- {improvement_1}
- {improvement_2}

### Reliability Score: {old_score} → {new_score}/10
```

## Hook Types

**Session Hooks**:
- SessionStart - Initialize session state
- SessionEnd - Cleanup resources

**Tool Hooks**:
- PreToolUse - Validate before execution
- PostToolUse - Process results

**Validation Hooks**:
- PreWrite - Validate file operations
- PreEdit - Validate modifications

**Infrastructure Hooks**:
- MCP configuration
- LSP setup
- Environment preparation

## Knowledge Base

**hooks-knowledge**:
- Event handling patterns
- Security best practices
- Infrastructure integration
- Performance optimization

## Routing Criteria

**Route to hooks-knowledge** when:
- Creating new hooks
- Auditing security
- Refining event handling
- Infrastructure questions

**Direct action** when:
- Standard hook patterns
- Simple event matching
- Basic security checks
