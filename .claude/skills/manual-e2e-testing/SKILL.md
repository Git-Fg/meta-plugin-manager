---
name: manual-e2e-testing
description: This skill should be used when the user asks to "test Flutter app", "perform E2E testing", "validate element states", "verify text content programmatically", or needs guidance on Appium MCP and Dart MCP testing workflows with hot reload and widget tree analysis capabilities.
user-invocable: true
---

# Manual E2E Testing with Appium & Dart MCP

## What This Skill Does
Provides systematic procedures for manual E2E testing using text-first validation instead of screenshots. Integrates Appium MCP for element interaction with Dart MCP for widget tree analysis, runtime error diagnosis, and hot reload capabilities.

## When to Use
- Testing Flutter app interactions without visual analysis
- Validating UI state changes through text content
- Verifying element presence and accessibility
- Validating recording workflows, settings configuration, and navigation flows
- Executing element-based test procedures (not visual testing)

## Core Philosophy: Text-First Testing

### Why Avoid Screenshots?
- Vision LLMs are unreliable for precise UI validation
- Visual changes break tests unnecessarily
- Hard to verify logical state changes
- **Text and properties are more reliable**
- **Element states are programmatically verifiable**

### Core Principles
1. **Text Content Verification** - Verify visible text matches expected content
2. **Element State Checks** - Confirm enabled/disabled/visible states
3. **Attribute Validation** - Check data attributes, IDs, accessibility labels
4. **List Enumeration** - Verify expected elements exist in collections
5. **Navigation Flow** - Validate page transitions via element presence

## Dual MCP Architecture

### Appium MCP + Dart MCP Integration

**Appium MCP** handles:
- Element discovery and interaction on the device/emulator
- UI state verification through programmatic access
- Text content retrieval and validation
- Scrolling and gesture simulation

**Dart MCP** handles:
- Widget tree introspection and analysis
- Runtime error diagnosis and stack traces
- Hot reload capabilities for faster iteration
- App state inspection and debugging

### Best Combined Workflow
1. **Pre-Test Setup**: Connect to Dart Tooling Daemon + Create Appium session
2. **Widget Analysis**: Use `get_widget_tree` to understand UI hierarchy
3. **Element Discovery**: Use Appium `appium_find_element` for interaction
4. **State Validation**: Combine Appium text checks with Dart runtime analysis
5. **Error Diagnosis**: Use `get_runtime_errors` when issues occur
6. **Hot Reload**: Use Dart MCP for rapid iteration during test development

## Pre-Test Setup Workflow

### Step 1: Verify Emulator
```bash
adb devices
```
- Ensure device shows as "device" (not "offline" or "unauthorized")
- If no device: `emulator -avd <device_name>`

### Step 2: Clear App Data
```bash
adb shell pm clear com.voicenoteplus.app
```
- Ensures clean state for testing

### Step 3: Connect to Dart Tooling Daemon
- Use `mcp__dart__connect_dart_tooling_daemon` to enable:
  - Hot reload capabilities
  - Widget tree introspection
  - Runtime error analysis
  - App state debugging

### Step 4: Launch Flutter App
- Ensure Flutter app is running: `flutter run`
- Note the DTD URI from the connection

### Step 5: Create Appium Session
- Use `mcp__appium-mcp__select_platform` with platform: `android`
- Use `mcp__appium-mcp__create_session` with capabilities:
  - platformVersion: "14"
  - deviceName: your_emulator_name
  - automationName: "UiAutomator2"

### Step 6: Verify App Launch
- Tool: `mcp__appium-mcp__appium_find_element`
- Strategy: `id`, Selector: `com.voicenoteplus.app:id/dashboard`
- Expected: Element found (app launched successfully)
- Cross-verify: `mcp__dart__get_widget_tree` should show active widgets

## Element Discovery Strategies

### Priority Order
1. **Resource IDs** (most stable)
   - Example: `com.voicenoteplus.app:id/record_button`
   - Use when available
2. **Accessibility IDs** (second most stable)
   - Example: `Record`, `Settings`, `Save`
   - Good fallback when IDs not available
3. **Class names** (moderately stable)
   - Example: `android.widget.Button`
   - Use for general element types
