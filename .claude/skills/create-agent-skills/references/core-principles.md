## Overview

Core principles guide skill authoring decisions. These principles ensure skills are efficient, effective, and maintainable across different models and use cases.

<xml_structure_principle>
<description>
Skills use pure XML structure for consistent parsing, efficient token usage, and improved Claude performance.

<why_xml>

### Consistency

XML enforces consistent structure across all skills. All skills use the same tag names for the same purposes:
- `
## Objective

` always defines what the skill does
- `
## Quick Start

` always provides immediate guidance
- `
## Success Criteria

` always defines completion

This consistency makes skills predictable and easier to maintain.

<parseability>
XML provides unambiguous boundaries and semantic meaning. Claude can reliably:
- Identify section boundaries (where content starts and ends)
- Understand content purpose (what role each section plays)
- Skip irrelevant sections (progressive disclosure)
- Parse programmatically (validation tools can check structure)

Markdown headings are just visual formatting. Claude must infer meaning from heading text, which is less reliable.

### Token Efficiency

XML tags are more efficient than markdown headings:

**Markdown headings**:
```markdown
## Quick start
## Workflow
## Advanced features
## Success criteria
```
Total: ~20 tokens, no semantic meaning to Claude

**XML tags**:
```xml

## Quick Start

## Workflow

<advanced_features>

## Success Criteria

```
Total: ~15 tokens, semantic meaning built-in

Savings compound across all skills in the ecosystem.

<claude_performance>
Claude performs better with pure XML because:
- Unambiguous section boundaries reduce parsing errors
- Semantic tags convey intent directly (no inference needed)
- Nested tags create clear hierarchies
- Consistent structure across skills reduces cognitive load
- Progressive disclosure works more reliably

Pure XML structure is not just a style preference—it's a performance optimization.

## Critical Rule

