---
name: cat-detector
description: "Detects cat commands and warns about using native tools"
user-invocable: true
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./.claude/scripts/guard-cat-commands.sh"
---

# Cat Detector Skill

This skill automatically detects when bash `cat` commands are used and provides warnings to encourage using native Read tools instead.

## 🚨 MANDATORY: Read BEFORE Using

**CRITICAL**: You MUST read and understand these URLs:

### Primary Documentation (MUST READ)
- **[MUST READ] Agent Skills Best Practices**: https://code.claude.com/docs/en/skills
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Content**: Skill development patterns, progressive disclosure
  - **Cache**: 15 minutes minimum

- **[MUST READ] Native Tool Usage Guidelines**: https://code.claude.com/docs/en/claude-code/cli
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Content**: Read tool alternatives, command patterns
  - **Cache**: 15 minutes minimum

### ⚠️ BLOCKING RULES
- **DO NOT proceed** until you've read the mandatory reference files
- **REQUIRED** to understand tool usage patterns before creating detection skills

## Usage

This skill runs automatically in the background when activated and will warn about cat commands in any bash operations.

## Hook Behavior

- **Non-blocking warnings** that show helpful messages
- Encourages use of Read tool for better performance
- Works with all cat command variations

## What It Detects

- Simple cat commands: `cat file.txt`
- Cat with options: `cat -n file.txt`
- Cat with pipes: `cat file.txt | grep pattern`
- Multiple files: `cat file1.txt file2.txt`

## Warning Message

When a cat command is detected, users will see:

```
WARNING: Cat command detected; as a reminder you MUST use your native tools when possible, make sure it was relevant to use cat.
Consider using the Read tool instead of 'cat' for better performance and safety.
```

This helps maintain best practices while allowing the command to continue executing.

## CAT_DETECTOR_COMPLETE