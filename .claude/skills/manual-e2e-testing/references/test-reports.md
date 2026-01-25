# Test Documentation & Reporting Templates

Standardized templates for documenting test execution and results.

## Test Execution Log

**Purpose:** Track all test steps for debugging and analysis

### Manual Logging Process:

1. **Create log file**
   - Name format: `test_log_[test_name]_[timestamp].txt`
   - Location: `test_reports/` directory
   - Create before starting test

2. **Log each step with timestamp**
   - Format: `[HH:MM:SS] Step description: Result`
   - Example: `[10:30:01] Step 1 - Find record button: SUCCESS`
   - Example: `[10:30:02] Step 2 - Tap record button: SUCCESS`
   - Example: `[10:30:03] Step 3 - Verify recording: FAILED`

3. **Record timestamps**
   - Note start time of test
   - Note end time of test
   - Calculate total duration

4. **Log errors with details**
   - Record exact tool call that failed
   - Record selector and strategy used
   - Record error message received
   - Note which retry attempt failed

## Sample Test Report Format

Create file: `test_reports/manual_[test_name]_[date].md`

### Successful Test Report Template:

```markdown
# Manual E2E Test Report: Recording Workflow

## Test Information
- Test Name: Recording Workflow
- Date: 2026-01-22
- Start Time: 10:30:00
- End Time: 10:30:12
- Duration: 12 seconds
- Platform: Android (Emulator)

## Execution Steps
1. [10:30:01] Find record button - SUCCESS (found via id: record_fab)
2. [10:30:02] Tap record button - SUCCESS
3. [10:30:03] Verify recording indicator - SUCCESS (element visible)
4. [10:30:08] Stop recording - SUCCESS
5. [10:30:11] Verify transcription - SUCCESS (text: "This is a test...")
6. [10:30:12] Verify magic toolbar - SUCCESS

## Summary
- Total Steps: 6
- Passed: 6
- Failed: 0
- Status: PASSED

## Notes
- All elements found on first attempt
- No recovery strategies needed
- Transcription generated successfully
- UI responded as expected

## Screenshots (if any)
- Before test: [path_to_screenshot]
- After test: [path_to_screenshot]
```

### Failed Test Report Template:

```markdown
# Manual E2E Test Report: Settings Configuration (FAILED)

## Test Information
- Test Name: Settings Configuration
- Date: 2026-01-22
- Start Time: 11:00:00
- End Time: 11:00:05
- Duration: 5 seconds
- Platform: Android (Emulator)

## Execution Steps
1. [11:00:01] Navigate to settings - SUCCESS
2. [11:00:02] Find API key field - FAILED (element not found)
3. [11:00:03] Attempt recovery: try accessibility id - FAILED
4. [11:00:04] Attempt recovery: try class name - FAILED
5. [11:00:05] Test ABORTED

## Summary
- Total Steps: 5
- Passed: 2
- Failed: 3
- Status: FAILED

## Failure Details
- Failed at: Step 2
- Element sought: API key input field
- Strategies tried:
  - id: com.voicenoteplus.app:id/api_key_input
  - accessibility id: API Key
  - class name: android.widget.EditText
- Error: Element not found with any strategy

## Root Cause Analysis
- Settings screen may not have loaded completely
- API key field may have different ID than expected
- Possible UI layout change not reflected in test

## Recommendations
- Verify settings screen layout
- Check for dynamic loading of settings elements
- Update element selectors based on current UI
- Add explicit wait for settings to load
```

## Detailed Test Report Template

For comprehensive analysis:

```markdown
# Comprehensive Test Report: [Test Name]

## Test Metadata
- Test ID: [unique-identifier]
- Test Name: [descriptive-name]
- Tester: [name]
- Date: [YYYY-MM-DD]
- Start Time: [HH:MM:SS]
- End Time: [HH:MM:SS]
- Duration: [X seconds/minutes]
- Platform: Android/iOS
- Device: [emulator/device-model]
- App Version: [version-number]
- Test Type: Manual E2E

## Prerequisites
- [ ] Emulator running and responsive
- [ ] App installed and launchable
- [ ] Appium session created
- [ ] Clean app state (data cleared)
- [ ] No error logs present

## Test Environment
- Platform: Android
- Platform Version: [e.g., 14]
- Device Name: [e.g., Pixel_7_API_34]
- Automation Name: UiAutomator2
- App Package: com.voicenoteplus.app
- App Activity: .MainActivity

## Test Steps

### Step 1: [Step Name]
- **Action:** [What was done]
- **Tool Used:** mcp__appium-mcp__[tool-name]
- **Strategy:** [id/accessibility/class/xpath]
- **Selector:** [actual-selector-used]
- **Timestamp:** [HH:MM:SS]
- **Expected:** [what should happen]
- **Actual:** [what actually happened]
- **Result:** PASS/FAIL
- **Notes:** [any observations]

### Step 2: [Step Name]
[... repeat for each step ...]

## Element Discovery Log

| Step | Element | Strategy | Selector | Attempts | Success |
|------|---------|----------|----------|----------|---------|
| 1 | Record Button | id | record_fab | 1 | ✓ |
| 2 | Settings | accessibility | Settings | 1 | ✓ |
| 3 | API Key Field | id | api_key_input | 3 | ✗ |

## State Validation Log

| Step | Check Type | Expected | Actual | Result |
|------|------------|----------|---------|--------|
| 1 | Button Text | "Record" | "Record" | ✓ |
| 2 | Button State | enabled | true | ✓ |
| 3 | Element Displayed | true | false | ✗ |

## Error Log

| Time | Error Type | Message | Recovery Attempt |
|------|------------|---------|------------------|
| 11:00:02 | ElementNotFound | Element with id 'api_key_input' not found | Tried accessibility, class - all failed |

## Recovery Actions

| Step | Recovery Strategy | Action Taken | Success |
|------|------------------|-------------|---------|
| 3 | Retry with backoff | Waited 1s, 2s, 4s | No |
| 3 | Fallback strategies | Tried accessibility, class | No |
| 3 | Check app state | Verified settings screen loaded | Partial |

## Test Result Summary

### Overall Status
- **Result:** PASS/FAIL
- **Pass Rate:** [X/Y] steps passed ([percentage])

### Metrics
- Total Steps: [number]
- Successful Steps: [number]
- Failed Steps: [number]
- Retry Attempts: [number]
- Recovery Attempts: [number]

### Key Findings
- [Finding 1]
- [Finding 2]
- [Finding 3]

## Issues Found

### Issue 1: [Issue Title]
- **Severity:** High/Medium/Low
- **Type:** Functional/UI/API/Performance
- **Description:** [Detailed description]
- **Steps to Reproduce:** [How to trigger]
- **Expected Behavior:** [What should happen]
- **Actual Behavior:** [What actually happened]
- **Impact:** [Effect on user/app]
- **Recommendation:** [How to fix]

### Issue 2: [Issue Title]
[... repeat for each issue ...]

## Recommendations

### Immediate Actions
- [ ] [Action 1]
- [ ] [Action 2]
- [ ] [Action 3]

### Long-term Improvements
- [ ] [Improvement 1]
- [ ] [Improvement 2]

### Test Enhancement
- [ ] Update selectors based on findings
- [ ] Add explicit waits for slow-loading elements
- [ ] Improve recovery strategies
- [ ] Add more validation checks

## Attachments

### Logs
- [adb logcat output](path/to/logcat.txt)
- [Appium server logs](path/to/appium.log)

### Screenshots
- [Before test](path/to/before.png)
- [After test](path/to/after.png)
- [Error state](path/to/error.png)

### Page Source
- [Initial state](path/to/initial.xml)
- [Final state](path/to/final.xml)

## Test Completion Checklist
- [ ] All steps executed
- [ ] Results documented
- [ ] Errors logged
- [ ] Screenshots captured
- [ ] Logs saved
- [ ] Report generated
- [ ] Issues reported
```

## Quick Reference Card

For rapid test execution logging:

```markdown
# Quick Test Log: [Test Name]
**Date:** [YYYY-MM-DD] **Time:** [HH:MM]

## Setup
- [✓] Emulator ready
- [✓] App launched
- [✓] Session created
- [✓] Clean state

## Execution
[HH:MM:SS] ✓/✗ Step 1: [action]
[HH:MM:SS] ✓/✗ Step 2: [action]
[HH:MM:SS] ✓/✗ Step 3: [action]
[HH:MM:SS] ✓/✗ Step 4: [action]
[HH:MM:SS] ✓/✗ Step 5: [action]

## Summary
- **Result:** PASS/FAIL
- **Steps:** X/Y passed
- **Duration:** [time]
- **Issues:** [count]

## Notes
[Observations, findings, recommendations]
```

