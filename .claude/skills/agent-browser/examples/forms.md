# Form Interaction

## Navigation

| If you need... | Read this section... |
| :------------- | :------------------- |
| Basic form filling | ## Basic Form |
| Form validation testing | ## Form Validation Test |

Form filling, validation, and submission patterns.

## Basic Form

```bash
agent-browser open "https://example.com/form"
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
agent-browser close
```

## Form Validation Test

```bash
agent-browser open "http://localhost:3000"
agent-browser snapshot -i
agent-browser click @e1  # Navigate link
agent-browser get title  # Verify page changed

# Test form validation
agent-browser back
agent-browser fill @e2 ""  # Empty required field
agent-browser click @e3  # Submit button
agent-browser snapshot -i  # Check for error message

agent-browser close
```
