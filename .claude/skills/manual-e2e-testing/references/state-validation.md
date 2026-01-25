# State Validation Techniques

Systematic approaches to verify UI state changes and element properties.

## Validation 1: Element Presence

**Purpose:** Verify element exists on screen

### Steps:

1. **Attempt to find element**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: provided
   - Selector: provided
   - If element found: Return true (element present)
   - If element not found: Return false (element absent)

2. **Example: Check recording indicator**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/recording_indicator`
   - If found: Recording indicator is visible
   - If not found: Recording indicator is NOT visible (test may fail)

**Usage:** Use before interacting with element to ensure it's available

### Common Presence Checks

**Dashboard Elements:**
```bash
# Verify record button exists
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Record
# Expected: Element found

# Verify settings button exists
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Settings
# Expected: Element found
```

**Recording State Elements:**
```bash
# Verify recording indicator
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/recording_indicator
# Expected: Element found when recording

# Verify stop button appears
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Stop
# Expected: Element found during recording
```

**Detail View Elements:**
```bash
# Verify audio player
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/audio_player
# Expected: Element found

# Verify magic toolbar
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/magic_toolbar
# Expected: Element found
```

## Validation 2: Text Content Matching

**Purpose:** Verify specific text appears on screen

### Steps:

1. **Get page source**
   - Tool: `mcp__appium-mcp__appium_get_page_source`
   - Returns: XML representation of screen

2. **Search for text**
   - Search in returned XML for: `Transcribing...`
   - If found: Text is present on screen
   - If not found: Text is NOT present

3. **Example: Check transcribing status**
   - Tool: `mcp__appium-mcp__appium_get_page_source`
   - Search for: `Transcribing...`
   - If found: App shows transcribing status
   - If not found: Transcribing may be complete or not started

**Usage:** Verify status messages, confirm actions completed

### Common Text Validations

**Button State Text:**
```bash
# Verify initial state
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Record
mcp__appium-mcp__appium_get_text
  elementUUID: [from find]
# Expected: Text contains "Record" or "🎤"

# Verify recording state
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Stop
mcp__appium-mcp__appium_get_text
  elementUUID: [from find]
# Expected: Text contains "Stop" or "⏹️"
```

**Status Messages:**
```bash
# Check transcribing status
mcp__appium-mcp__appium_get_page_source
# Search for: "Transcribing..."
# Expected: Text found during transcription

# Check error messages
mcp__appium-mcp__appium_get_page_source
# Search for: "Error" or "Failed"
# Expected: None for successful operations

# Check success messages
mcp__appium-mcp__appium_get_page_source
# Search for: "Settings saved" or "Success"
# Expected: Text found after successful save
```

**Content Verification:**
```bash
# Verify transcription content
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/transcription_text
mcp__appium-mcp__appium_get_text
  elementUUID: [from find]
# Expected: Non-empty text string

# Verify summary content
mcp__appium-mcp__appium_get_page_source
# Search for: "Summary:" or generated summary text
# Expected: Summary content found
```

## Validation 3: Count Verification

**Purpose:** Verify correct number of elements in list/collection

### Steps:

1. **Get page source**
   - Tool: `mcp__appium-mcp__appium_get_page_source`
   - Returns: XML with all elements

2. **Count matching elements**
   - Search for pattern: `note_item_`
   - Count all occurrences
   - Return count

3. **Example: Verify note list count**
   - Tool: `mcp__appium-mcp__appium_get_page_source`
   - Search pattern: `note_item_`
   - Expected count: 3
   - If actual count = 3: List has correct number of items
   - If actual count ≠ 3: List count mismatch (test may fail)

**Usage:** Verify list contents, confirm all items loaded

### Common Count Validations

**Note List Count:**
```bash
# Get page source
mcp__appium-mcp__appium_get_page_source
# Search for: "note_item_"
# Count occurrences
# Expected: Match number of notes displayed

# Alternative: Count by ID pattern
mcp__appium-mcp__appium_get_page_source
# Search for: "com.voicenoteplus.app:id/note_item"
# Count occurrences
# Expected: Number of list items
```

**Magic Toolbar Buttons:**
```bash
# Count toolbar buttons
mcp__appium-mcp__appium_get_page_source
# Search for: "Summary", "Todo", "Blueprint"
# Count unique buttons
# Expected: 3 buttons present

# Verify each button individually
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Summary
# Expected: Found

mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Todo
# Expected: Found

mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Blueprint
# Expected: Found
```

**Settings Fields:**
```bash
# Count input fields
mcp__appium-mcp__appium_get_page_source
# Search for: "android.widget.EditText"
# Count occurrences
# Expected: At least 1 (API key field)

# Count buttons
mcp__appium-mcp__appium_get_page_source
# Search for: "android.widget.Button"
# Count occurrences
# Expected: At least 2 (Save, Cancel)
```

## Validation 4: Element Attribute Checks

**Purpose:** Verify specific element properties

### Attributes to Check

**Enabled State:**
```bash
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [uuid]
  attribute: enabled
# Expected: "true" for clickable elements
# Expected: "false" for disabled elements
```

**Displayed State:**
```bash
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [uuid]
  attribute: displayed
# Expected: "true" for visible elements
# Expected: "false" for hidden elements
```

**Clickable State:**
```bash
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [uuid]
  attribute: clickable
# Expected: "true" for tappable elements
# Expected: "false" for non-interactive elements
```

**Focusable State:**
```bash
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [uuid]
  attribute: focusable
# Expected: "true" for input fields
# Expected: "false" for display-only elements
```

**Selected State:**
```bash
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [uuid]
  attribute: selected