## Report Templates by Test Type

### Recording Workflow Report

```markdown
# Test Report: Recording Workflow

## Test Sequence
1. Find record button
2. Tap to start recording
3. Verify recording indicator
4. Wait (simulate audio capture)
5. Tap to stop recording
6. Verify transcription appears
7. Verify magic toolbar

## Expected Results
- Button changes from "Record" to "Stop"
- Recording indicator visible during capture
- Transcription appears after stop
- Magic toolbar with Summary/Todo/Blueprint

## Actual Results
- [Document actual outcomes]
```

### Settings Configuration Report

```markdown
# Test Report: Settings Configuration

## Test Sequence
1. Navigate to settings
2. Find API key input field
3. Enter test API key
4. Verify input accepted
5. Tap save button
6. Verify success message
7. Verify settings persisted

## Expected Results
- Settings screen loads
- API key field accepts input
- Save action completes successfully
- Success message displays
- Settings remain after navigation
```

### Navigation Flow Report

```markdown
# Test Report: Navigation Flow

## Test Sequence
1. Verify dashboard visible
2. Tap note item
3. Verify detail view loads
4. Navigate back to dashboard
5. Verify dashboard restored

## Expected Results
- Dashboard elements visible
- Note list displays correctly
- Detail view shows selected note
- Back navigation works
- State preserved correctly
```

## Logging Best Practices

### What to Log

✅ **DO Log:**
- Every test step with timestamp
- Element discovery attempts
- State changes (before/after)
- Error messages and exceptions
- Recovery actions taken
- Final results

❌ **DON'T Log:**
- Unnecessary details
- Repetitive successful operations
- Sensitive data (API keys, passwords)
- System-level operations unrelated to test

### Log Format Standards

**Timestamps:** Always use HH:MM:SS format
**Results:** Use clear indicators (✓/✗, PASS/FAIL, SUCCESS/FAILED)
**Element Discovery:** Include strategy and selector used
**Errors:** Include full error message and context
**Recovery:** Document what was tried and outcome

### Example Log Entry

```
[10:30:01] Step 1: Find record button
  Strategy: id
  Selector: com.voicenoteplus.app:id/record_fab
  Result: SUCCESS (element found)
  Notes: Element enabled and displayed

[10:30:02] Step 2: Tap record button
  Action: mcp__appium-mcp__appium_click
  Result: SUCCESS
  Notes: Button state changed to "Stop"

[10:30:03] Step 3: Verify recording indicator
  Strategy: id
  Selector: com.voicenoteplus.app:id/recording_indicator
  Result: FAIL (element not found)
  Recovery: Waited 2 seconds, tried again - SUCCESS
  Notes: Element appeared after brief delay
```

## Report Archive Structure

Organize reports for easy retrieval:

```
test_reports/
├── 2026-01-22/
│   ├── recording_workflow_2026-01-22.md
│   ├── settings_config_2026-01-22.md
│   └── navigation_flow_2026-01-22.md
├── 2026-01-23/
│   └── ...
└── archive/
    └── old_reports/
```

## Reporting Automation

While this guide covers manual testing, consider automation:

### Build Report Script
```bash
#!/bin/bash
# generate_report.sh

TEST_NAME=$1
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)

cat > "test_reports/${TEST_NAME}_${DATE}.md" << EOF
# Test Report: $TEST_NAME

## Test Information
- Date: $DATE
- Time: $TIME
- Platform: Android

## Results
[TBD - fill during test execution]

EOF

echo "Report template created: test_reports/${TEST_NAME}_${DATE}.md"
```

## Report Review Checklist

Before marking test complete:

- [ ] All steps documented with timestamps
- [ ] Element discovery attempts recorded
- [ ] State validations logged
- [ ] Errors captured with details
- [ ] Recovery actions documented
- [ ] Final result clearly stated
- [ ] Screenshots attached (if applicable)
- [ ] Logs saved
- [ ] Issues identified and described
- [ ] Recommendations provided
- [ ] Report saved in correct location
- [ ] Report follows template format
