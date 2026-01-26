---
name: hook-development
description: This skill should be used when the user asks to "create a hook", "add a PreToolUse/PostToolUse/Stop hook", "validate tool use", "implement prompt-based hooks", "set up event-driven automation", "block dangerous commands", or mentions hook events (PreToolUse, PostToolUse, PostToolUseFailure, PermissionRequest, Stop, SubagentStop, SubagentStart, SessionStart, SessionEnd, UserPromptSubmit, PreCompact, Setup, Notification). Provides comprehensive guidance for creating and implementing hooks in local .claude/ configuration with focus on project-level automation and security.
---

# Hook Development Guide

**Purpose**: Help you create event-driven automation that validates operations and enforces policies

---

## What Hooks Are

Hooks are event-driven automation scripts that execute in response to Claude Code events. They validate operations, enforce policies, and integrate external tools into workflows.

**Key point**: Good hooks work independently and don't need external documentation to validate events.

✅ Good: Hook includes specific event handlers with validation logic
❌ Bad: Hook references external documentation for event logic
Why good: Hooks must self-validate without external dependencies

**Question**: Would this hook work if moved to a project with no rules? If no, include the necessary validation directly.

---

## Philosophy Foundation

Hooks follow these core principles for event-driven automation and security.

### Progressive Disclosure for Hooks

Hooks use targeted disclosure (event-specific validation):

**Tier 1: Event Selection** (choose the right event)
- **PreToolUse**: Validate before tool execution
- **PostToolUse**: React to tool results
- **Stop**: Enforce completion standards
- **PermissionRequest**: Validate permission requests
- **SessionStart/End**: Load/cleanup context

**Tier 2: Validation Logic** (complete in hook)
- Event-specific patterns
- Response format requirements
- Error handling
- Purpose: Enable reliable validation

**Why targeted?** Hooks execute synchronously during events. They must be complete and fast.

**Recognition**: "Does this hook handle all cases for its event type?"

### The Delta Standard for Hooks

> Good hook = Event-specific validation knowledge − Generic hook concepts

Include in hooks (Positive Delta):
- Event-specific patterns (PreToolUse vs PostToolUse)
- Validation logic for the event
- Response format requirements
- Security considerations for the operation
- Error handling patterns

Exclude from hooks (Zero/Negative Delta):
- General "hooks are event-driven" explanations
- Obvious JSON structure
- Generic validation concepts

**Recognition**: "Is this validation logic specific to this event type?"

### Voice and Freedom for Hooks

**Voice**: Imperative validation instructions

Use imperative form in hook prompts:
- "Validate file write safety. Respond with JSON: `{\"ok\": true}`"
- "Check if this operation is safe. Block with reason if not."
- Direct: "Allow if X, block if Y"

**Freedom**: Low for most hooks (security requires consistency)

| Freedom Level | When to Use | Hook Examples |
|---------------|-------------|---------------|
| **Medium** | Flexible validation | Style checks, formatting hooks |
| **Low** | Security/safety operations | File write validation, deployment blocks, permission checks |

**Recognition**: "What breaks if this hook allows an unsafe operation?"

### Self-Containment for Hooks

**Hooks must work without external scripts or dependencies.**

Never reference external files:
- ❌ "See validation-scripts/ for checks"
- ❌ "Use patterns from .claude/rules/"

Always include directly:
- ✅ Complete validation logic
- ✅ Response format specification
- ✅ Error handling instructions
- ✅ All necessary context

**Why**: Hooks execute synchronously during events. External references cause failures.

**Recognition**: "Could this hook execute without external files?"

---

## What Good Hooks Have

### 1. Specific Event Targeting

**Good hooks respond to specific events with clear validation logic.**

Choose the right event type:
- **PreToolUse** - Validate before tool execution
- **PostToolUse** - React to tool results
- **Stop** - Enforce completion standards
- **PermissionRequest** - Validate permission requests
- **SessionStart/End** - Load/cleanup context

