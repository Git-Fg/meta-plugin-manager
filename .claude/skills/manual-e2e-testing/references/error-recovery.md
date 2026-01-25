# Error Handling & Recovery Patterns

Systematic approaches to handle failures and recover from errors during testing.

## Pattern 1: Retry with Backoff

**Purpose:** Automatically retry failed operations with increasing delays

### Steps:

1. **Attempt operation**
   - Try: Element discovery or interaction
   - If success: Return result
   - If failure: Continue to step 2

2. **Wait before retry**
   - Wait: 1 second (first retry)
   - Log: Record attempt number and failure

3. **Retry operation**
   - Try same operation again
   - If success: Return result
   - If failure: Continue to step 4

4. **Increase wait time**
   - Wait: 2 seconds (second retry)
   - Log: Record attempt number

5. **Retry again**
   - Try same operation
   - If success: Return result
   - If failure: Continue to step 6

6. **Final attempt**
   - Wait: 4 seconds (third retry)
   - Try operation one last time
   - If success: Return result
   - If failure: Report final failure

### Example Usage:

**Find record button with retry:**
```bash
# Attempt 1: Immediate
result = mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Record
if result found:
  return result

# Wait 1 second (retry 1)
sleep 1

# Attempt 2
result = mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Record
if result found:
  return result

# Wait 2 seconds (retry 2)
sleep 2

# Attempt 3
result = mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Record
if result found:
  return result

# Wait 4 seconds (retry 3)
sleep 4

# Final attempt
result = mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Record
if result found:
  return result
else:
  report_failure("Element not found after 4 attempts")
```

### Retry Pattern Code Template

```python
def find_element_with_retry(strategy, selector, max_attempts=3):
    """Find element with exponential backoff retry."""
    attempt = 0
    wait_times = [1, 2, 4]  # Exponential backoff

    while attempt < max_attempts:
        try:
            result = mcp__appium-mcp__appium_find_element(
                strategy=strategy,
                selector=selector
            )
            if result:
                print(f"✓ Element found on attempt {attempt + 1}")
                return result
        except Exception as e:
            print(f"✗ Attempt {attempt + 1} failed: {e}")

        if attempt < max_attempts - 1:
            wait_time = wait_times[attempt]
            print(f"  Waiting {wait_time}s before retry...")
            sleep(wait_time)

        attempt += 1

    print(f"✗ Element not found after {max_attempts} attempts")
    return None

# Usage
element = find_element_with_retry(
    strategy="accessibility id",
    selector="Record"
)
```

## Pattern 2: Fallback Strategy Chain

**Purpose:** Try multiple element discovery strategies sequentially

### Steps:

1. **Try primary strategy (ID)**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/record_button`
   - If found: Return element, stop here
   - If not found: Continue to step 2

2. **Try secondary strategy (Accessibility)**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `accessibility id`
   - Selector: `Record`
   - If found: Return element, stop here
   - If not found: Continue to step 3

3. **Try tertiary strategy (XPath)**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `xpath`
   - Selector: `//*[contains(@content-desc, "Record")]`
   - If found: Return element
   - If not found: Report element not found with any strategy

### Example Usage:

**Searching for record button:**
```bash
# Strategy 1: Try ID
element = mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/record_fab
if element found:
  print("✓ Found via ID strategy")
  return element

# Strategy 2: Try accessibility
element = mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Record
if element found:
  print("✓ Found via accessibility strategy")
  return element

# Strategy 3: Try class
element = mcp__appium-mcp__appium_find_element
  Strategy: class name
  Selector: android.widget.FloatingActionButton
if element found:
  print("✓ Found via class strategy")
  return element

# Strategy 4: Try XPath
element = mcp__appium-mcp__appium_find_element
  Strategy: xpath
  Selector: //*[@content-desc="Record"]
if element found:
  print("✓ Found via XPath strategy")
  return element

# All strategies failed
print("✗ Element not found with any strategy")
report_failure("Record button not found")
```

