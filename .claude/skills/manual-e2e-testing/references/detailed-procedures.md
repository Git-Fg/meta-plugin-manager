# Detailed Test Procedures

This document provides comprehensive step-by-step procedures for manual E2E testing.

## Test Procedure 1: Basic Interaction Test

**Test Name:** Basic Record Button Interaction

### Steps:

1. **Find record button**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `accessibility id`
   - Selector: `Record`
   - Expected: Element found with UUID

2. **Verify initial state**
   - Tool: `mcp__appium-mcp__appium_get_text`
   - Input: elementUUID from step 1
   - Expected: Text contains "Record" or "🎤"
   - If true, record initial state is correct

3. **Tap record button**
   - Tool: `mcp__appium-mcp__appium_click`
   - Input: elementUUID from step 1
   - Expected: Button click registered

4. **Wait for state change**
   - Wait: 2 seconds
   - Purpose: Allow UI to update

5. **Verify state changed**
   - Tool: `mcp__appium-mcp__appium_get_text`
   - Input: elementUUID from step 1
   - Expected: Text contains "Stop" or "⏹️"
   - If true, button state updated correctly

6. **Record test result**
   - If all steps pass: Test PASSED
   - If any step fails: Test FAILED (document failure)

## Test Procedure 2: Complete Recording Workflow

**Test Name:** Complete Recording Workflow

### Steps:

1. **Start recording**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/record_fab`
   - Tool: `mcp__appium-mcp__appium_click`
   - Input: elementUUID from find
   - Expected: Recording started

2. **Verify recording indicator**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/recording_indicator`
   - Expected: Element found (recording UI visible)

3. **Simulate audio capture**
   - Wait: 5 seconds
   - Purpose: Simulate user speaking

4. **Stop recording**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `accessibility id`
   - Selector: `Stop`
   - Tool: `mcp__appium-mcp__appium_click`
   - Input: elementUUID from find
   - Expected: Recording stopped

5. **Verify transcription appears**
   - Wait: 3 seconds (for processing)
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/transcription_text`
   - Tool: `mcp__appium-mcp__appium_get_text`
   - Input: elementUUID from find
   - Expected: Non-empty text (transcription generated)
   - If empty or null, transcription failed

6. **Verify magic toolbar**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/magic_toolbar`
   - Expected: Element found

7. **Record test result**
   - If all steps pass: Test PASSED
   - If transcription empty or toolbar missing: Test FAILED

## Test Procedure 3: Settings Configuration Test

**Test Name:** BYOK Settings Configuration

### Steps:

1. **Navigate to settings**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `accessibility id`
   - Selector: `Settings`
   - Tool: `mcp__appium-mcp__appium_click`
   - Input: elementUUID from find
   - Expected: Settings screen opens

2. **Verify API key field**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/api_key_input`
   - Expected: Element found
   - If not found, settings screen may not have loaded

3. **Input API key**
   - Tool: `mcp__appium-mcp__appium_set_value`
   - Input: elementUUID from step 2
   - Text: `test-api-key-12345`
   - Expected: Text entered in field

4. **Verify input**
   - Tool: `mcp__appium-mcp__appium_get_text`
   - Input: elementUUID from step 2
   - Expected: Text matches input (`test-api-key-12345`)
   - If mismatch, input failed

5. **Save settings**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `accessibility id`
   - Selector: `Save`
   - Tool: `mcp__appium-mcp__appium_click`
   - Input: elementUUID from find
   - Expected: Save action triggered

6. **Verify success message**
   - Wait: 2 seconds
   - Tool: `mcp__appium-mcp__appium_get_page_source`
   - Search: Look for "Settings saved" or similar
   - Expected: Success message present
   - If not found, save may have failed

7. **Record test result**
   - If all steps pass: Test PASSED
   - If save failed or message missing: Test FAILED

## Test Procedure 4: Navigation Flow Validation

**Test Name:** Dashboard to Detail View Navigation

### Steps:

1. **Verify dashboard screen**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/dashboard`
   - Expected: Element found

2. **Find note item**
   - Tool: `mcp__appium-mcp__appium_get_page_source`
   - Search: Pattern `note_item_`
   - Count occurrences
   - Expected: At least 1 note item exists

3. **Tap note item**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/note_item_0`
   - Tool: `mcp__appium-mcp__appium_click`
   - Input: elementUUID from find
   - Expected: Navigation to detail view

4. **Verify detail view**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/detail_view`
   - Expected: Element found

5. **Verify audio player**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/audio_player`
   - Expected: Element found

6. **Verify transcription text**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/transcription_text`
   - Tool: `mcp__appium-mcp__appium_get_text`
   - Input: elementUUID from find
   - Expected: Non-empty text

7. **Verify magic toolbar**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/magic_toolbar`
   - Expected: Element found

8. **Record test result**
   - If all steps pass: Test PASSED
   - If navigation fails or elements missing: Test FAILED

## Test Procedure 5: Magic Toolbar Functionality

**Test Name:** Magic Toolbar Button Actions

### Steps:

1. **Ensure in detail view**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/detail_view`
   - Expected: Element found

2. **Verify toolbar present**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `id`
   - Selector: `com.voicenoteplus.app:id/magic_toolbar`
   - Expected: Element found

3. **Test Summary button**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `accessibility id`
   - Selector: `Summary`
   - Tool: `mcp__appium-mcp__appium_click`
   - Expected: Summary action triggered

4. **Verify Summary output**
   - Wait: 3 seconds
   - Tool: `mcp__appium-mcp__appium_get_page_source`
   - Search: Look for "Summary:" or generated summary text
   - Expected: Summary content appears

5. **Test Todo button**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `accessibility id`
   - Selector: `Todo`
   - Tool: `mcp__appium-mcp__appium_click`
   - Expected: Todo action triggered

6. **Verify Todo output**
   - Wait: 3 seconds
   - Tool: `mcp__appium-mcp__appium_get_page_source`
   - Search: Look for todo items or checkboxes
   - Expected: Todo list appears

7. **Test Blueprint button**
   - Tool: `mcp__appium-mcp__appium_find_element`
   - Strategy: `accessibility id`
   - Selector: `Blueprint`
   - Tool: `mcp__appium-mcp__appium_click`
   - Expected: Blueprint action triggered

8. **Verify Blueprint output**
   - Wait: 3 seconds
   - Tool: `mcp__appium-mcp__appium_get_page_source`
   - Search: Look for blueprint structure or formatted text
   - Expected: Blueprint content appears

9. **Record test result**
   - If all buttons work and generate content: Test PASSED
   - If any button fails or no content: Test FAILED