**Example**:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Validate file write safety. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
          }
        ]
      }
    ]
  }
}
```

✅ Good: Specific event type with clear validation logic
❌ Bad: Generic event handlers without concrete patterns
Why good: Specific events enable targeted enforcement

### 2. Complete Validation Logic

**Good hooks include all necessary validation in the hook itself.**

For prompt-based hooks:
- Define validation criteria
- Specify response format
- Include timeout for execution

**Example**:
```json
{
  "type": "prompt",
  "prompt": "Evaluate if this operation is appropriate: $ARGUMENTS. Check for: system paths, credentials, destructive operations. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block.",
  "timeout": 30
}
```

### 3. Proper Response Format

**Good hooks return structured responses.**

For prompt hooks:
```json
{ "ok": true, "reason": "validation passed" }
// or
{ "ok": false, "reason": "blocked for security reasons" }
```

For Stop hooks:
```json
{ "decision": "allow", "reason": "validation passed" }
// or
{ "decision": "block", "reason": "tests must be run" }
```

### 4. No External Dependencies

**Good hooks work in isolation.**

- Don't reference .claude/rules/ files
- Don't link to external scripts
- Include all validation logic directly
- Bundle necessary security patterns

✅ Good: Complete validation logic included in hook
❌ Bad: "See external scripts for validation"
Why good: Self-contained hooks work anywhere

**Question**: Does this hook assume external files? If yes, include that logic directly.

---

## How to Structure Hooks

### Hook Configuration

Hooks live in `.claude/settings.json` (team-wide) or `.claude/settings.local.json` (personal):

```json
{
  "hooks": {
    "EventType": [
      {
        "matcher": "ToolName|*",
        "hooks": [
          {
            "type": "prompt|command",
            "prompt|command": "[validation logic]",
            "timeout": 30,
            "async": false,
            "description": "Optional description for documentation"
          }
        ]
      }
    ]
  }
}
```

### Hook Configuration Fields

**matcher** - Expression to match events:
- Simple: `"Write|Edit"` - matches tool names
- Advanced: `tool == "Bash" && tool_input.command matches "pattern"` - matches tool and input
- Negation: `tool == "Write" && !(tool_input.file_path matches "allowed.md")` - excludes patterns

**type** - Hook execution type:
- `"prompt"` - Uses LLM for validation decisions (context-aware, flexible)
- `"command"` - Executes bash commands (fast, deterministic)

**async** - Run hook in background (optional):
- `"async": true` - Runs without blocking, requires `"timeout"`
- `"async": false` (default) - Blocks until completion

**timeout** - Maximum execution time in seconds (required for async hooks)

**description** - Optional documentation for the hook's purpose

### Hook Types

**Prompt-Based Hooks** (recommended for complex validation):
- Use LLM for validation decisions
- Context-aware and flexible
- Return JSON responses

**Command Hooks** (recommended for fast checks):
- Execute bash commands
- Fast, deterministic checks
- Good for external tools, file operations

### Event Types Reference

**PreToolUse** - Validate before tool execution
- Use for: File write validation, command safety checks, blocking operations
- Response: `{ "ok": true }` to allow, `{ "ok": false, "reason": "..." }` to block

**PostToolUse** - React to tool results
- Use for: Auto-formatting, type checking, logging, notifications
- Runs after tool completes successfully
- Response: Pass-through (modify output via stdout)

**PostToolUseFailure** - React to tool failures
- Use for: Error logging, fallback mechanisms, retry logic
- Runs when tool fails or errors
- Response: Pass-through

**PermissionRequest** - Validate permission requests
- Use for: Additional security checks, permission auditing
- Runs before tool permission is granted
- Response: `{ "ok": true }` to allow, `{ "ok": false, "reason": "..." }` to block

**Stop** - Enforce completion standards
- Use for: Pre-exit validation, final checks, ensuring tests ran
- Runs before session ends
- Response: `{ "decision": "allow" }` to exit, `{ "decision": "block", "reason": "..." }` to prevent exit

**SessionStart** - Initialize session context
- Use for: Load previous context, detect environment, initialize state
- Runs when new session starts
- Response: Log to stderr (non-blocking)

**SessionEnd** - Persist session state
- Use for: Save session history, extract patterns, cleanup
- Runs when session ends
- Response: Log to stderr (non-blocking)

**PreCompact** - Before context compaction
- Use for: Save important context before compaction
- Response: Log to stderr (non-blocking)

**SubagentStart** - When subagent is created
- Use for: Initialize subagent context, track subagent spawning
- Response: Log to stderr (non-blocking)

**SubagentStop** - When subagent completes
- Use for: Collect subagent results, cleanup
- Response: Log to stderr (non-blocking)

**UserPromptSubmit** - When user submits prompt
- Use for: Prompt validation, preprocessing
- Response: Pass-through or modify

**Setup** - During Claude Code initialization
- Use for: One-time setup, environment validation
- Response: Log to stderr (non-blocking)

**Notification** - System notifications
- Use for: Custom notification handling
- Response: Pass-through

**Question**: Which event matches your validation need? Choose the most specific event for targeted enforcement.

---

## Common Patterns

### Matcher Expression Patterns

**Simple tool matching**:
```json
{
  "matcher": "Write|Edit"
}
```

**Advanced matching with tool input**:
```json
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"(npm run dev|pnpm dev)\""
}
```

**Negation (exclusion patterns)**:
```json
{
  "matcher": "tool == \"Write\" && !(tool_input.file_path matches \"README\\\\.md|CLAUDE\\\\.md\")"
}
```

**File extension matching**:
```json
{
  "matcher": "tool == \"Edit\" && tool_input.file_path matches \"\\\\.(ts|tsx|js|jsx)$\""
}
```

### Prompt-Based Validation

Use prompt hooks for complex, context-aware decisions:

```json
{
  "type": "prompt",
  "prompt": "Evaluate if this operation is appropriate: $ARGUMENTS. Check for security risks. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block.",
  "timeout": 30
}
```

Response format: `{ "ok": true|false, "reason": "explanation" }`

### Command Hooks

Use command hooks for fast, deterministic checks:

```json
{
  "type": "command",
  "command": "bash .claude/scripts/validate.sh",
  "timeout": 60
}
```

**Good for**: File checks, external tools, performance-critical validation

### Async Hooks

Run hooks in background without blocking:

```json
{
  "type": "command",
  "command": "node -e \"console.error('Running async analysis...')\"",
  "async": true,
  "timeout": 30
}
```

**Good for**: Build analysis, long-running operations, notifications

### Script Path References

**For local project hooks**, use relative paths from project root:

```json
{
  "type": "command",
  "command": "node .claude/scripts/hooks/my-hook.js"
}
```

**For plugin hooks** (when developing plugins), use `${CLAUDE_PLUGIN_ROOT}`:

```json
{
  "type": "command",
  "command": "node \"${CLAUDE_PLUGIN_ROOT}/scripts/hooks/my-hook.js\""
}
```

**Remember**: This skill focuses on local project hooks. Plugin development has additional considerations.

### Multiple Hooks

Stack multiple hooks for layered validation:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {"type": "command", "command": ".claude/scripts/check1.sh"},
          {"type": "prompt", "prompt": "Final validation check..."}
        ]
      }
    ]
  }
}
```

