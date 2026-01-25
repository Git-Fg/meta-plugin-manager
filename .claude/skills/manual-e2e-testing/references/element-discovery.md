# Element Discovery Strategies

Comprehensive guide to finding and validating elements on mobile app screens.

## Strategy 1: Systematic Scanning

**Purpose:** Discover all interactive elements on current screen

### Steps:

1. **Scan for ID-based elements**
   - Tool: `mcp__appium-mcp__appium_get_page_source`
   - Search pattern: Resource IDs with prefix `com.voicenoteplus.app:id/`
   - Count: Number of ID-based elements found
   - Record: List of IDs found

2. **Scan for accessibility elements**
   - Tool: `mcp__appium-mcp__appium_get_page_source`
   - Search pattern: Elements with `content-desc` attribute
   - Count: Number of accessibility elements found
   - Record: List of accessibility labels

3. **Scan for class-based elements**
   - Tool: `mcp__appium-mcp__appium_get_page_source`
   - Search pattern: Class names like `android.widget.*`
   - Count: Number of class-based elements found
   - Record: List of class types

4. **Compile element list**
   - Combine all found elements
   - Remove duplicates
   - Create prioritized list (ID > accessibility > class)

## Strategy 2: Priority-Based Discovery

**Purpose:** Find specific element using reliable strategies first

**Element:** Record Button (example)

### Steps:

1. **Try ID-based discovery**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `record_fab`
   - If found: Record success, stop here
   - If not found: Continue to step 2

2. **Try accessibility-based discovery**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `accessibility id`
   - Selector: `Record`
   - If found: Record success, stop here
   - If not found: Continue to step 3

3. **Try class-based discovery**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `class name`
   - Selector: `android.widget.FloatingActionButton`
   - If found: Record success, stop here
   - If not found: Continue to step 4

4. **Try XPath as last resort**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `xpath`
   - Selector: `//*[contains(@content-desc, "Record")]`
   - If found: Record success
   - If not found: Element does not exist

### Priority Order:
1. Resource IDs (most stable)
2. Accessibility IDs (second most stable)
3. Class names (moderately stable)
4. XPath (least stable, use only as last resort)

## Common Element Patterns

### Record Button Variations
```bash
# By ID (preferred)
Strategy: id
Selector: com.voicenoteplus.app:id/record_fab

# By accessibility label
Strategy: accessibility id
Selector: Record

# By class (FAB)
Strategy: class name
Selector: android.widget.FloatingActionButton

# By content description
Strategy: xpath
Selector: //*[@content-desc="Record"]
```

### Settings Button Variations
```bash
# By accessibility label
Strategy: accessibility id
Selector: Settings

# By ID
Strategy: id
Selector: com.voicenoteplus.app:id/settings_button

# By class (menu item)
Strategy: class name
Selector: android.widget.TextView
```

### Text Input Fields
```bash
# By ID (API key field)
Strategy: id
Selector: com.voicenoteplus.app:id/api_key_input

# By class (edit text)
Strategy: class name
Selector: android.widget.EditText

# By hint text
Strategy: xpath
Selector: //*[@hint="API Key"]
```

### List Items
```bash
# By ID pattern
Strategy: id
Selector: com.voicenoteplus.app:id/note_item_

# By class
Strategy: class name
Selector: android.widget.LinearLayout

# Contains specific text
Strategy: xpath
Selector: //*[contains(@text, "Note Title")]
```

### Navigation Elements
```bash
# Back button
Strategy: accessibility id
Selector: Back

# By content description
Strategy: xpath
Selector: //*[@content-desc="Navigate up"]

# Home button
Strategy: accessibility id
Selector: Home
```

## Accessibility-Based Discovery

**Advantages:**
- Stable across UI updates
- Intuitive for testing
- Good for end-to-end validation

### Common Accessibility Labels

**Dashboard Screen:**
- `Record` - Main record button
- `Settings` - Settings navigation
- `History` - History/history view
- `Dashboard` - Main dashboard

**Detail View:**
- `Play` / `Pause` - Audio playback controls
- `Stop` - Recording stop button
- `Back` - Navigation back
- `Summary` - Magic toolbar button
- `Todo` - Magic toolbar button
- `Blueprint` - Magic toolbar button

**Settings Screen:**
- `Save` - Save settings button
- `Cancel` - Cancel changes
- `API Key` - API key input field
- `Test Connection` - Test API key button

### Best Practices for Accessibility Labels

1. **Use descriptive labels**
   - Good: `Record`, `Settings`, `Save`
   - Avoid: `Button1`, `Item2`, `Element3`

2. **Be consistent**
   - Use same label for same action throughout app
   - Don't use `Record` in one place and `Start Recording` in another

3. **Include state in label when appropriate**
   - Good: `Record` → `Stop`
   - Good: `Play` → `Pause`

