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