**Remember**: Hooks run independently and don't see each other's output.

---

## Security Examples

### File Write Validation

Prevent unsafe file operations:

```json
{
  "matcher": "Write|Edit",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "Validate file write safety. Check: system paths, credentials, path traversal. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
    }
  ]
}
```

### Block Random Documentation Files

Prevent creation of unnecessary markdown files:

```json
{
  "matcher": "tool == \"Write\" && tool_input.file_path matches \"\\\\.(md|txt)$\" && !(tool_input.file_path matches \"README\\\\.md|CLAUDE\\\\.md|AGENTS\\\\.md|CONTRIBUTING\\\\.md\")",
  "hooks": [
    {
      "type": "command",
      "command": "node -e \"console.error('[Hook] BLOCKED: Unnecessary documentation file');console.error('[Hook] Use README.md for documentation instead');process.exit(1)\"",
      "description": "Block creation of random .md files"
    }
  ]
}
```

### Dev Server Tmux Enforcement

Block dev servers from running outside tmux:

```json
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"(npm run dev|pnpm( run)? dev|yarn dev|bun run dev)\"",
  "hooks": [
    {
      "type": "command",
      "command": "node -e \"console.error('[Hook] BLOCKED: Dev server must run in tmux');console.error('[Hook] Use: tmux new-session -d -s dev \\\"npm run dev\\\"');process.exit(1)\"",
      "description": "Block dev servers outside tmux"
    }
  ]
}
```