## ID-Based Discovery

**Advantages:**
- Most reliable and stable
- Direct mapping to app code
- Fastest discovery method

### Common ID Patterns

**Flutter Generated IDs:**
- Format: `com.voicenoteplus.app:id/[widget_name]`
- Examples:
  - `record_fab`
  - `settings_button`
  - `api_key_input`
  - `transcription_text`
  - `magic_toolbar`
  - `recording_indicator`
  - `audio_player`
  - `dashboard`
  - `detail_view`

### Best Practices for IDs

1. **Always try ID first**
   - Most reliable discovery method
   - Fastest execution

2. **Use descriptive ID names**
   - Good: `record_fab`, `settings_button`
   - Avoid: `button1`, `element2`

3. **Check for dynamic IDs**
   - Some IDs may include indices: `note_item_0`, `note_item_1`
   - Use pattern matching or sequential discovery

## Class-Based Discovery

**Advantages:**
- Good for finding elements by type
- Useful when IDs not available
- Works for standard Android widgets

### Common Class Names

**Buttons:**
- `android.widget.Button`
- `android.widget.FloatingActionButton`
- `com.google.android.material.button.MaterialButton`

**Text Elements:**
- `android.widget.TextView`
- `android.widget.EditText`
- `com.google.android.material.textfield.TextInputEditText`

**Layout Elements:**
- `android.widget.LinearLayout`
- `android.widget.RelativeLayout`
- `android.widget.FrameLayout`
- `androidx.recyclerview.widget.RecyclerView`

**Lists:**
- `androidx.recyclerview.widget.RecyclerView`
- `android.widget.ListView`

### Best Practices for Class Names

1. **Use for general element types**
   - When ID not available
   - When testing element type presence

2. **Combine with other strategies**
   - Find all buttons: Class name
   - Then filter by ID or accessibility

3. **Be aware of library-specific classes**
- Material Design components have different classes
- Custom Flutter widgets may have unique classes

## XPath Discovery

**Disadvantages:**
- Slowest method
- Most fragile to UI changes
- Harder to maintain

**When to Use:**
- Last resort when other methods fail
- Finding elements with specific attributes
- Complex queries not possible with other strategies

### XPath Patterns

**By text content:**
```xpath
//*[@text="Record"]
//*[contains(@text, "Settings")]
//*[starts-with(@text, "Note")]
```

**By content description:**
```xpath
//*[@content-desc="Record"]
//*[contains(@content-desc, "Button")]
```

**By class and attribute:**
```xpath
//android.widget.Button[@enabled="true"]
//android.widget.EditText[@focusable="true"]
```

**Complex conditions:**
```xpath
//*[@id="record_fab" or @content-desc="Record"]
//android.widget.LinearLayout[@index="0"]
```

### Best Practices for XPath

1. **Use only as last resort**
   - Prefer ID, accessibility, class strategies
   - XPath breaks easily with UI changes

2. **Make XPath as specific as needed**
   - Don't use `//*` (matches everything)
   - Include element type and key attributes

3. **Avoid indexes when possible**
   - `@index` values change with UI modifications
   - Use stable attributes instead

## Discovery Verification

After finding element, always verify:

1. **Element is enabled**
```bash
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [uuid]
  attribute: enabled
```
- Expected: `true`

2. **Element is displayed**
```bash
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [uuid]
  attribute: displayed
```
- Expected: `true`

3. **Element is clickable**
```bash
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [uuid]
  attribute: clickable
```
- Expected: `true`

4. **Get element text (if applicable)**
```bash
mcp__appium-mcp__appium_get_text
  elementUUID: [uuid]
```
- Returns: Element's text content

## Troubleshooting Discovery Issues

### Element Not Found

**Check if element exists:**
```bash
mcp__appium-mcp__appium_get_page_source
```
- Search for element's text or ID
- Verify element is actually on screen

**Verify app state:**
- Check if correct screen is displayed
- Ensure app hasn't crashed
- Verify navigation completed successfully

**Try alternative strategies:**
1. Use different selector type
2. Try parent/child element discovery
3. Use page source to find element manually

### Multiple Elements Found

**When using class name:**
- Class names match multiple elements
- Use more specific selector
- Filter by position or attributes

**Solution:**
- Use ID if available
- Use accessibility label
- Add additional constraints to XPath

### Element Not Clickable

**Check element state:**
```bash
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [uuid]
  attribute: enabled
```
- If `false`: Element is disabled
- Check UI for reason (loading, permission, etc.)

**Check element visibility:**
```bash
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [uuid]
  attribute: displayed
```
- If `false`: Element not visible
- May need to scroll or navigate

**Check element focus:**
```bash
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [uuid]
  attribute: focusable
```
- If `false`: Element cannot receive focus
- May need to tap to focus first
