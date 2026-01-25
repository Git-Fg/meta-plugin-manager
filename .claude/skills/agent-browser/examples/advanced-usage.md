# Agent Browser - Advanced Usage Examples

## Example 1: Multi-Step Workflow with Error Handling

```bash
# E-commerce checkout flow
agent-browser open "https://shop.example.com/product/123"

# Add to cart
agent-browser snapshot -i
agent-browser click @e5  # Add to cart button

# Handle potential popup
agent-browser snapshot -i
if popup_present; then
  agent-browser click @e20  # Close popup
fi

# Navigate to cart
agent-browser click @e10

# Fill checkout form
agent-browser snapshot -i
agent-browser fill @e15 "user@example.com"
agent-browser fill @e16 "Street Address"
agent-browser fill @e17 "City"
agent-browser select @e18 "US"
agent-browser fill @e19 "12345"

# Complete purchase
agent-browser check @e20  # Terms checkbox
agent-browser click @e21

# Verify confirmation
agent-browser get title
agent-browser get text @e25
```

## Example 2: Data Scraping with Pagination

```bash
# Navigate to listing page
agent-browser open "https://example.com/items"

# Loop through pages
for page in {1..5}; do
  # Snapshot current page
  agent-browser snapshot -i > page_$page.txt

  # Extract item data
  for elem in $(seq 1 20); do
    ref="@e$elem"
    agent-browser get text $ref
  done

  # Click next page
  agent-browser snapshot -i
  agent-browser click @next

  # Wait for page load
  sleep 2
done

agent-browser close
```

## Example 3: Dynamic Content Interaction

```bash
# Open SPA application
agent-browser open "https://app.example.com/dashboard"

# Wait for initial load
agent-browser snapshot -i

# Trigger dynamic content
agent-browser click @e5  # Tab switch

# Wait for content update
sleep 1
agent-browser snapshot -i

# Verify new content loaded
agent-browser get text @e10

# Interact with dynamic table
agent-browser click @e15  # Sort column
sleep 0.5
agent-browser snapshot -i

# Filter table
agent-browser fill @e20 "search term"
agent-browser press Enter
sleep 1
agent-browser snapshot -i

# Export filtered results
agent-browser get text @e25 > filtered_results.txt
```

## Example 4: File Upload and Download

```bash
# Open upload page
agent-browser open "https://example.com/upload"

# Select file for upload
agent-browser snapshot -i
agent-browser upload @e5 /path/to/file.pdf

# Verify upload preview
agent-browser snapshot -i
agent-browser get attr @e10 src

# Submit upload
agent-browser click @e15

# Wait for processing
sleep 3

# Download result
agent-browser snapshot -i
agent-browser click @download_btn

# Verify download completed
agent-browser get text @e20
```
