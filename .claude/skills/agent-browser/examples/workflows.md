# Workflows

Multi-step processes with error handling.

## Multi-Step with Error Handling

```bash
agent-browser open "https://shop.example.com/product/123"

# Add to cart
agent-browser snapshot -i
agent-browser click @e5

# Handle popup
agent-browser snapshot -i
if popup_present; then
  agent-browser click @e20
fi

# Navigate to cart
agent-browser click @e10

# Fill checkout
agent-browser snapshot -i
agent-browser fill @e15 "user@example.com"
agent-browser fill @e16 "Street Address"
agent-browser fill @e17 "City"
agent-browser select @e18 "US"
agent-browser fill @e19 "12345"

# Complete purchase
agent-browser check @e20
agent-browser click @e21

# Verify
agent-browser get title
agent-browser get text @e25
```

## Dynamic SPA Interaction

```bash
agent-browser open "https://app.example.com/dashboard"
agent-browser snapshot -i

# Trigger dynamic content
agent-browser click @e5
sleep 1
agent-browser snapshot -i
agent-browser get text @e10

# Interact with table
agent-browser click @e15
sleep 0.5
agent-browser snapshot -i
agent-browser fill @e20 "search term"
press Enter
sleep 1
agent-browser snapshot -i

agent-browser get text @e25
```

## Error Recovery

```bash
agent-browser open "$URL"
agent-browser snapshot -i

if ! agent-browser click @primary_btn; then
  sleep 2
  agent-browser snapshot -i
  agent-browser click @primary_btn || agent-browser click @fallback_btn
fi
```

## Data Scraping with Pagination

```bash
agent-browser open "https://example.com/items"

for page in {1..5}; do
  agent-browser snapshot -i > page_$page.txt

  for elem in $(seq 1 20); do
    agent-browser get text @e$elem
  done

  agent-browser snapshot -i
  agent-browser click @next
  sleep 2
done

agent-browser close
```
