# Core Principles

Two mental models drive effective project memory.

## 1. The Delta Standard (What to Write)

**Formula**: `Effective Memory = Expert Knowledge - Generic Knowledge`

Claude already knows React, Python, and Git. It **doesn't** know your specific patterns.

### ❌ DELETE (Claude Knows)
- Tutorials ("What is React?")
- Generic best practices ("Write clean code")
- Library documentation ("How to use Express")
- Definitions of terms

### ✅ KEEP (The Delta)
- **Non-obvious**: "Auth module depends on Crypto init"
- **Decisions**: "We chose JWT over Sessions because..."
- **Workarounds**: "Tests fail in CI unless --runInBand"
- **Working Commands**: "npm run dev:docker" (complex flags)

---

## 2. Active Learning (When to Write)

Don't write documentation in a vacuum. Capture it **live**.

### Triggers
When you see:
- "I didn't know that command existed"
- "Oh, the build failed because of X"
- "That solution worked!"

### Action
**Immediately** persist that finding to `CLAUDE.md`.

1. **Capture**: The specific command or fix.
2. **Contextualize**: When does it apply?
3. **Verify**: Does it follow the Delta Standard?