4. **XPath** (least stable, use as last resort)
   - Example: `//*[contains(@content-desc, "Record")]`
   - Fragile, avoid unless necessary

**For comprehensive element discovery patterns**, see [element-discovery.md](references/element-discovery.md)

## Content Validation Techniques

### Appium Text Content Verification
```bash
mcp__appium-mcp__appium_get_text
  elementUUID: [from discovery]
```
- Verify button text contains "Record" or "🎤"
- Check transcription area is empty initially
- Verify state changes (Record → Stop)

### Appium Element State Checks
```bash
mcp__appium-mcp__appium_get_element_attribute
  elementUUID: [from discovery]
  attribute: enabled
```
- Check `enabled` attribute: expects `true`
- Check `displayed` attribute: expects `true`

### Appium Page Source Analysis
```bash
mcp__appium-mcp__appium_get_page_source
```
- Search for patterns: `note_item_`
- Count occurrences
- Verify expected number of elements
- Search for status messages: `Transcribing...`

### Dart Widget Tree Analysis
```bash
mcp__dart__get_widget_tree
  summaryOnly: false
```
- Extract complete widget hierarchy
- Identify widget types and properties
- Verify layout structure matches expectations
- Analyze widget tree depth and composition

### Dart Runtime Error Analysis
```bash
mcp__dart__get_runtime_errors
  clearRuntimeErrors: true
```
- Check for runtime exceptions before test execution
- Analyze stack traces for crash diagnosis
- Verify no errors present during UI interactions

**For detailed state validation workflows**, see [state-validation.md](references/state-validation.md)

## Test Procedures Overview

### Procedure 1: Basic Interaction Test
1. Pre-check: Runtime errors with `mcp__dart__get_runtime_errors`
2. Widget tree analysis with `mcp__dart__get_widget_tree`
3. Find record button (accessibility id: `Record`)
4. Verify initial state (Appium + Dart)
5. Tap record button
6. Wait for state change (2 seconds)
7. Verify state changed (Appium + Dart)

### Procedure 2: Complete Recording Workflow
1. Start recording (find `record_fab` by ID, click)
2. Verify recording indicator (Appium + Dart)
3. Simulate audio capture (wait 5 seconds)
4. Monitor runtime state with Dart MCP
5. Stop recording
6. Verify transcription (Appium + Dart)
7. Verify magic toolbar (Appium + Dart)

### Procedure 3: Settings Configuration
1. Navigate to settings (Appium + Dart verification)
2. Verify API key field (Appium + Dart)
3. Input API key
4. Verify input (Appium + Dart)
5. Save settings
6. Verify success message
7. Post-save validation with Dart MCP

**For complete detailed procedures**, see [detailed-procedures.md](references/detailed-procedures.md)

## Error Handling & Recovery

### Retry Pattern
- **Attempt 1**: Try immediately
- **If fails**: Wait 1 second, retry
- **If fails**: Wait 2 seconds, retry
- **If fails**: Wait 4 seconds, retry
- **After 3 attempts**: Report failure

### Fallback Strategy Chain
1. Try ID-based discovery
2. Try accessibility-based discovery
3. Try class-based discovery
4. Try XPath as last resort
5. Report which strategy succeeded

### State Verification
- **Before action**: Verify element present
- **During action**: Monitor state changes
- **After action**: Verify expected state
- **If state incorrect**: Retry or report failure

**For comprehensive error recovery patterns**, see [error-recovery.md](references/error-recovery.md)

## Best Practices

### Before Testing
- ✅ Verify emulator running: `adb devices`
- ✅ Clear app data: `adb shell pm clear com.voicenoteplus.app`
- ✅ Connect to Dart Tooling Daemon early for hot reload
- ✅ Launch Flutter app and note DTD URI
- ✅ Create Appium session with correct capabilities
- ✅ Check runtime errors: `mcp__dart__get_runtime_errors`
- ✅ Get initial widget tree: `mcp__dart__get_widget_tree`
- ✅ Check device logs: `adb logcat | grep -i error`