**Remove ALL markdown headings (#, ##, ###) from skill body content.** Replace with semantic XML tags. Keep markdown formatting WITHIN content (bold, italic, lists, code blocks, links).

## Required Tags

Every skill MUST have:
- `
## Objective

` - What the skill does and why it matters
- `
## Quick Start

` - Immediate, actionable guidance
- `
## Success Criteria

` or `<when_successful>` - How to know it worked

See [use-xml-tags.md](use-xml-tags.md) for conditional tags and intelligence rules.

<conciseness_principle>
<description>
The context window is shared. Your skill shares it with the system prompt, conversation history, other skills' metadata, and the actual request.

<guidance>
Only add context Claude doesn't already have. Challenge each piece of information:
- "Does Claude really need this explanation?"
- "Can I assume Claude knows this?"
- "Does this paragraph justify its token cost?"

Assume Claude is smart. Don't explain obvious concepts.

<concise_example>
**Concise** (~50 tokens):
```xml

## Quick Start

Extract PDF text with pdfplumber:

```python
import pdfplumber

with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

```

**Verbose** (~150 tokens):
```xml

## Quick Start

PDF files are a common file format used for documents. To extract text from them, we'll use a Python library called pdfplumber. First, you'll need to import the library, then open the PDF file using the open method, and finally extract the text from each page. Here's how to do it:

```python
import pdfplumber

with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

This code opens the PDF and extracts text from the first page.

```

The concise version assumes Claude knows what PDFs are, understands Python imports, and can read code. All those assumptions are correct.

<when_to_elaborate>
Add explanation when:
- Concept is domain-specific (not general programming knowledge)
- Pattern is non-obvious or counterintuitive
- Context affects behavior in subtle ways
- Trade-offs require judgment

Don't add explanation for:
- Common programming concepts (loops, functions, imports)
- Standard library usage (reading files, making HTTP requests)
- Well-known tools (git, npm, pip)
- Obvious next steps

<degrees_of_freedom_principle>
<description>
Match the level of specificity to the task's fragility and variability. Give Claude more freedom for creative tasks, less freedom for fragile operations.

<high_freedom>
<when>
- Multiple approaches are valid
- Decisions depend on context
- Heuristics guide the approach
- Creative solutions welcome

## Example

```xml

## Objective

Review code for quality, bugs, and maintainability.

## Workflow

1. Analyze the code structure and organization
2. Check for potential bugs or edge cases
3. Suggest improvements for readability and maintainability
4. Verify adherence to project conventions

## Success Criteria

- All major issues identified
- Suggestions are actionable and specific
- Review balances praise and criticism

```

Claude has freedom to adapt the review based on what the code needs.

<medium_freedom>
<when>
- A preferred pattern exists
- Some variation is acceptable
- Configuration affects behavior
- Template can be adapted

## Example

```xml

## Objective

Generate reports with customizable format and sections.

<report_template>
Use this template and customize as needed:

```python
def generate_report(data, format="markdown", include_charts=True):
    # Process data
    # Generate output in specified format
    # Optionally include visualizations
```

## Success Criteria

- Report includes all required sections
- Format matches user preference
- Data accurately represented

```

Claude can customize the template based on requirements.

<low_freedom>
<when>
- Operations are fragile and error-prone
- Consistency is critical
- A specific sequence must be followed
- Deviation causes failures

## Example

```xml

## Objective

Run database migration with exact sequence to prevent data loss.

## Workflow

Run exactly this script:

```bash
python scripts/migrate.py --verify --backup
```

**Do not modify the command or add additional flags.**

## Success Criteria

- Migration completes without errors
- Backup created before migration
- Verification confirms data integrity

```

Claude must follow the exact command with no variation.

<matching_specificity>
The key is matching specificity to fragility:

- **Fragile operations** (database migrations, payment processing, security): Low freedom, exact instructions
- **Standard operations** (API calls, file processing, data transformation): Medium freedom, preferred pattern with flexibility
- **Creative operations** (code review, content generation, analysis): High freedom, heuristics and principles

Mismatched specificity causes problems:
- Too much freedom on fragile tasks → errors and failures
- Too little freedom on creative tasks → rigid, suboptimal outputs

<model_testing_principle>
<description>
Skills act as additions to models, so effectiveness depends on the underlying model. What works for Opus might need more detail for Haiku.

<testing_across_models>
Test your skill with all models you plan to use:

<haiku_testing>
**Claude Haiku** (fast, economical)

Questions to ask:
- Does the skill provide enough guidance?
- Are examples clear and complete?
- Do implicit assumptions become explicit?
- Does Haiku need more structure?

Haiku benefits from:
- More explicit instructions
- Complete examples (no partial code)
- Clear success criteria
- Step-by-step workflows

<sonnet_testing>
**Claude Sonnet** (balanced)

Questions to ask:
- Is the skill clear and efficient?
- Does it avoid over-explanation?
- Are workflows well-structured?
- Does progressive disclosure work?

Sonnet benefits from:
- Balanced detail level
- XML structure for clarity
- Progressive disclosure
- Concise but complete guidance

<opus_testing>
**Claude Opus** (powerful reasoning)

Questions to ask:
- Does the skill avoid over-explaining?
- Can Opus infer obvious steps?
- Are constraints clear?
- Is context minimal but sufficient?

Opus benefits from:
- Concise instructions
- Principles over procedures
- High degrees of freedom
- Trust in reasoning capabilities

<balancing_across_models>
Aim for instructions that work well across all target models:

**Good balance**:
```xml

## Quick Start

Use pdfplumber for text extraction:

```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

For scanned PDFs requiring OCR, use pdf2image with pytesseract instead.

```

This works for all models:
- Haiku gets complete working example
- Sonnet gets clear default with escape hatch
- Opus gets enough context without over-explanation

**Too minimal for Haiku**:
```xml

## Quick Start

Use pdfplumber for text extraction.

```

**Too verbose for Opus**:
```xml

## Quick Start

PDF files are documents that contain text. To extract that text, we use a library called pdfplumber. First, import the library at the top of your Python file. Then, open the PDF file using the pdfplumber.open() method. This returns a PDF object. Access the pages attribute to get a list of pages. Each page has an extract_text() method that returns the text content...

```

<iterative_improvement>
1. Start with medium detail level
2. Test with target models
3. Observe where models struggle or succeed
4. Adjust based on actual performance
5. Re-test and iterate

Don't optimize for one model. Find the balance that works across your target models.

<progressive_disclosure_principle>
<description>
SKILL.md serves as an overview. Reference files contain details. Claude loads reference files only when needed.

### Token Efficiency

Progressive disclosure keeps token usage proportional to task complexity:

- Simple task: Load SKILL.md only (~500 tokens)
- Medium task: Load SKILL.md + one reference (~1000 tokens)
- Complex task: Load SKILL.md + multiple references (~2000 tokens)

Without progressive disclosure, every task loads all content regardless of need.

## Implementation

- Keep SKILL.md under 500 lines
- Split detailed content into reference files
- Keep references one level deep from SKILL.md
- Link to references from relevant sections
- Use descriptive reference file names

See [skill-structure.md](skill-structure.md) for progressive disclosure patterns.

<validation_principle>
<description>
Validation scripts are force multipliers. They catch errors that Claude might miss and provide actionable feedback.

<characteristics>
Good validation scripts:
- Provide verbose, specific error messages
- Show available valid options when something is invalid
- Pinpoint exact location of problems
- Suggest actionable fixes
- Are deterministic and reliable

See [workflows-and-validation.md](workflows-and-validation.md) for validation patterns.

<principle_summary>
<xml_structure>
Use pure XML structure for consistency, parseability, and Claude performance. Required tags: objective, quick_start, success_criteria.

<conciseness>
Only add context Claude doesn't have. Assume Claude is smart. Challenge every piece of content.

<degrees_of_freedom>
Match specificity to fragility. High freedom for creative tasks, low freedom for fragile operations, medium for standard work.

<model_testing>
Test with all target models. Balance detail level to work across Haiku, Sonnet, and Opus.

## Progressive Disclosure

Keep SKILL.md concise. Split details into reference files. Load reference files only when needed.

## Validation

Make validation scripts verbose and specific. Catch errors early with actionable feedback.