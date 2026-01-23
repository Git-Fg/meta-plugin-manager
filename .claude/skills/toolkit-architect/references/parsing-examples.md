# Parsing Examples

## Extraction Pattern

```bash
# Extract frontmatter from markdown
extract_frontmatter() {
    local file="$1"
    sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$file"
}
```

## Method Comparison

| Method | Use Case | Example |
|--------|----------|---------|
| **sed/awk** | Simple fields | Read string/boolean values |
| **yq** | Production use | Full YAML parsing, arrays, nested fields |
| **Python** | Complex validation | Type checking, schema validation |
| **jq** | JSON workflows | Convert YAML→JSON first |

## Common Field Reads

### Boolean Fields
```bash
# Using yq (recommended)
ENABLED=$(yq eval '.enabled' "$FILE")

# Using sed
ENABLED=$(echo "$FRONTMATTER" | grep "^enabled:" | sed 's/^enabled: *//' | tr -d '[:space:]')
```

### String Fields
```bash
# Using yq
MODE=$(yq eval '.mode // "standard"' "$FILE")

# Using sed
MODE=$(echo "$FRONTMATTER" | grep "^mode:" | sed 's/^mode: *//' | sed 's/^"\(.*\)"$/\1/')
```

### Array Fields
```bash
# Using yq
IFS=$'\n' read -rd '' -a ARRAY <<< "$(yq eval -r '.array_field[]' "$FILE")"

# Using Python
ARRAY=$(python3 -c "import yaml; data=yaml.safe_load(open('$FILE')); print('\n'.join(data.get('array_field', [])))")
```

### Numeric Fields
```bash
# Using yq
TIMEOUT=$(yq eval '.timeout' "$FILE")

# Using sed with validation
TIMEOUT=$(echo "$FRONTMATTER" | grep "^timeout:" | sed 's/^timeout: *//')
```

## Recommended Approach

**Use yq for most cases**:
- Handles complex YAML
- Supports defaults: `.field // "default"`
- Array support: `.array[]`
- Nested fields: `.parent.child`

**Use Python for validation**:
- Type checking
- Schema validation
- Business rules

**Use sed/awk for simple cases**:
- No dependencies
- Basic field extraction