### During Testing
- ✅ Always verify element presence before interaction (Appium)
- ✅ Cross-verify widget state with Dart MCP
- ✅ Use text content for validation (not visual)
- ✅ Implement retry logic for flaky elements
- ✅ Log every step with timestamps
- ✅ Verify state changes after each action (both Appium & Dart)
- ✅ Use accessibility IDs when available (Appium)
- ✅ Use hot reload for rapid iteration: `mcp__dart__hot_reload`
- ✅ Check runtime errors periodically: `mcp__dart__get_runtime_errors`
- ✅ Use `mcp__dart__get_app_logs` to capture Flutter output

### After Testing
- ✅ Delete Appium session: `mcp__appium-mcp__delete_session`
- ✅ Check final runtime errors: `mcp__dart__get_runtime_errors`
- ✅ Save test execution log with timestamps
- ✅ Check device logs for errors
- ✅ Document issues found
- ✅ Save final widget tree for reference

## Common Pitfalls to Avoid

### ❌ Don't Use
- Screenshots for validation (unreliable without vision LLM)
- Hard-coded pixel coordinates
- Visual color/position assertions
- Unstable XPath expressions
- Timing sleeps (use state checks instead)

### ✅ Do Use
- Text content verification
- Element attribute checks
- State-based waiting (not time-based)
- Accessibility IDs for reliability
- Page source text search
- Structured logging

## Essential MCP Tools Reference

### Appium MCP Tools

#### Element Discovery
- `mcp__appium-mcp__appium_find_element` - Locate element on screen
  - Required: strategy (id/accessibility/class/xpath), selector
  - Returns: Element UUID if found, null if not found

#### Content Retrieval
- `mcp__appium-mcp__appium_get_text` - Read text content from element
  - Required: elementUUID
  - Returns: Text string from element

#### Element Interaction
- `mcp__appium-mcp__appium_click` - Tap/click element
  - Required: elementUUID
  - Returns: Success confirmation

#### Text Input
- `mcp__appium-mcp__appium_set_value` - Enter text into input field
  - Required: elementUUID, text
  - Returns: Success confirmation

#### Page Analysis
- `mcp__appium-mcp__appium_get_page_source` - Get XML representation
  - Returns: Full page source as string
  - Use for: Text search, element counting, structure analysis

#### Scrolling
- `mcp__appium-mcp__appium_scroll` - Scroll screen up or down
  - Required: direction (up/down)
  - Returns: Success confirmation

#### Long Press
- `mcp__appium-mcp__appium_long_press` - Press and hold element
  - Required: elementUUID, duration (milliseconds)
  - Returns: Success confirmation

### Dart MCP Tools

#### Widget Tree Analysis
- `mcp__dart__get_widget_tree` - Get complete widget hierarchy
  - Optional: summaryOnly (default: false)
  - Returns: Full widget tree structure
  - Use for: Layout analysis, widget verification, debugging

#### Runtime Error Analysis
- `mcp__dart__get_runtime_errors` - Retrieve runtime exceptions
  - Optional: clearRuntimeErrors (default: false)
  - Returns: List of runtime errors with stack traces
  - Use for: Crash diagnosis, error monitoring, validation

#### Widget Selection
- `mcp__dart__get_selected_widget` - Inspect focused widget
  - Returns: Currently selected widget details
  - Use for: State verification, debugging focused elements

#### Hot Reload
- `mcp__dart__hot_reload` - Apply code changes without restart
  - Optional: clearRuntimeErrors (default: false)
  - Returns: Success confirmation
  - Use for: Rapid iteration during test development

#### Hot Restart
- `mcp__dart__hot_restart` - Restart app state with code changes
  - Returns: Success confirmation
  - Use for: State reset with updated code

#### App Logs
- `mcp__dart__get_app_logs` - Retrieve Flutter app output
  - Optional: maxLines (default: 500), pid
  - Returns: Flutter console output
  - Use for: Debug output capture, error analysis

#### Device Management
- `mcp__dart__list_devices` - List available devices
  - Returns: List of connected devices/emulators
  - Use for: Device selection and verification

## Additional Resources
**For complete test procedures**, see [detailed-procedures.md](references/detailed-procedures.md)

**For element discovery strategies**, see [element-discovery.md](references/element-discovery.md)

**For state validation techniques**, see [state-validation.md](references/state-validation.md)

**For error recovery patterns**, see [error-recovery.md](references/error-recovery.md)

**For documentation templates**, see [test-reports.md](references/test-reports.md)