### Completion Enforcement

Ensure tests run after code changes:

```json
{
  "matcher": "*",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "If code was modified, verify tests were run. If not, respond with JSON: {\"decision\": \"block\", \"reason\": \"Tests must be run after code changes\"}. Otherwise respond: {\"decision\": \"allow\"}."
    }
  ]
}
```

### Bash Command Safety

Validate dangerous operations:

```json
{
  "matcher": "Bash",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "Validate bash command safety. Check: destructive operations, system commands, credential access. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
    }
  ]
}
```

## Automation Examples

### Auto-Format After Edit

Automatically format JavaScript/TypeScript files after editing:

```json
{
  "matcher": "tool == \"Edit\" && tool_input.file_path matches \"\\\\.(ts|tsx|js|jsx)$\"",
  "hooks": [
    {
      "type": "command",
      "command": "node -e \"const{execSync}=require('child_process');const fs=require('fs');let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>{const i=JSON.parse(d);const p=i.tool_input?.file_path;if(p&&fs.existsSync(p)){try{execSync('npx prettier --write \\\"'+p+'\\\"',{stdio:['pipe','pipe','pipe']})}catch(e){}}console.log(d)})\"",
      "description": "Auto-format JS/TS files with Prettier"
    }
  ]
}
```

### TypeScript Type Checking

Run TypeScript checks after editing TypeScript files:

```json
{
  "matcher": "tool == \"Edit\" && tool_input.file_path matches \"\\\\.(ts|tsx)$\"",
  "hooks": [
    {
      "type": "command",
      "command": "node -e \"const{execSync}=require('child_process');const fs=require('fs');const path=require('path');let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>{const i=JSON.parse(d);const p=i.tool_input?.file_path;if(p&&fs.existsSync(p)){let dir=path.dirname(p);while(dir!==path.dirname(dir)&&!fs.existsSync(path.join(dir,'tsconfig.json'))){dir=path.dirname(dir)}if(fs.existsSync(path.join(dir,'tsconfig.json'))){try{execSync('npx tsc --noEmit --pretty false 2>&1',{cwd:dir,encoding:'utf8',stdio:['pipe','pipe','pipe']})}catch(e){console.error(e.stdout||'')}}}console.log(d)})\"",
      "description": "TypeScript check after editing .ts/.tsx files"
    }
  ]
}
```

### Console.log Detection

Warn about console.log statements after edits:

```json
{
  "matcher": "tool == \"Edit\" && tool_input.file_path matches \"\\\\.(ts|tsx|js|jsx)$\"",
  "hooks": [
    {
      "type": "command",
      "command": "node -e \"const fs=require('fs');let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>{const i=JSON.parse(d);const p=i.tool_input?.file_path;if(p&&fs.existsSync(p)){const c=fs.readFileSync(p,'utf8');if(/console\\.log/.test(c)){console.error('[Hook] WARNING: console.log found in '+p);console.error('[Hook] Remove console.log before committing')}}console.log(d)})\"",
      "description": "Warn about console.log statements after edits"
    }
  ]
}
```

### Git Push Reminder

Remind to review changes before pushing:

```json
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"git push\"",
  "hooks": [
    {
      "type": "command",
      "command": "node -e \"console.error('[Hook] Review changes before push...');console.error('[Hook] Continuing with push')\"",
      "description": "Reminder before git push"
    }
  ]
}
```

## Session Management Examples

### Session Start Hook

Load previous context on new session:

