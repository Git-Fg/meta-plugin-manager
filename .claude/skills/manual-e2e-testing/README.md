# Manual E2E Testing Skill

A comprehensive skill for executing manual E2E testing of Flutter mobile apps using Appium MCP without vision analysis.

## Overview

This skill provides systematic procedures, strategies, and templates for manual end-to-end testing of mobile applications. It emphasizes text-first validation over visual testing, using element discovery, state verification, and programmatic validation through Appium MCP tools.

## Quick Start

### Invocation

The skill can be invoked in two ways:

1. **Direct invocation** (recommended for manual testing sessions):
   ```
   /manual-e2e-testing
   ```

2. **Auto-discovery** (Claude will use it when relevant):
   - Simply describe your testing needs: "I need to test the recording workflow"
   - Claude will automatically load the skill and guide you through the process

### Prerequisites

Before using this skill, ensure you have:
- Android emulator running and responsive
- Voice Note++ app installed
- Appium server configured
- Test environment set up

### Basic Usage

1. **Start a testing session:**
   ```
   /manual-e2e-testing
   ```

2. **Follow the guidance:**
   - The skill will present testing procedures
   - Choose a test type (recording, settings, navigation, etc.)
   - Execute steps using provided MCP tools
   - Document results using templates

## Skill Structure

```
manual-e2e-testing/
├── SKILL.md                          # Main skill instructions
├── README.md                          # This file
├── references/                        # Detailed reference documentation
│   ├── detailed-procedures.md         # Step-by-step test procedures
│   ├── element-discovery.md           # Element discovery strategies
│   ├── state-validation.md           # State validation techniques
│   ├── error-recovery.md             # Error handling patterns
│   └── test-reports.md               # Documentation templates
└── scripts/                          # Utility scripts
    └── validate_skill.sh             # Skill validation script
```

## Key Features

### 1. Text-First Testing Philosophy
- Validates text content instead of visual elements
- Uses element states and attributes for verification
- More reliable than screenshot-based testing
- Resilient to UI refactoring

### 2. Systematic Element Discovery
- Priority-based discovery (ID → accessibility → class → XPath)
- Multiple fallback strategies
- Comprehensive element patterns

### 3. State Validation Techniques
- Element presence verification
- Text content matching
- Attribute checking (enabled, displayed, clickable)
- Before/after state comparisons

### 4. Error Recovery Patterns
- Retry with exponential backoff
- Fallback strategy chains
- Session and app state recovery
- Comprehensive error handling

### 5. Documentation Templates
- Standardized test report formats
- Execution logging templates
- Issue tracking formats
- Best practices checklists

## Test Procedures

The skill includes detailed procedures for:

### Recording Workflow
- Record button interaction
- Audio capture simulation
- Transcription verification
- Magic toolbar validation

### Settings Configuration
- Navigation to settings
- API key input
- Save functionality
- Persistence verification

### Navigation Flow
- Dashboard to detail view
- Back navigation
- State preservation

### Magic Toolbar Functionality
- Summary generation
- Todo list creation
- Blueprint formatting

## Element Discovery Strategies

### Priority Order

1. **Resource IDs** (most stable)
   ```bash
   mcp__appium-mcp__appium_find_element
     strategy: id
     selector: com.voicenoteplus.app:id/record_fab
   ```

2. **Accessibility IDs** (second most stable)
   ```bash
   mcp__appium-mcp__appium_find_element
     strategy: accessibility id
     selector: Record
   ```

3. **Class names** (moderately stable)
   ```bash
   mcp__appium-mcp__appium_find_element
     strategy: class name
     selector: android.widget.Button
   ```

4. **XPath** (least stable, last resort)
   ```bash
   mcp__appium-mcp__appium_find_element
     strategy: xpath
     selector: //*[contains(@content-desc, "Record")]
   ```

## Common Workflows

### Basic Test Execution

1. **Setup:**
   - Verify emulator: `adb devices`
   - Clear app data: `adb shell pm clear com.voicenoteplus.app`
   - Create Appium session
   - Verify app launch

2. **Execute Test:**
   - Follow step-by-step procedure
   - Validate each step
   - Document results

3. **Cleanup:**
   - Delete Appium session
   - Save test report
   - Check logs for errors

### Error Recovery

When tests fail:

1. **Try retry with backoff**
2. **Use fallback discovery strategies**
3. **Check app state**
4. **Recover session if needed**
5. **Document recovery attempts**

## Best Practices

### ✅ DO
- Always verify element presence before interaction
- Use text content for validation
- Implement retry logic for flaky operations
- Log every step with timestamps
- Use accessibility IDs when available
- Check element attributes (enabled, displayed)

### ❌ DON'T
- Use screenshots for validation
- Rely on hard-coded coordinates
- Skip element presence checks
- Use unstable XPath expressions
- Ignore error messages

## Reference Documentation

For detailed information, see:

- **[Detailed Procedures](references/detailed-procedures.md)** - Complete step-by-step test procedures
- **[Element Discovery](references/element-discovery.md)** - Comprehensive element discovery guide
- **[State Validation](references/state-validation.md)** - State verification techniques
- **[Error Recovery](references/error-recovery.md)** - Error handling and recovery patterns
- **[Test Reports](references/test-reports.md)** - Documentation templates and formats

## Validation

Validate the skill installation:

```bash
./scripts/validate_skill.sh
```

This checks:
- Skill directory structure
- YAML frontmatter
- Required files present
- Markdown structure
- Cross-references

## Requirements

### For Users
- Access to Appium MCP tools
- Android emulator or device
- Voice Note++ app installed
- Basic understanding of mobile app testing

### For Developers
- Flutter app with testable elements
- Proper accessibility labels
- Unique resource IDs
- Stable UI components

## Troubleshooting

### Skill Not Triggering
If the skill doesn't activate automatically:
1. Try direct invocation: `/manual-e2e-testing`
2. Check skill is properly installed
3. Verify description matches your request

### Element Not Found
1. Try alternative discovery strategies
2. Use retry with backoff
3. Check app state
4. Verify element actually exists

### Test Failures
1. Check element selectors are correct
2. Verify app state is as expected
3. Use error recovery patterns
4. Document failures for analysis

## Examples

### Test a Recording Workflow

```
/manual-e2e-testing
> I want to test the complete recording workflow

Follow the Recording Workflow procedure:
1. Find record button (try ID first: record_fab)
2. Verify initial state (should show "Record")
3. Tap button to start recording
4. Verify recording indicator appears
5. Wait 5 seconds (simulate audio)
6. Tap stop button
7. Verify transcription appears
8. Check magic toolbar is visible
```

### Configure Settings

```
/manual-e2e-testing
> Test the settings configuration workflow

Follow the Settings Configuration procedure:
1. Navigate to settings
2. Find API key field (try ID: api_key_input)
3. Enter test API key
4. Verify input accepted
5. Save settings
6. Verify success message
7. Check settings persist
```

## Support

For issues or questions:
1. Review the reference documentation
2. Check test report templates
3. Use error recovery patterns
4. Document findings in test reports

## Version

- Version: 1.0.0
- Created: 2026-01-22
- Compatible with: Appium MCP, Flutter apps

## License

This skill is provided as-is for testing Voice Note++ application.