### Fallback Strategy Code Template

```python
def find_element_with_fallback(selectors):
    """Find element using multiple strategies."""
    strategies = [
        ("id", "Resource ID"),
        ("accessibility id", "Accessibility ID"),
        ("class name", "Class Name"),
        ("xpath", "XPath")
    ]

    for (strategy, name), (selector, description) in zip(strategies, selectors):
        try:
            result = mcp__appium-mcp__appium_find_element(
                strategy=strategy,
                selector=selector
            )
            if result:
                print(f"✓ Found via {name}: {description}")
                return result
            else:
                print(f"✗ Not found via {name}: {description}")
        except Exception as e:
            print(f"✗ Error with {name}: {e}")

    print("✗ Element not found with any strategy")
    return None

# Usage
element = find_element_with_fallback([
    ("com.voicenoteplus.app:id/record_fab", "Record FAB by ID"),
    ("Record", "Record by accessibility label"),
    ("android.widget.FloatingActionButton", "FAB by class"),
    ("//*[@content-desc='Record']", "Record by XPath")
])
```

## Pattern 3: State Recovery

**Purpose:** Recover when app state is unexpected

### Common State Issues

**App Crashed:**
```bash
# Detect crash
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/dashboard
# Expected: Element found
# If not found: App may have crashed

# Recovery: Restart app
adb shell am start -n com.voicenoteplus.app/.MainActivity

# Wait for app to load
sleep 3

# Verify recovery
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/dashboard
# Expected: Element found (app restarted)
```

**Wrong Screen Displayed:**
```bash
# Detect wrong screen
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/dashboard
# Expected: Element found
# If not found: Not on dashboard

# Recovery: Navigate to correct screen
# Option 1: Use back button
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Back
# If found:
mcp__appium-mcp__appium_click
  elementUUID: [from find]

# Option 2: Navigate from menu
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Dashboard
mcp__appium-mcp__appium_click
  elementUUID: [from find]

# Verify navigation
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/dashboard
# Expected: Element found
```

**Element Not Ready:**
```bash
# Detect element not ready
element = mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/transcription_text
if element found:
  # Check if content is ready
  text = mcp__appium-mcp__appium_get_text
    elementUUID: element
  if text is None or text == "":
    # Content not ready
    print("Content not ready, waiting...")

    # Recovery: Wait for content
    sleep 5

    # Try again
    text = mcp__appium-mcp__appium_get_text
      elementUUID: element
    if text and text != "":
      print("✓ Content ready")
    else:
      print("✗ Content still not ready")
```

## Pattern 4: Network/API Error Recovery

**Purpose:** Handle API failures and network issues

### Detection:

```bash
# Check for error messages
mcp__appium-mcp__appium_get_page_source
# Search for: "Error", "Failed", "Network", "API"
# If found: API/network error occurred
```

### Recovery Strategies:

**API Key Invalid:**
```bash
# Detect invalid API key
mcp__appium-mcp__appium_get_page_source
# Search for: "Invalid API key", "Unauthorized"
# If found:

# Recovery: Update API key
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Settings
mcp__appium-mcp__appium_click
  elementUUID: [from find]

mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/api_key_input
mcp__appium-mcp__appium_set_value
  elementUUID: [from find]
  text: [new-valid-api-key]

mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Save
mcp__appium-mcp__appium_click
  elementUUID: [from find]
```

**Network Timeout:**
```bash
# Detect timeout
mcp__appium-mcp__appium_get_page_source
# Search for: "Timeout", "Network error", "Connection failed"
# If found:

# Recovery: Retry operation
sleep 3  # Wait before retry

# Try action again
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Summary
mcp__appium-mcp__appium_click
  elementUUID: [from find]

# Wait longer for response
sleep 10

# Verify success
mcp__appium-mcp__appium_get_page_source
# Search for: "Summary:" content
# If found: Recovery successful
```

