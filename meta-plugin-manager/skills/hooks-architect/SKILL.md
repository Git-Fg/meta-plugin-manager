---
name: hooks-architect
description: "Project-scoped event automation router for .claude/hooks.json or component-scoped hooks. Use for creating hooks, auditing security, or refining event handlers. Routes to hooks-knowledge for infrastructure integration. Do not use for simple file validation."
disable-model-invocation: true
---

## 🚨 MANDATORY: Read BEFORE Routing

**CRITICAL**: You MUST read and understand these URLs:

### Primary Documentation (MUST READ)
- **[MUST READ] Project Configuration**: https://code.claude.com/docs/en/plugins
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Content**: .claude/ structure, component organization
  - **Cache**: 15 minutes minimum

- **[MUST READ] Hooks Documentation**: https://code.claude.com/docs/en/hooks
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Content**: Event automation, infrastructure integration
  - **Cache**: 15 minutes minimum

### ⚠️ BLOCKING RULES
- **DO NOT proceed** until you've fetched and reviewed Primary Documentation
- **MUST validate** all URLs are accessible before routing
- **REQUIRED** to understand hooks architecture before routing

---

# Hooks Architect

Domain router for project-scoped hooks development with event automation and infrastructure integration focus.

## Actions

### create
**Creates hooks** for project automation

**Target Options**:
1. **Global hooks**: `${CLAUDE_PROJECT_DIR}/.claude/hooks.json`
2. **Component-scoped**: Add `hooks:` block to skill frontmatter

**Router Logic**:
1. Load: hooks-knowledge
2. Determine hook scope:
   - "I need global automation" → Create .claude/hooks.json
   - "I need skill-specific validation" → Add hooks: to skill frontmatter
3. Generate hook with:
   - Event type (PreToolUse, Stop, etc.)
   - Matcher patterns
   - Command or prompt type
   - Security considerations
4. Validate: Event matching, security

**Output Contract**:
```
## Hook Created: {hook_name}

### Location
- Type: {global|component-scoped}
- Path: {path}

### Event Triggers
- {event_type}: {pattern}
- {event_type}: {pattern}

### Security Level: {level}
- Validation: ✅
- Safety checks: ✅
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

**Permission Hooks**:
- PermissionRequest - Handle permission prompts
- UserPromptSubmit - Process user submissions

**Agent Hooks**:
- SubagentStop - Handle subagent completion
- Stop - Handle session stop events

**System Hooks**:
- Notification - Handle system notifications
- PreCompact - Pre-context compact
- Setup - Hook system initialization

**Validation Hooks**:
- PreWrite - Validate file operations
- PreEdit - Validate modifications

**Infrastructure Hooks**:
- MCP configuration
- LSP setup
- Environment preparation

## Implementation Guidance

**For detailed implementation patterns**: Load: hooks-knowledge

**Security Best Practices**:
- Input validation and sanitization
- Event pattern matching safety
- Error handling and recovery
- Performance impact monitoring

### Session Persistence Protocol

**Purpose**: Memory persistence for plugin development workflow

**State File**: `.claude/PLUGIN_STATE.md`

**Use When**:
- Creating hooks for session state persistence
- Implementing SessionStart/Stop/PreCompact hooks
- Extracting plugin development decisions from transcripts

**Implementation**: Load: hooks-knowledge → references/session-persistence.md

## Routing Criteria

**Direct action** when:
- Standard hook patterns
- Simple event matching
- Basic security checks

**Load: hooks-knowledge** when:
- Infrastructure integration questions
- Advanced security patterns
- Event automation edge cases
- Detailed implementation guidance
