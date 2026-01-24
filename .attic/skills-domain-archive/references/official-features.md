# Official Agent Skills Features

Documentation of features from official Agent Skills specification not covered in main SKILL.md.

---

## Runtime Environment

Skills run in a code execution environment with filesystem access, bash commands, and code execution capabilities.

### How This Affects Authoring

**How Claude accesses Skills:**
1. **Metadata pre-loaded**: At startup, name and description from all Skills' YAML frontmatter loaded
2. **Files read on-demand**: Claude uses bash Read tools to access SKILL.md
3. **Scripts executed efficiently**: Utility scripts executed via bash without loading full contents
4. **No context penalty**: Reference files don't consume tokens until read

**Key considerations:**
- **File paths matter**: Use forward slashes (`reference/guide.md`), not backslashes
- **Name files descriptively**: `form_validation_rules.md`, not `doc2.md`
- **Organize for discovery**: Structure by domain or feature
- **Bundle comprehensive resources**: Complete API docs, examples, datasets
- **Write scripts**: Don't ask Claude to generate validation code

### Example Structure

```
bigquery-skill/
├── SKILL.md (overview, points to reference files)
└── reference/
    ├── finance.md (revenue metrics)
    ├── sales.md (pipeline data)
    └── product.md (usage analytics)
```

When user asks about revenue, Claude reads SKILL.md, sees reference to `reference/finance.md`, and reads just that file. Sales.md and product.md consume zero tokens until needed.

---

## allowed-tools Field

Restrict which tools Claude can use when a skill is active.

### Syntax

```yaml
---
name: safe-reader
description: Read files without making changes
allowed-tools: Read, Grep, Glob
---
```

### Purpose

Provides read-only mode where Claude can explore files but not modify them.

### Examples

**Restricted execution**:
```yaml
---
name: code-analyzer
description: Analyze code patterns without making changes
allowed-tools: Read, Grep, Glob, Bash
---
```

**Command execution only**:
```yaml
---
name: test-runner
description: Run tests in isolated environment
allowed-tools: Bash
---
```

### Best Practices

- **Use for security**: Restrict destructive tools (Write, Edit)
- **Use for focus**: Limit to tools needed for task
- **Combine with context: fork**: For maximum isolation
- **Document restrictions**: Explain why tools are limited

---

## MCP Tool References

If your Skill uses MCP (Model Context Protocol) tools, always use fully qualified tool names.

### Format

```
ServerName:tool_name
```

### Examples

**BigQuery tools**:
```
Use the BigQuery:bigquery_schema tool to retrieve table schemas.
Use the BigQuery:bigquery_query tool to execute queries.
```

**GitHub tools**:
```
Use the GitHub:create_issue tool to create issues.
Use the GitHub:list_releases tool to fetch releases.
```

**File system tools**:
```
Use the Filesystem:read_file tool to read files.
Use the Filesystem:write_file tool to write files.
```

### Why Fully Qualified?

Without the server prefix, Claude may fail to locate the tool, especially when multiple MCP servers are available.

**Wrong**:
```
Use the bigquery_schema tool to retrieve schemas.
```

**Correct**:
```
Use the BigQuery:bigquery_schema tool to retrieve schemas.
```

---

## Visual Analysis Pattern

When inputs can be rendered as images, have Claude analyze them visually.

### Pattern

1. Convert input to images:
   ```bash
   python scripts/pdf_to_images.py form.pdf
   ```

2. Claude analyzes images to identify:
   - Field locations
   - Text content
   - Layout structure
   - Visual patterns

3. Process results:
   ```bash
   python scripts/analyze_images.py output_dir/
   ```

### Use Cases

- **PDF form analysis**: Identify form fields visually
- **UI mockups**: Analyze interface designs
- **Diagram interpretation**: Understand flowcharts, diagrams
- **Screenshot analysis**: Process error screenshots
- **Document layout**: Analyze multi-column layouts

### Example

```markdown
## Form layout analysis

1. Convert PDF to images:
   ```bash
   python scripts/pdf_to_images.py form.pdf
   ```

2. Analyze each page image to identify form fields

3. Claude can see field locations and types visually
```

