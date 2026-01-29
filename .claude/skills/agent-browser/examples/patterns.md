# Utility Patterns

Reusable patterns for common operations.

## Wait for Element

```bash
agent-browser open "$URL"

for i in {1..10}; do
  agent-browser snapshot -i > snapshot.txt
  if grep -q "desired_text" snapshot.txt; then
    break
  fi
  sleep 1
done

agent-browser click @target_element
```

## Scoped Snapshot

```bash
agent-browser snapshot -s "#main-content"  # Only main content
agent-browser snapshot -s "form"           # Only form elements
agent-browser snapshot -s "nav"            # Only navigation
```

## Screenshot Comparison

```bash
agent-browser open "$URL"
agent-browser snapshot > baseline.txt

agent-browser click @button
agent-browser snapshot > after.txt

diff baseline.txt after.txt
```

## File Upload

```bash
agent-browser open "https://example.com/upload"
agent-browser snapshot -i
agent-browser upload @e5 /path/to/file.pdf

agent-browser snapshot -i
agent-browser get attr @e10 src

agent-browser click @e15
sleep 3

agent-browser snapshot -i
agent-browser click @download_btn
agent-browser get text @e20
```