# Expected: "true" for active/selected elements
# Expected: "false" for inactive elements
```

### Common Attribute Validations

**Record Button Attributes:**
```bash
# Find button
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Record

# Check enabled state
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [from find]
  attribute: enabled
# Expected: "true"

# Check displayed state
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [from find]
  attribute: displayed
# Expected: "true"

# Check clickable state
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [from find]
  attribute: clickable
# Expected: "true"
```

**Input Field Attributes:**
```bash
# Find API key field
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/api_key_input

# Check focusable state
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [from find]
  attribute: focusable
# Expected: "true"

# Check enabled state
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [from find]
  attribute: enabled
# Expected: "true"
```

## Validation 5: State Change Verification

**Purpose:** Confirm UI updates after actions

### Before/After Comparison Pattern

**Record Button State Change:**
```bash
# Step 1: Get initial state
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Record
initialText = mcp__appium-mcp__appium_get_text
  elementUUID: [from find]

# Step 2: Perform action
mcp__appium-mcp__appium_click
  elementUUID: [from find]

# Step 3: Wait for state change
sleep 2 seconds

# Step 4: Get new state
finalText = mcp__appium-mcp__appium_get_text
  elementUUID: [from find]

# Step 5: Verify change
# Expected: initialText contains "Record"
# Expected: finalText contains "Stop"
```

**Loading State Verification:**
```bash
# Step 1: Trigger action
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Summary
mcp__appium-mcp__appium_click
  elementUUID: [from find]

# Step 2: Check loading indicator
mcp__appium-mcp__appium_get_page_source
# Search for: "Generating..." or "Processing..."
# Expected: Loading message found

# Step 3: Wait for completion
sleep 5 seconds

# Step 4: Verify result
mcp__appium-mcp__appium_get_page_source
# Search for: "Summary:" and actual summary text
# Expected: Summary content found
# Expected: Loading message gone
```

**Navigation State Verification:**
```bash
# Step 1: Verify initial screen
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/dashboard
# Expected: Found (dashboard visible)

# Step 2: Navigate
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/note_item_0
mcp__appium-mcp__appium_click
  elementUUID: [from find]

# Step 3: Verify new screen
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/detail_view
# Expected: Found (detail view visible)

# Step 4: Verify old screen gone
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/dashboard
# Expected: Not found (dashboard hidden)
```

## Validation 6: Content Generation Verification

**Purpose:** Verify AI-generated content appears

### Transcription Verification

```bash
# Step 1: Record and stop recording
# (Previous steps in recording workflow)

# Step 2: Wait for transcription
sleep 5 seconds

# Step 3: Find transcription area
mcp__appium-mcp__appium_find_element
  Strategy: id
  Selector: com.voicenoteplus.app:id/transcription_text

# Step 4: Get transcription text
transcription = mcp__appium-mcp__appium_get_text
  elementUUID: [from find]

# Step 5: Verify content
# Expected: Non-empty string
# Expected: Length > 10 characters
# Expected: Contains words (not just punctuation)
```

### Summary Verification

```bash
# Step 1: Trigger summary generation
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Summary
mcp__appium-mcp__appium_click
  elementUUID: [from find]

# Step 2: Wait for generation
sleep 3 seconds

# Step 3: Search for summary
mcp__appium-mcp__appium_get_page_source
# Search for: "Summary:" or similar header
# Expected: Summary header found

# Step 4: Verify summary content
# Search for: Generated summary text
# Expected: Non-trivial content (not just header)
```

### Todo Verification

```bash
# Step 1: Trigger todo generation
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Todo
mcp__appium-mcp__appium_click
  elementUUID: [from find]

# Step 2: Wait for generation
sleep 3 seconds

# Step 3: Search for todo items
mcp__appium-mcp__appium_get_page_source
# Search for: checkbox items or bullet points
# Expected: Todo list items found
```

### Blueprint Verification

```bash
# Step 1: Trigger blueprint generation
mcp__appium-mcp__appium_find_element
  Strategy: accessibility id
  Selector: Blueprint
mcp__appium-mcp__appium_click
  elementUUID: [from find]

# Step 2: Wait for generation
sleep 3 seconds

# Step 3: Search for blueprint content
mcp__appium-mcp__appium_get_page_source
# Search for: structured text, headings, or formatted content
# Expected: Blueprint structure found
```

## Validation Patterns Summary

### Quick Validation Checklist

**Before Interaction:**
- [ ] Element exists (find_element succeeds)
- [ ] Element is enabled (attribute: enabled = true)
- [ ] Element is displayed (attribute: displayed = true)
- [ ] Element is clickable (attribute: clickable = true)

**After Interaction:**
- [ ] State changed (text content updated)
- [ ] New elements appeared (find_element succeeds for new elements)
- [ ] Old elements gone (find_element fails for old elements)
- [ ] Loading states cleared (no "Processing..." messages)

**Content Generation:**
- [ ] Text is non-empty (length > 0)
- [ ] Text is meaningful (not just placeholder)
- [ ] Content matches expected type (summary, todo, blueprint)
- [ ] No error messages present

### State Validation Best Practices

1. **Always verify before acting**
   - Check element exists before clicking
   - Verify element enabled before interaction

2. **Wait for state changes**
   - Use sleep after actions (2-5 seconds)
   - Check state repeatedly if needed

3. **Compare before/after states**
   - Store initial state
   - Verify change occurred

4. **Use multiple validation methods**
   - Combine find, get_text, get_attribute
   - Cross-verify with page source

5. **Log state transitions**
   - Record before/after values
   - Helps debugging failed tests