---

## Verifiable Intermediate Outputs

For complex, open-ended tasks, use the "plan-validate-execute" pattern to catch errors early.

### Pattern

1. **Create plan file**: Claude creates structured plan
2. **Validate plan**: Script validates plan format and logic
3. **Execute plan**: Apply changes based on validated plan
4. **Verify output**: Confirm results meet requirements

### Example Workflow

**Without validation** (risky):
```
1. Analyze PDF
2. Fill 50 fields
3. Save output
```

**With validation** (safe):
```
1. Analyze PDF → creates changes.json
2. Validate changes.json → script checks format
3. Execute changes.json → apply updates
4. Verify output → confirm results
```

### Implementation

**Plan creation**:
```python
# Claude creates changes.json
{
  "field_name": "customer_name",
  "value": "John Doe",
  "action": "fill"
}
```

**Validation script**:
```bash
python scripts/validate_changes.py changes.json
# Returns: "OK" or lists conflicts
```

**Benefits**:
- Catches errors early
- Machine-verifiable
- Reversible planning
- Clear debugging

### When to Use

- Batch operations
- Destructive changes
- Complex validation rules
- High-stakes operations

---

## Package Dependencies

Skills run in different environments with varying capabilities:

### Environment Capabilities

**claude.ai**:
- Can install packages from npm and PyPI
- Can pull from GitHub repositories
- Has network access

**Anthropic API**:
- No network access
- No runtime package installation
- Limited to built-in packages only

### Best Practices

1. **List required packages**:
   ```markdown
   Required packages:
   - pandas (pip install pandas)
   - requests (pip install requests)
   ```

2. **Verify availability**:
   Check [code execution tool documentation](https://platform.claude.com/docs/en/agents-and-tools/tool-use/code-execution-tool)

3. **Provide fallbacks**:
   ```python
   try:
       import pandas as pd
   except ImportError:
       # Use csv module instead
       import csv
   ```

4. **Document versions**:
   ```markdown
   Tested with:
   - pandas >= 1.3.0
   - requests >= 2.25.0
   ```

---

## Anti-Patterns to Avoid

### Windows-Style Paths

Always use forward slashes:
- ✅ Good: `scripts/helper.py`, `reference/guide.md`
- ❌ Avoid: `scripts\helper.py`, `reference\guide.md`

Unix-style paths work across all platforms.

### Too Many Options

Don't present multiple approaches unless necessary:

**Bad** (too many choices):
```
"You can use pypdf, or pdfplumber, or PyMuPDF, or pdf2image, or..."
```

**Good** (provide default):
```
"Use pdfplumber for text extraction:
```python
import pdfplumber
```

For scanned PDFs requiring OCR, use pdf2image with pytesseract instead.
```

### Assuming Tools Are Installed

**Bad** (assumes installation):
```
"Use the pdf library to process the file."
```

**Good** (explicit about dependencies):
```
"Install required package: pip install pypdf
Then use it:
```python
from pypdf import PdfReader
reader = PdfReader("file.pdf")
```
```

### Deeply Nested References

Keep references one level deep from SKILL.md:

**Bad** (too deep):
```
# SKILL.md
See [advanced.md](advanced.md)
# advanced.md
See [details.md](details.md)
# details.md
Here's the actual information...
```

**Good** (one level):
```
# SKILL.md
**Basic usage**: [instructions in SKILL.md]
**Advanced features**: See [advanced.md](advanced.md)
**API reference**: See [reference.md](reference.md)
```

---

## Validation Tools

Use the [skills-ref](https://github.com/agentskills/agentskills/tree/main/skills-ref) reference library to validate skills:

```bash
skills-ref validate ./my-skill
```

This checks:
- YAML frontmatter is valid
- Follows all naming conventions
- Structure matches specification

---

## See Also

- [Agent Skills Specification](https://agentskills.io/specification)
- [Official Skills Guide](https://code.claude.com/docs/en/skills)
- [Skill Authoring Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
