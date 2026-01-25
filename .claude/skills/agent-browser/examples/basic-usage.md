# Agent Browser - Basic Usage Examples

## Example 1: Web Search and Navigate

```bash
# Open SearX search engine
agent-browser open "https://searx.fmhy.net"

# Take snapshot to see interactive elements
agent-browser snapshot -i

# Find search input (typically @e1 or @e2)
# Fill in search term
agent-browser fill @e1 "Claude Code documentation"

# Submit search
agent-browser press Enter

# Wait for results, then snapshot
agent-browser snapshot -i

# Click first result
agent-browser click @e5

# Get page title
agent-browser get title
```

## Example 2: Form Filling

```bash
# Navigate to form
agent-browser open "https://example.com/form"

# Snapshot to find form fields
agent-browser snapshot -i

# Fill form fields
agent-browser fill @e1 "John Doe"
agent-browser fill @e2 "john@example.com"
agent-browser fill @e3 "Hello, this is a message"

# Select dropdown option
agent-browser select @e4 "Option B"

# Check checkbox
agent-browser check @e5

# Submit form
agent-browser click @e6

# Close browser
agent-browser close
```

## Example 3: Screenshot and Data Extraction

```bash
# Navigate to page
agent-browser open "https://example.com/data"

# Take full page snapshot
agent-browser snapshot

# Extract specific element text
agent-browser get text @e10

# Extract attribute value
agent-browser get attr @e10 href

# Get all links from page
agent-browser snapshot -c | grep "href:"
```

## Example 4: Page Interaction Testing

```bash
# Open test page
agent-browser open "http://localhost:3000"

# Test navigation
agent-browser snapshot -i
agent-browser click @e1  # Click nav link
agent-browser get title  # Verify page changed

# Test form validation
agent-browser back
agent-browser fill @e2 ""  # Empty required field
agent-browser click @e3  # Submit button
agent-browser snapshot -i  # Check for error message

# Close browser
agent-browser close
```
