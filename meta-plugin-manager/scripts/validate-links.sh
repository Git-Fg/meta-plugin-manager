#!/bin/bash
# Link validation script for The Cat Toolkit v3
# Checks all internal markdown links from SKILL.md perspective
# Links are resolved relative to the skill root (where SKILL.md lives)

echo "=== The Cat Toolkit v3 Link Validation ==="
echo "Checking all markdown files for broken internal links..."
echo ""

BROKEN_LINKS=0
TOTAL_LINKS=0

# Find all skills (directories with SKILL.md)
find . -name "SKILL.md" -type f | sort > /tmp/skills.txt

while IFS= read -r skill_file; do
    echo "========================================"
    echo "Skill: $(dirname "$skill_file")"
    echo "========================================"

    skill_dir=$(dirname "$skill_file")

    # Find all markdown files in this skill
    find "$skill_dir" -name "*.md" -type f | sort > /tmp/md_files_in_skill.txt

    while IFS= read -r file; do
        # Extract markdown links, but skip those in code blocks
        # Use awk to remove code blocks first, then extract links
        awk '
        BEGIN { in_code = 0; line = "" }
        /^```/ {
            if (in_code == 0) {
                in_code = 1
            } else {
                in_code = 0
            }
            next
        }
        in_code == 0 {
            print
        }
        ' "$file" | grep -oE '\[[^]]+\]\([^)]+\)' | while IFS= read -r link; do
            # Extract URL from link
            url=$(echo "$link" | sed -E 's/.*\]\(([^)]+)\).*/\1/')

            # Skip external links
            if [[ "$url" =~ ^http:// ]] || [[ "$url" =~ ^https:// ]] || [[ "$url" =~ ^mailto: ]]; then
                continue
            fi

            TOTAL_LINKS=$((TOTAL_LINKS + 1))

            # All links should be relative to skill root
            # Correct formats: references/file.md, assets/file.md, legacy/file.md, examples/file.md
            if [[ "$url" =~ ^/ ]]; then
                # Absolute path (wrong - can't navigate above skill root)
                echo "  INVALID in $(basename "$file"): $link (absolute path not allowed)"
                BROKEN_LINKS=$((BROKEN_LINKS + 1))
            elif [[ "$url" =~ ^\.\./ ]]; then
                # Parent directory reference (wrong - can't navigate above skill root)
                echo "  INVALID in $(basename "$file"): $link (parent directory not allowed)"
                BROKEN_LINKS=$((BROKEN_LINKS + 1))
            elif [[ "$url" =~ ^# ]]; then
                # Anchor link - skip validation
                continue
            elif [[ "$url" =~ \.md$ ]]; then
                # .md file - resolve relative to skill root
                # But if the current file is in a subdirectory, resolve relative to that subdirectory
                dir=$(dirname "$file")
                if [[ "$dir" == "$skill_dir" ]]; then
                    # File is at skill root
                    target="${skill_dir}/${url}"
                else
                    # File is in a subdirectory (like references/), resolve relative to that
                    target="${dir}/${url}"
                fi

                if [[ ! -e "$target" ]]; then
                    echo "  BROKEN in $(basename "$file"): $link"
                    echo "    → Expected at: $target"
                    BROKEN_LINKS=$((BROKEN_LINKS + 1))
                fi
            else
                # Other type of link, skip validation
                continue
            fi
        done
    done < /tmp/md_files_in_skill.txt

    rm -f /tmp/md_files_in_skill.txt

done < /tmp/skills.txt

# Check non-skill markdown files (like root README.md)
echo ""
echo "========================================"
echo "Non-skill markdown files"
echo "========================================"

find . -name "*.md" -type f -not -path "*/skills/*" | sort > /tmp/non_skill_files.txt

while IFS= read -r file; do
    echo "Checking: $file"

    # Extract markdown links, but skip those in code blocks
    awk '
    BEGIN { in_code = 0; line = "" }
    /^```/ {
        if (in_code == 0) {
            in_code = 1
        } else {
            in_code = 0
        }
        next
    }
    in_code == 0 {
        print
    }
    ' "$file" | grep -oE '\[[^]]+\]\([^)]+\)' | while IFS= read -r link; do
        url=$(echo "$link" | sed -E 's/.*\]\(([^)]+)\).*/\1/')

        # Skip external links
        if [[ "$url" =~ ^http:// ]] || [[ "$url" =~ ^https:// ]] || [[ "$url" =~ ^mailto: ]]; then
            continue
        fi

        TOTAL_LINKS=$((TOTAL_LINKS + 1))

        # For non-skill files, use standard relative path resolution
        if [[ "$url" =~ ^# ]]; then
            # Anchor link - skip validation
            continue
        elif [[ "$url" =~ ^/ ]]; then
            target="${PWD}${url}"
        else
            dir=$(dirname "$file")
            target="${dir}/${url}"
            target=$(realpath "$target" 2>/dev/null)
        fi

        if [[ ! -e "$target" ]]; then
            echo "  BROKEN: $link"
            echo "    → Expected at: $target"
            BROKEN_LINKS=$((BROKEN_LINKS + 1))
        fi
    done

done < /tmp/non_skill_files.txt

rm -f /tmp/skills.txt /tmp/non_skill_files.txt

echo ""
echo "=== Results ==="
echo "Total links checked: $TOTAL_LINKS"
echo "Broken links: $BROKEN_LINKS"
echo ""

if [ $BROKEN_LINKS -eq 0 ]; then
    echo "✓ All links are valid!"
    exit 0
else
    echo "✗ Found $BROKEN_LINKS broken link(s)"
    exit 1
fi
