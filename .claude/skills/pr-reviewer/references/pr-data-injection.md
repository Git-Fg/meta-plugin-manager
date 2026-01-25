# PR Data Injection

This reference explains how to inject live PR data into the pr-reviewer skill.

## Injection Methods

### Method 1: Pre-Execution Hook

Create a `.claude/hooks/PreSkillUse/pr-reviewer.sh`:

```bash
#!/bin/bash
set -euo pipefail

# Read the skill call input
input=$(cat)

# Extract PR details from environment or git
PR_NUMBER=$(echo "$input" | jq -r '.pr_number // empty')
PR_BASE=$(echo "$input" | jq -r '.base_branch // "main"')

if [ -n "$PR_NUMBER" ]; then
  # Fetch PR data from GitHub CLI
  PR_DATA=$(gh pr view "$PR_NUMBER" --json title,body,files,commits)

  PR_TITLE=$(echo "$PR_DATA" | jq -r '.title')
  PR_DESC=$(echo "$PR_DATA" | jq -r '.body')
  PR_FILES=$(echo "$PR_DATA" | jq -r '.files[].path' | paste -sd ',')
  PR_COMMITS=$(echo "$PR_DATA" | jq -r '.commits[].message' | head -5)
  PR_DIFF=$(gh pr diff "$PR_NUMBER")

  # Inject into skill context
  jq -n \
    --arg pr_diff "$PR_DIFF" \
    --arg pr_title "$PR_TITLE" \
    --arg pr_desc "$PR_DESC" \
    --arg pr_files "$PR_FILES" \
    --arg pr_commits "$PR_COMMITS" \
    '{pr_diff: $pr_diff, pr_title: $pr_title, pr_desc: $pr_desc, pr_files: $pr_files, pr_commits: $pr_commits}' >&2
fi

exit 0
```

### Method 2: Direct Invocation

Pass PR context when invoking the skill:

```bash
claude /pr-reviewer "Review PR #123" \
  --context pr_diff="$(git diff origin/main...HEAD)" \
  --context pr_title="$(git log -1 --pretty=%s)" \
  --context pr_files="$(git diff --name-only origin/main...HEAD | paste -sd ',')"
```

## Example Usage

```bash
# Using GitHub CLI
gh pr view 123 --json title,body,url | claude /pr-reviewer

# Using git diff
git diff origin/main...HEAD | claude /pr-reviewer "Review these changes"
```

## Testing Locally

Create a test PR context file:

```bash
cat > test-pr-context.json <<EOF
{
  "pr_diff": "$(git diff HEAD~1)",
  "pr_title": "Test commit",
  "pr_description": "Testing PR review",
  "changed_files": "src/file.ts",
  "commits": "feat: add feature"
}
EOF
```

Then invoke skill with test context.
