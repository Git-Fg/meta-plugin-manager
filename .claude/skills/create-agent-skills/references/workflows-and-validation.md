## Overview

This reference covers patterns for complex workflows, validation loops, and feedback cycles in skill authoring. All patterns use pure XML structure.

<complex_workflows>

### Principle

Break complex operations into clear, sequential steps. For particularly complex workflows, provide a checklist.

<pdf_forms_example>
```xml

## Objective

Fill PDF forms with validated data from JSON field mappings.

## Workflow

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Step 1: Analyze the form (run analyze_form.py)
- [ ] Step 2: Create field mapping (edit fields.json)
- [ ] Step 3: Validate mapping (run validate_fields.py)
- [ ] Step 4: Fill the form (run fill_form.py)
- [ ] Step 5: Verify output (run verify_output.py)
```

<step_1>
**Analyze the form**

Run: `python scripts/analyze_form.py input.pdf`

This extracts form fields and their locations, saving to `fields.json`.
</step_1>

<step_2>
**Create field mapping**

Edit `fields.json` to add values for each field.
</step_2>

<step_3>
**Validate mapping**

Run: `python scripts/validate_fields.py fields.json`

Fix any validation errors before continuing.
</step_3>

<step_4>
**Fill the form**

Run: `python scripts/fill_form.py input.pdf fields.json output.pdf`
</step_4>

<step_5>
**Verify output**

Run: `python scripts/verify_output.py output.pdf`

If verification fails, return to Step 2.
</step_5>

```

## When to Use

Use checklist pattern when:
- Workflow has 5+ sequential steps
- Steps must be completed in order
- Progress tracking helps prevent errors
- Easy resumption after interruption is valuable

<feedback_loops>
<validate_fix_repeat_pattern>

### Principle

Run validator → fix errors → repeat. This pattern greatly improves output quality.

<document_editing_example>
```xml

## Objective

Edit OOXML documents with XML validation at each step.

<editing_process>
<step_1>
Make your edits to `word/document.xml`
</step_1>

<step_2>
**Validate immediately**: `python ooxml/scripts/validate.py unpacked_dir/`
</step_2>

<step_3>
If validation fails:
- Review the error message carefully
- Fix the issues in the XML
- Run validation again
</step_3>

<step_4>
**Only proceed when validation passes**
</step_4>

<step_5>
Rebuild: `python ooxml/scripts/pack.py unpacked_dir/ output.docx`
</step_5>

<step_6>
Test the output document
</step_6>

## Validation

Never skip validation. Catching errors early prevents corrupted output files.

```

<why_it_works>
- Catches errors early before changes are applied
- Machine-verifiable with objective verification
- Plan can be iterated without touching originals
- Reduces total iteration cycles

<plan_validate_execute_pattern>

### Principle

When Claude performs complex, open-ended tasks, create a plan in a structured format, validate it, then execute.

Workflow: analyze → **create plan file** → **validate plan** → execute → verify

<batch_update_example>
```xml

## Objective

Apply batch updates to spreadsheet with plan validation.

## Workflow

<plan_phase>
<step_1>
Analyze the spreadsheet and requirements
</step_1>

<step_2>
Create `changes.json` with all planned updates
</step_2>

<validation_phase>
<step_3>
Validate the plan: `python scripts/validate_changes.py changes.json`
</step_3>

<step_4>
If validation fails:
- Review error messages
- Fix issues in changes.json
- Validate again
</step_4>

<step_5>
Only proceed when validation passes
</step_5>

## Execution Phase

<step_6>
Apply changes: `python scripts/apply_changes.py changes.json`
</step_6>

<step_7>
Verify output
</step_7>

## Success Criteria

- Plan validation passes with zero errors
- All changes applied successfully
- Output verification confirms expected results

```

<implementation_tip>
Make validation scripts verbose with specific error messages:

**Good error message**:
"Field 'signature_date' not found. Available fields: customer_name, order_total, signature_date_signed"

**Bad error message**:
"Invalid field"

Specific errors help Claude fix issues without guessing.

## When to Use

Use plan-validate-execute when:
- Operations are complex and error-prone
- Changes are irreversible or difficult to undo
- Planning can be validated independently
- Catching errors early saves significant time

<conditional_workflows>

### Principle

Guide Claude through decision points with clear branching logic.

<document_modification_example>
```xml

## Objective

Modify DOCX files using appropriate method based on task type.

## Workflow

<decision_point_1>
Determine the modification type:

**Creating new content?** → Follow "Creation workflow"
**Editing existing content?** → Follow "Editing workflow"
</decision_point_1>

<creation_workflow>

## Objective

Build documents from scratch

<steps>
1. Use docx-js library
2. Build document from scratch
3. Export to .docx format

<editing_workflow>

## Objective

Modify existing documents

<steps>
1. Unpack existing document
2. Modify XML directly
3. Validate after each change
4. Repack when complete

## Success Criteria

- Correct workflow chosen based on task type
- All steps in chosen workflow completed
- Output file validated and verified