```javascript
#!/usr/bin/env node
/**
 * SessionStart Hook - Load previous context on new session
 *
 * Save as: .claude/scripts/hooks/session-start.js
 * Cross-platform (Windows, macOS, Linux)
 */

const path = require('path');

async function main() {
  // Check for recent session files
  const sessionsDir = path.join(process.env.HOME, '.claude', 'sessions');

  // Notify Claude of available context
  console.error('[SessionStart] Checking for previous sessions...');

  process.exit(0); // Always exit 0 to not block
}

main().catch(err => {
  console.error('[SessionStart] Error:', err.message);
  process.exit(0); // Don't block on errors
});
```

**Hook configuration**:
```json
{
  "matcher": "*",
  "hooks": [
    {
      "type": "command",
      "command": "node .claude/scripts/hooks/session-start.js"
    }
  ]
}
```

### Session End Hook

Persist session state when session ends:

```javascript
#!/usr/bin/env node
/**
 * SessionEnd Hook - Persist session state
 *
 * Save as: .claude/scripts/hooks/session-end.js
 */

async function main() {
  console.error('[SessionEnd] Saving session state...');

  // Save session history, extract patterns, etc.

  process.exit(0);
}

main().catch(err => {
  console.error('[SessionEnd] Error:', err.message);
  process.exit(0);
});
```

**Hook configuration**:
```json
{
  "matcher": "*",
  "hooks": [
    {
      "type": "command",
      "command": "node .claude/scripts/hooks/session-end.js"
    }
  ]
}
```

## Hook Script Best Practices

### Always Use process.exit(0)

Hooks should never block Claude execution. Always exit with code 0:

```javascript
// ❌ Bad - blocks on error
throw new Error('Failed');

// ✅ Good - logs and exits
console.error('[Hook] Error:', err.message);
process.exit(0);
```

### Cross-Platform Shebang

Use cross-platform shebang for portability:

```javascript
#!/usr/bin/env node
// Works on Windows, macOS, and Linux
```

### Error Handling

Wrap hook logic in try-catch:

```javascript
async function main() {
  try {
    // Hook logic
  } catch (err) {
    console.error('[Hook] Error:', err.message);
    process.exit(0); // Don't block
  }
}
```

### Logging to stderr

Use stderr for logging, stdout for data passthrough:

```javascript
// Log messages to stderr
console.error('[Hook] Information message');

// Pass data through stdout
console.log(JSON.stringify(data));
```

### Async Hook Pattern

For long-running operations, use async hooks:

```json
{
  "type": "command",
  "command": "node -e \"console.error('[Hook] Running analysis...')\"",
  "async": true,
  "timeout": 30
}
```

This runs in background without blocking Claude.

---

## Common Mistakes

### Mistake 1: Vague Event Matching

❌ Bad:
```json
{
  "matcher": "*",
  "hooks": [
    {"type": "prompt", "prompt": "Check this..."}
  ]
}
```

✅ Good:
```json
{
  "matcher": "Write|Edit",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "Validate file write safety...",
      "timeout": 30
    }
  ]
}
```

**Why**: Specific matching enables targeted validation. Broad matchers create performance issues and unexpected blocking.

### Mistake 2: Incomplete Validation Logic

❌ Bad:
```json
{
  "type": "prompt",
  "prompt": "Check if this is okay"
}
```

✅ Good:
```json
{
  "type": "prompt",
  "prompt": "Evaluate if this operation is appropriate: $ARGUMENTS. Check for security risks, destructive operations, system paths. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block.",
  "timeout": 30
}
```

**Why**: Complete logic enables autonomous decisions.

### Mistake 3: Missing Response Format

❌ Bad:
```json
{
  "type": "prompt",
  "prompt": "Check this and respond"
}
```

✅ Good:
```json
{
  "type": "prompt",
  "prompt": "Validate operation. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block.",
  "timeout": 30
}
```

**Why**: Structured responses enable proper handling.

### Mistake 4: Blocking on Errors

❌ Bad:
```javascript
// Hook that blocks Claude on error
throw new Error('Failed');
process.exit(1);
```

✅ Good:
```javascript
// Hook that logs and allows continuation
console.error('[Hook] Error:', err.message);
process.exit(0); // Always exit 0
```

