# Agent Browser - Common Patterns

## Pattern 1: Wait for Element

```bash
# Navigate to page
agent-browser open "$URL"

# Poll for element appearance
for i in {1..10}; do
  agent-browser snapshot -i > snapshot.txt
  if grep -q "desired_text" snapshot.txt; then
    break
  fi
  sleep 1
done

# Continue interaction
agent-browser click @target_element
```

## Pattern 2: Scoped Snapshot

```bash
# Snapshot only specific section of page
agent-browser snapshot -s "#main-content"

# Snapshot only form elements
agent-browser snapshot -s "form"

# Snapshot only navigation
agent-browser snapshot -s "nav"
```

## Pattern 3: Extract All Links

```bash
# Get all links from page
agent-browser snapshot -c | grep -E "href:|@" | while read line; do
  url=$(echo "$line" | grep -oP 'href: \K[^ ]+')
  echo "$url"
done
```

## Pattern 4: Table Data Extraction

```bash
# Snapshot table
agent-browser snapshot -s "table" > table.txt

# Extract row data
grep -A 1 "tr" table.txt | while read line; do
  # Process each row
  echo "$line"
done
```

## Pattern 5: Authentication Flow

```bash
# Open login page
agent-browser open "$LOGIN_URL"

# Fill credentials
agent-browser snapshot -i
agent-browser fill @email "$USER"
agent-browser fill @password "$PASS"
agent-browser click @login_btn

# Verify login success
agent-browser get title
agent-browser snapshot -i

# Check for logged-in user indicator
agent-browser get text @user_menu
```

## Pattern 6: Error Recovery

```bash
# Attempt action with retry
agent-browser open "$URL"
agent-browser snapshot -i

# Try clicking with fallback
if ! agent-browser click @primary_btn; then
  # Element might not be ready
  sleep 2
  agent-browser snapshot -i
  agent-browser click @primary_btn || agent-browser click @fallback_btn
fi
```

## Pattern 7: Scroll and Load

```bash
# Scroll to load more content
agent-browser open "$URL"

for i in {1..5}; do
  agent-browser scroll down 1000
  sleep 1
  agent-browser snapshot -i
done

# Extract all loaded items
agent-browser get text @items_container
```

## Pattern 8: Screenshot Comparison

```bash
# Take baseline screenshot
agent-browser open "$URL"
agent-browser snapshot > baseline.txt

# Make changes
agent-browser click @button
agent-browser snapshot > after.txt

# Compare
diff baseline.txt after.txt
```
