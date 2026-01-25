# Subagent Threshold Heuristic

The single question to ask: **"Would this clutter the conversation?"**

## The Clutter Test

| Scenario | Clutters? | Action |
|----------|-----------|--------|
| Reading 3 files | No | Native tools |
| Grepping 500 files | Yes | Subagent |
| Single bash command | No | Native tools |
| 20-step deployment | Yes | Subagent |
| Quick variable lookup | No | Grep tool |
| Full codebase audit | Yes | Subagent |

## The Three Triggers

Spawn a subagent when ANY of these are true:

1. **Output Volume**: Would produce >100 lines of exploration noise
2. **Context Pollution**: Would derail the current conversation thread
3. **Isolation Need**: Must not see/affect current conversation state

If none are true → **use native tools**.

## Agent Type Selection

```
Need fast read-only search?     → Explore
Need architecture reasoning?    → Plan
Need shell execution?           → Bash
Need everything?                → general-purpose
```

## Anti-Pattern: Subagent for Simple Operations

```yaml
# ❌ WASTEFUL: Subagent for single file
Task(subagent_type: Explore, prompt: "Read config.json")

# ✅ CORRECT: Native tool
Read("config.json")
```

The subagent overhead (new context window + initialization) is only justified when the task would otherwise pollute the main conversation.
