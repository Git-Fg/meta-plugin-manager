---
name: jules:review-local
description: Review local files with Jules by pushing to temp branch. Works without git setup - creates ephemeral branch, sends to Jules, creates PR with review. Use for: offline code review, quick validation, testing before push.
---

# Jules Local File Review

Review local files with Jules by creating an ephemeral branch.

## Usage

\`\`\`bash
# Review a single file
/jules:review-local .claude/skills/my-skill/SKILL.md

# Review multiple files
/jules:review-local .claude/skills/my-skill/SKILL.md .claude/skills/my-skill/examples.md

# With custom prompt
/jules:review-local .claude/skills/my-skill/SKILL.md "Check for portability violations and suggest fixes"
\`\`\`

## What It Does

1. Creates a temporary branch (`jules-review-{timestamp}`)
2. Commits the specified file(s)
3. Pushes to remote
4. Creates a Jules session with your review prompt
5. Returns session ID for tracking
6. Optionally cleans up the temp branch

## Environment Variables Required

\`\`\`bash
export JULES_API_KEY=your-key-here
\`\`\`

## Example Output

\`\`\`
Created temp branch: jules-review-1738045200
Committed: SKILL.md
Pushed to origin
Created Jules session: 1234567890
URL: https://jules.google.com/session/1234567890

Monitor with: curl https://jules.googleapis.com/v1alpha/sessions/1234567890
\`\`\`

## Cleanup

After review completes, the temp branch can be deleted:
\`\`\`bash
git checkout main
git branch -D jules-review-{timestamp}
git push origin --delete jules-review-{timestamp}
\`\`\`

---

## Implementation

To use this command, you need to:

1. Create the script below at `.claude/commands/jules/review-local.sh`

\`\`\`bash
#!/bin/bash
set -e

FILES=()
CUSTOM_PROMPT=""
TEMP_BRANCH="jules-review-$(date +%s)"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    *.md|*.py|*.ts|*.js)
      FILES+=("$1")
      shift
      ;;
    *)
      CUSTOM_PROMPT="$1"
      shift
      ;;
  esac
done

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "Usage: /jules:review-local <file> [file...] [custom prompt]"
  exit 1
fi

# Get repo info
REPO_FULL=$(git config --get remote.origin.url | sed -E 's/.*github.com[:/]//; s/\.git$//')
if [[ -z $REPO_FULL ]]; then
  echo "Error: Not a GitHub repository"
  exit 1
fi

# Create temp branch
echo "Creating temp branch: $TEMP_BRANCH"
git checkout -b $TEMP_BRANCH 2>/dev/null || git switch -C $TEMP_BRANCH

# Add files
git add "${FILES[@]}"
git commit -m "Jules review: ${FILES[*]}"

# Push
echo "Pushing to origin..."
git push -u origin $TEMP_BRANCH

# Get owner/repo
OWNER=$(echo $REPO_FULL | cut -d'/' -f1)
REPO=$(echo $REPO_FULL | cut -d'/' -f2)

# Default prompt
DEFAULT_PROMPT="Review these files for: portability compliance, quality standards, and best practices. Focus on: 1) Zero .claude/rules dependencies, 2) Success Criteria present, 3) Progressive disclosure structure"
PROMPT="${CUSTOM_PROMPT:-$DEFAULT_PROMPT}"

# Create Jules session
echo "Creating Jules session..."
RESPONSE=$(curl -s -X POST https://jules.googleapis.com/v1alpha/sessions \
  -H "X-Goog-Api-Key: $JULES_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"prompt\": \"${PROMPT}\\n\\nFiles to review: ${FILES[*]}\",
    \"sourceContext\": {
      \"source\": \"sources/github/${OWNER}/${REPO}\",
      \"githubRepoContext\": {
        \"startingBranch\": \"${TEMP_BRANCH}\"
      }
    },
    \"automationMode\": \"AUTO_CREATE_PR\"
  }")

SESSION_ID=$(echo $RESPONSE | jq -r '.id')
SESSION_URL=$(echo $RESPONSE | jq -r '.url')

echo ""
echo "✅ Session created!"
echo "   ID: $SESSION_ID"
echo "   URL: $SESSION_URL"
echo ""
echo "Monitor with:"
echo "   curl https://jules.googleapis.com/v1alpha/sessions/$SESSION_ID"
echo ""
echo "Press Enter to switch back to main branch (temp branch kept for reference)..."
read

git checkout -
echo "Temp branch '$TEMP_BRANCH' kept. Delete when done:"
echo "   git branch -D $TEMP_BRANCH"
echo "   git push origin --delete $TEMP_BRANCH"
\`\`\`

2. Make it executable:
\`\`\`bash
chmod +x .claude/commands/jules/review-local.sh
\`\`\`