**Quota Exceeded:**
```bash
# Detect quota issue
mcp__appium-mcp__appium_get_page_source
# Search for: "Quota exceeded", "Rate limit"
# If found:

# Recovery: Wait and retry
print("Quota exceeded, waiting 60 seconds...")
sleep 60

# Try action again
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Todo
mcp__appium-mcp__appium_click
  elementUUID: [from find]

sleep 5

# Verify success
mcp__appium-mcp__appium_get_page_source
# Search for: Todo content
# If found: Recovery successful
```

## Pattern 5: Session Recovery

**Purpose:** Recover from broken Appium sessions

### Detection:

```bash
# Try simple operation
try:
  mcp__appium-mcp__appium_find_element
    Strategy: id
    Selector: com.voicenoteplus.app:id/dashboard
except Exception as e:
  # Session likely broken
  print(f"Session error: {e}")
```

### Recovery:

```bash
# Delete broken session
mcp__appium-mcp__delete_session

# Recreate session
mcp__appium-mcp__create_session
  platform: android
  capabilities:
    platformVersion: "14"
    deviceName: [device-name]
    automationName: "UiAutomator2"

# Wait for session ready
sleep 3

# Verify session
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/dashboard
# Expected: Element found (session recovered)
```

## Pattern 6: Comprehensive Recovery Template

```python
def execute_with_recovery(test_step, max_retries=3):
    """Execute test step with full recovery."""
    attempt = 0
    wait_times = [1, 2, 4]

    while attempt < max_retries:
        try:
            # Check session health
            session_healthy = check_session()
            if not session_healthy:
                print("Session broken, recovering...")
                recover_session()
                sleep(2)

            # Check app state
            app_healthy = check_app_state()
            if not app_healthy:
                print("App state invalid, recovering...")
                recover_app_state()
                sleep(2)

            # Execute test step
            result = test_step()

            if result:
                print(f"✓ Step succeeded on attempt {attempt + 1}")
                return result
            else:
                print(f"✗ Step failed on attempt {attempt + 1}")

        except Exception as e:
            print(f"✗ Exception on attempt {attempt + 1}: {e}")

        if attempt < max_retries - 1:
            wait_time = wait_times[attempt]
            print(f"  Waiting {wait_time}s before retry...")
            sleep(wait_time)

        attempt += 1

    print(f"✗ Step failed after {max_retries} attempts")
    raise Exception(f"Test step failed after {max_retries} retries")

# Usage
try:
    result = execute_with_recovery(lambda: test_recording_workflow())
    print("✓ Test completed successfully")
except Exception as e:
    print(f"✗ Test failed: {e}")
    report_failure(str(e))
```

## Error Recovery Best Practices

### Before Testing:
- [ ] Verify emulator stable
- [ ] Clear app data for clean state
- [ ] Create fresh Appium session
- [ ] Check device logs for errors

### During Testing:
- [ ] Use retry logic for flaky operations
- [ ] Implement fallback strategies
- [ ] Check session health periodically
- [ ] Monitor app state after each action

### After Failure:
- [ ] Try recovery strategies
- [ ] Log all recovery attempts
- [ ] Document what worked
- [ ] Report final status

### Recovery Priorities:
1. **Session Recovery** - Restore Appium connection
2. **App State Recovery** - Get app back to known state
3. **Element Recovery** - Find elements using fallbacks
4. **Action Recovery** - Retry failed actions

### Common Recovery Commands:
```bash
# Restart app
adb shell am force-stop com.voicenoteplus.app
adb shell am start -n com.voicenoteplus.app/.MainActivity

# Clear app data
adb shell pm clear com.voicenoteplus.app

# Recreate Appium session
mcp__appium-mcp__delete_session
mcp__appium-mcp__create_session (with capabilities)

# Check logs
adb logcat | grep -i "error\|exception\|fatal"
```

### Recovery Success Criteria:
- [ ] Element discovery succeeds
- [ ] App responds to interactions
- [ ] No error messages visible
- [ ] Expected content displays
- [ ] Session remains stable