**Why**: Hooks should never block Claude execution. Always exit with code 0.

### Mistake 5: Missing Timeout for Async Hooks

❌ Bad:
```json
{
  "type": "command",
  "command": "long-running-task",
  "async": true
  // Missing timeout!
}
```

✅ Good:
```json
{
  "type": "command",
  "command": "long-running-task",
  "async": true,
  "timeout": 30
}
```

**Why**: Async hooks require timeout to prevent indefinite hanging.

### Mistake 6: Not Using Advanced Matcher Syntax

❌ Bad:
```json
{
  "matcher": "Bash"
  // Matches ALL Bash commands
}
```

✅ Good:
```json
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"git push\""
  // Matches only specific command
}
```

**Why**: Advanced matchers enable precise targeting without false positives.

---

## Hook Anti-Patterns

Recognition-based patterns to avoid when creating hooks.

### Anti-Pattern 1: Blocking the User

**❌ Hooks that block normal workflows with unnecessary friction**

❌ Bad: Hook that blocks every file write for "approval"
✅ Good: Hook that blocks only dangerous operations (system paths, credentials)

**Recognition**: "Does this hook add value or just create friction?"

**Why**: Excessive blocking trains users to disable hooks entirely.

### Anti-Pattern 2: Silent Failures

**❌ Hooks that fail silently without feedback**

❌ Bad: Hook that fails without logging why
✅ Good: Hook that logs errors to stderr before exiting

**Recognition**: "If this hook fails, will the user know why?"

**Why**: Silent failures make debugging impossible and erode trust.

### Anti-Pattern 3: Heavy Processing in Hooks

**❌ Hooks that perform heavy computations synchronously**

❌ Bad: Hook that runs full test suite on every edit
✅ Good: Hook that runs quick linter, or uses `"async": true` for heavy tasks

**Recognition**: "Does this hook complete quickly enough to not frustrate the user?"

**Why**: Hooks run synchronously by default and block execution.

### Anti-Pattern 4: Brittle Matcher Patterns

**❌ Hooks with matchers that break easily**

❌ Bad: `"matcher": "tool == \"Bash\" && tool_input.command matches \"npm install\""` (breaks on `npm i`)
✅ Good: `"matcher": "tool == \"Bash\" && tool_input.command matches \"npm (install|i)\""` (flexible)

**Recognition**: "Will this matcher work with common variations?"

**Why**: Brittle patterns fail unexpectedly and miss edge cases.

### Anti-Pattern 5: Not Logging Decisions

**❌ Hooks that make decisions without explaining why**

❌ Bad: Hook that blocks with no message
✅ Good: Hook that logs `[Hook] BLOCKED: Reason explanation` to stderr

**Recognition**: "Does this hook explain its decisions to the user?"

**Why**: Users need to understand why operations were blocked to adjust their behavior.

---

## Quality Checklist

A good hook:

- [ ] Uses specific event types and matchers (not generic "*")
- [ ] Has clear validation logic in the prompt/command
- [ ] Returns structured JSON responses with specified format
- [ ] Includes timeout values (required for async hooks)
- [ ] Works without external dependencies (self-contained)
- [ ] Always exits with code 0 (never blocks Claude)
- [ ] Logs decisions to stderr for user visibility
- [ ] Uses description field for documentation
- [ ] Handles errors gracefully with try/catch
- [ ] Uses cross-platform patterns (#!/usr/bin/env node)

**Self-check**: Could this hook work in a fresh project? If not, it needs more context.

**Security check**: Does this hook properly validate security-sensitive operations?

---

## Summary

Hooks are event-driven automation that validates operations and enforces policies. Good hooks:

- **Target specifically** - Use the right event for the job
- **Validate clearly** - Include all logic in the hook
- **Respond properly** - Return structured JSON
- **Work anywhere** - No external dependencies

Keep the focus on:
- Clarity over complexity
- Specificity over generality
- Self-contained over dependent
- Security over convenience

**Question**: Is your hook clear enough that it would validate events correctly without external documentation?

---

**Final tip**: The best hook is one that enforces security without requiring external setup. Focus on that.