```

## When to Use

Use conditional workflows when:
- Different task types require different approaches
- Decision points are clear and well-defined
- Workflows are mutually exclusive
- Guiding Claude to correct path improves outcomes

<validation_scripts>
<principles>
Validation scripts are force multipliers. They catch errors that Claude might miss and provide actionable feedback for fixing issues.

<characteristics_of_good_validation>
<verbose_errors>
**Good**: "Field 'signature_date' not found. Available fields: customer_name, order_total, signature_date_signed"

**Bad**: "Invalid field"

Verbose errors help Claude fix issues in one iteration instead of multiple rounds of guessing.

<specific_feedback>
**Good**: "Line 47: Expected closing tag `` but found ``"

**Bad**: "XML syntax error"

Specific feedback pinpoints exact location and nature of the problem.

<actionable_suggestions>
**Good**: "Required field 'customer_name' is missing. Add: {\"customer_name\": \"value\"}"

**Bad**: "Missing required field"

Actionable suggestions show Claude exactly what to fix.

<available_options>
When validation fails, show available valid options:

**Good**: "Invalid status 'pending_review'. Valid statuses: active, paused, archived"

**Bad**: "Invalid status"

Showing valid options eliminates guesswork.

<implementation_pattern>
```xml

## Validation

After making changes, validate immediately:

```bash
python scripts/validate.py output_dir/
```

If validation fails, fix errors before continuing. Validation errors include:

- **Field not found**: "Field 'signature_date' not found. Available fields: customer_name, order_total, signature_date_signed"
- **Type mismatch**: "Field 'order_total' expects number, got string"
- **Missing required field**: "Required field 'customer_name' is missing"
- **Invalid value**: "Invalid status 'pending_review'. Valid statuses: active, paused, archived"

Only proceed when validation passes with zero errors.

```

## Benefits

- Catches errors before they propagate
- Reduces iteration cycles
- Provides learning feedback
- Makes debugging deterministic
- Enables confident execution

<iterative_refinement>

### Principle

Many workflows benefit from iteration: generate → validate → refine → validate → finalize.

<implementation_example>
```xml

## Objective

Generate reports with iterative quality improvement.

## Workflow

<iteration_1>
**Generate initial draft**

Create report based on data and requirements.
</iteration_1>

<iteration_2>
**Validate draft**

Run: `python scripts/validate_report.py draft.md`

Fix any structural issues, missing sections, or data errors.
</iteration_2>

<iteration_3>
**Refine content**

Improve clarity, add supporting data, enhance visualizations.
</iteration_3>

<iteration_4>
**Final validation**

Run: `python scripts/validate_report.py final.md`

Ensure all quality criteria met.
</iteration_4>

<iteration_5>
**Finalize**

Export to final format and deliver.
</iteration_5>

## Success Criteria

- Final validation passes with zero errors
- All quality criteria met
- Report ready for delivery

```

## When to Use

Use iterative refinement when:
- Quality improves with multiple passes
- Validation provides actionable feedback
- Time permits iteration
- Perfect output matters more than speed

<checkpoint_pattern>

### Principle

For long workflows, add checkpoints where Claude can pause and verify progress before continuing.

<implementation_example>
```xml

## Workflow

<phase_1>
**Data collection** (Steps 1-3)

1. Extract data from source
2. Transform to target format
3. **CHECKPOINT**: Verify data completeness

Only continue if checkpoint passes.
</phase_1>

<phase_2>
**Data processing** (Steps 4-6)

4. Apply business rules
5. Validate transformations
6. **CHECKPOINT**: Verify processing accuracy

Only continue if checkpoint passes.
</phase_2>

<phase_3>
**Output generation** (Steps 7-9)

7. Generate output files
8. Validate output format
9. **CHECKPOINT**: Verify final output

Proceed to delivery only if checkpoint passes.
</phase_3>

<checkpoint_validation>
At each checkpoint:
1. Run validation script
2. Review output for correctness
3. Verify no errors or warnings
4. Only proceed when validation passes

```

## Benefits

- Prevents cascading errors
- Easier to diagnose issues
- Clear progress indicators
- Natural pause points for review
- Reduces wasted work from early errors

<error_recovery>

### Principle

Design workflows with clear error recovery paths. Claude should know what to do when things go wrong.

<implementation_example>
```xml

## Workflow

<normal_path>
1. Process input file
2. Validate output
3. Save results

<error_recovery>
**If validation fails in step 2:**
- Review validation errors
- Check if input file is corrupted → Return to step 1 with different input
- Check if processing logic failed → Fix logic, return to step 1
- Check if output format wrong → Fix format, return to step 2

**If save fails in step 3:**
- Check disk space
- Check file permissions
- Check file path validity
- Retry save with corrected conditions

<escalation>
**If error persists after 3 attempts:**
- Document the error with full context
- Save partial results if available
- Report issue to user with diagnostic information

```

## When to Use

Include error recovery when:
- Workflows interact with external systems
- File operations could fail
- Network calls could timeout
- User input could be invalid
- Errors are recoverable