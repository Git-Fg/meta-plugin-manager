---
name: uv
description: "Manage Python packages and projects using uv. Use when installing dependencies, creating virtual environments, running Python code, or managing Python projects. Includes dependency resolution, lock file management, tool installation, and script execution. Not for non-Python package management or when explicitly requested to use pip/poetry/conda."
---

# uv — Modern Python Package and Project Management

<mission_control>
<objective>Use uv as the single source of truth for all Python packaging and environment management</objective>
<success_criteria>Python project uses uv consistently, with standalone scripts preferred over projects unless explicitly requested</success_criteria>
</mission_control>

<trigger>When working with Python projects (pyproject.toml/uv.lock), managing dependencies, running Python code/tests, installing CLI tools (ruff, pytest), or migrating from pip/poetry/conda.</trigger>

<mission_control>

### 1. Simplicity Through Standalone Scripts

**Why standalone scripts succeed**: PEP 723 metadata in single files eliminates boilerplate while keeping dependencies portable. Scripts become self-documenting and executable—the full environment context travels with the code.

**Practice**: Default to `uv init --script` or manual PEP 723 for quick utilities, data processing, or one-off tasks. The script shebang `#!/usr/bin/env -S uv run` makes files directly executable without activation steps.

**Success outcome**: Zero setup friction—copy the script, run it anywhere. No project initialization, no venv management, no environment conflicts.

### 2. Performance Through Global Cache Sharing

**Why caching succeeds**: uv's shared cache deduplicates downloads across all projects, scripts, and tools. A package downloaded once becomes instantly available to every context on the machine.

**Practice**: Trust the cache. Dependencies installed for one project are immediately available to others. Warm cache makes project switching nearly instantaneous.

**Success outcome**: 8-115× faster than pip (benchmarks: 2.6s vs 21.4s for JupyterLab, 80-115× speedup on hot cache).

### 3. Reproducibility Through Lockfiles

**Why lockfiles succeed**: `uv.lock` contains exact versions, URLs, and platform markers. One file works across Linux, macOS, and Windows—eliminating "works on my machine" issues.

**Practice**: Commit `uv.lock` to version control. Use `uv sync --frozen` in CI to detect drift. Lock scripts with `uv lock --script script.py` for temporal reproducibility.

**Success outcome**: Identical behavior across all environments and time. New releases don't break existing deployments when using `exclude-newer` for temporal constraints.

### 4. Consistency Through Automatic Environment Management

**Why automatic management succeeds**: `uv run` verifies and synchronizes environments before each execution. No manual activation, no forgotten `pip install`, no desynchronized state.

**Practice**: Use `uv run` for all execution. It handles venv creation, dependency updates, and Python version selection automatically.

**Success outcome**: Zero "works locally but fails in CI" issues. Every run starts from a verified, synchronized state.

### 5. Tool Choice Based on Task Complexity

**Why task-based choice succeeds**: Not every Python task needs a project structure. Matching tool complexity to task complexity reduces cognitive load and maintenance burden.

**Practice**: Choose standalone scripts for single-file tasks. Create full projects only when explicitly requested or when the task requires multiple files, tests, or publishing. Use `uv pip` interface only for legacy environments that cannot be converted.

**Success outcome**: Right-sized solutions. Quick tasks stay quick. Complex tasks get proper structure without premature overhead.


DETECT CONTEXT → SELECT MODE → EXECUTE WORKFLOW → VALIDATE
</interaction_schema>

uv is Astral's fast Python package and project manager. Use uv as the single source of truth for Python packaging and environments unless explicitly told otherwise.

## Quick Start

**Install package:** `uv add <package>` → Updates pyproject.toml + uv.lock

**Run script:** `uv run script.py` → Creates temp environment, runs, cleans up

**Create project:** `uv init` → New project with pyproject.toml

**Run project commands:** `uv run pytest` → Executes in project environment

**Why:** uv is 10-100x faster than pip—global cache shared across all projects and scripts.

This skill integrates with Claude Code native tools for optimal execution:

## Operational Patterns

This skill follows these behavioral patterns:

- **Execution**: Execute system commands for uv operations
- **Tracking**: Maintain a visible task list for Python project setup

Trust the System Prompt to select the correct native implementation for these patterns.

## Navigation

| If you need...       | Read...                         |
| :------------------- | :------------------------------ |
| Install package      | ## Quick Start → uv add         |
| Run script           | ## Quick Start → uv run script  |
| Create project       | ## Quick Start → uv init        |
| Run project commands | ## Quick Start → uv run pytest  |
| Script vs project    | See PEP 723 for inline metadata |

---

## Detect Your Context

<context>
Three modes, one unified tool:

| Context                | Indicator                        | Mode               |
| ---------------------- | -------------------------------- | ------------------ |
| **uv project**         | `pyproject.toml` with `uv.lock`  | Project mode       |
| **standalone script**  | Single `.py` with `# /// script` | Script mode        |
| **legacy environment** | `requirements.txt` or `setup.py` | Pip interface mode |

</context>

---

## Mode Decision Router

<router>
flowchart TD
    Start[Python task] --> Exists{Project exists?}
    Exists -->|Yes, pyproject.toml| UV[uv project mode]
    Exists -->|No| TaskType{Task type?}

    TaskType -->|Single file/quick| Script[standalone script mode]
    TaskType -->|User requested project| UVInit[create new project]
    TaskType -->|Multi-file/tests/publish| UVInit
    TaskType -->|requirements.txt only| Legacy[legacy mode]

    UV --> UVRun[uv add/lock/sync/run]
    Script --> ScriptRun[uv run script.py with PEP 723]
    UVInit --> Init[uv init]
    Legacy --> UVPip[uv pip install/sync]

    UVRun --> Done[Execute workflow]
    ScriptRun --> Done
    Init --> Done
    UVPip --> Done

</router>

**Priority**: Standalone scripts > Projects. Only create pyproject.toml when explicitly requested or task requires it.

---

## Core Workflows

### Standalone Scripts (PEP 723) — PREFERRED for Single-File Tasks

**Default to standalone scripts for quick tasks, single-file utilities, or when the user hasn't explicitly requested a project structure.**

```bash
# Create script with PEP 723 metadata
uv init --script script.py --python 3.12

# OR manually create script with inline dependencies:
cat > myscript.py << 'EOF'
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "requests",
#     "rich",
# ]
# ///

import requests
from rich import print

# Your code here
EOF

# Run script (uv auto-honors PEP 723 metadata)
uv run myscript.py

# Add/remove script dependencies
uv add --script myscript.py beautifulsoup4
uv remove --script myscript.py rich

# Run with temporary extra dependency
uv run --with httpx myscript.py

# Lock script for reproducibility (optional)
uv lock --script myscript.py    # generates myscript.py.lock
```

**When to use standalone scripts:**

- Quick utilities or one-off tasks
- Single-file scripts that need dependencies
- Data processing or scraping scripts
- Prototyping before committing to a project
- When user hasn't explicitly requested a "project"

**PEP 723 metadata format:**

```python
#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "requests>=2.28",
#     "rich",
# ]
#
# [tool.uv]
# exclude-newer = "2026-01-01T00:00:00Z"  # Optional: temporal reproducibility
# ///

import requests
from rich import print
```

**Temporal reproducibility (optional):**

Add `exclude-newer` in `[tool.uv]` to limit dependencies to those published before a specific date (RFC 3339 format). This guarantees identical behavior even as new package versions are released.

**Making scripts directly executable:**

- Add shebang `#!/usr/bin/env -S uv run` at the top
- Run `chmod +x script.py` to make executable
- Execute directly: `./script.py`

**uv run options for scripts:**

- `uv run --python 3.13 script.py` - Force specific Python version
- `uv run --with "dep==version" script.py` - Add temporary dependency
- `uv run --no-cache script.py` - Bypass cache for debugging
- `uv run --isolated script.py` - Create isolated environment (useful in CI)

**Advanced uv run patterns:**

```bash
# Run from stdin
echo 'print("hello")' | uv run -

# Run script from URL
uv run https://raw.githubusercontent.com/user/repo/main/script.py
```

---

### New Project — ONLY when Explicitly Requested or Required

```bash
# Initialize project (creates app with main.py)
uv init myproject
cd myproject

# OR initialize library project
uv init --lib mylib

# uv init creates:
# - pyproject.toml (project metadata)
# - .gitignore (well-configured)
# - .python-version (Python version pin)
# - README.md (basic template)
# - main.py (for apps) or src/ structure (for libs)

# Set Python version (optional but recommended)
uv python pin 3.12

# Add dependencies
uv add requests "flask>=2.0,<3.0" pydantic
uv add --dev pytest pytest-cov ruff

# Lock and sync
uv lock      # creates uv.lock
uv sync      # creates .venv and installs

# Run things
uv run python main.py
uv run pytest
uv run ruff check .
```

**uv run automatic verification:**

Before executing, `uv run` automatically:

- Verifies `pyproject.toml` and `uv.lock` are synchronized
- Updates `.venv` if lockfile or dependencies changed
- Ensures environment consistency before each command

This eliminates "works on my machine" issues caused by desynchronized environments.

### Day-to-Day Project Work

```bash
# Add dependencies
uv add <package>                    # production
uv add --dev <package>              # development
uv add --group docs <package>       # optional group

# Remove dependencies
uv remove <package>
uv remove --dev <package>

# Keep environment consistent
uv lock      # after modifying pyproject.toml
uv sync      # update .venv from uv.lock

# Run commands in project context
uv run python script.py
uv run -m pytest
uv run -m flask run --port 8000

# Build and publish
uv build              # wheel + sdist
uv publish            # publish to PyPI
```

**Modern pyproject.toml with dependency-groups:**

```toml
[project]
name = "myapp"
version = "0.1.0"
requires-python = ">=3.12"
dependencies = [
  "fastapi>=0.115",
  "pydantic>=2",
]

[dependency-groups]
dev = ["pytest>=8", "ruff>=0.7"]
docs = ["mkdocs>=1.6"]

[tool.uv]
managed = true  # Let uv manage .venv and uv.lock
```

**When to create a project:**

- User explicitly requests a "project" or "package"
- Multiple files/modules are needed
- Tests are required
- Publishing to PyPI is planned
- Workspace/monorepo structure is needed

### Running Tools

```bash
# One-off tool usage
uvx ruff check .
uvx black .
uvx ruff@0.3.0 check .    # specific version

# Persistent tools
uv tool install ruff black mypy
uv tool list
uv tool uninstall ruff
```

### Python Version Management

```bash
# Install Python versions
uv python install 3.12
uv python install 3.12 3.13    # Install multiple versions
uv python list                 # List available versions

# Upgrade installed Python to latest patch
uv python upgrade 3.13

# Pin project to specific version
uv python pin 3.12    # creates .python-version

# Find available versions
uv python find 3.12    # Find matching 3.12.x version
```

### Virtual Environments

```bash
# Create venv (rarely needed in uv projects)
uv venv                # creates .venv
uv venv --python 3.11

# Activate normally
source .venv/bin/activate    # Unix
.venv\Scripts\activate       # Windows
```

**Note**: In uv projects, `uv sync` and `uv run` manage the venv automatically. Use `uv venv` only for legacy projects.

---

## Legacy Pip Interface

Use ONLY when working with legacy environments that cannot be converted to uv projects:

```bash
# Install packages
uv pip install flask requests
uv pip install -r requirements.txt

# Lock and sync requirements.txt style
uv pip compile requirements.in -o requirements.lock
uv pip compile --universal requirements.in -o requirements.txt    # Multi-platform
uv pip sync requirements.lock

# Inspect environments
uv pip list
uv pip show <pkg>
uv pip tree
uv pip check
```

**Platform-specific dependencies migration:**

For projects with platform-specific requirements (previously multiple requirements files), use:

```bash
uv pip compile --universal requirements.in -o requirements.txt
```

This generates a single requirements.txt with appropriate platform markers, which can then be imported into a uv project.

---

## Workspaces (Monorepo)

Root `pyproject.toml`:

```toml
[tool.uv.workspace]
members = ["packages/*", "apps/*"]
exclude = ["packages/deprecated"]
```

Workspace dependencies:

```toml
[project]
name = "myapp"
dependencies = ["shared-lib", "core-utils"]

[tool.uv.sources]
shared-lib = { workspace = true }
core-utils = { workspace = true }
my-private-pkg = { git = "https://github.com/user/repo.git" }
local-pkg = { path = "../local-package" }
```

uv automatically handles Git repositories and local path dependencies via `[tool.uv.sources]`.

Commands:

```bash
uv lock                          # single lockfile for all members
uv sync --all-packages           # sync all workspace members
uv run --package my-package python script.py
uv build --package my-package
```

**Workspace constraint:**

Workspaces impose a single `requires-python` constraint for all members, calculated as the intersection of all member requirements. If a package needs testing on an unsupported Python version, use path dependencies with separate projects instead.

**uv.lock is universal across platforms:**

- One lockfile works for Linux, macOS, and Windows
- Replaces multiple platform-specific requirements files
- Contains exact versions, URLs, and platform markers
- Commit uv.lock for reproducible builds across all platforms
- Never edit uv.lock manually - it's generated automatically

---

## CI and Docker

### GitHub Actions Pattern

```yaml
- name: Set up uv
  uses: astral-sh/setup-uv@v6

- name: Cache uv
  uses: actions/cache@v4
  with:
    path: ~/.cache/uv
    key: ${{ runner.os }}-uv-${{ hashFiles('**/uv.lock') }}
    restore-keys: |
      ${{ runner.os }}-uv-

- run: uv python install 3.12
- run: uv sync --frozen --all-extras # fail if lockfile out of date
- run: uv run pytest
- run: uv run ruff check .
```

**CI cache best practices:**

- Use `UV_CACHE_DIR` environment variable for explicit cache location
- Include uv.lock hash in cache key for automatic invalidation
- Run `uv cache prune` periodically in CI to prevent unbounded growth

### Docker Pattern

```dockerfile
# Install uv (official installer)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Copy project files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-dev

# Use .venv as environment
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1
CMD ["python", "main.py"]
```

---

## Troubleshooting

| Symptom                    | Solution                                                                |
| -------------------------- | ----------------------------------------------------------------------- |
| "Externally managed" error | Use virtualenv: `uv venv`                                               |
| Build failures             | Check for missing compilers/headers, try tightening version constraints |
| Lockfile out of sync       | Run `uv lock` to regenerate `uv.lock`                                   |
| Cache issues               | Run `uv cache clean` or `uv cache prune`                                |
| Wrong Python version       | Run `uv run --python 3.13 script.py` to force version                   |

### Cache Management

```bash
uv cache dir          # Show cache location
uv cache clean        # Clear all caches
uv cache prune        # Remove unused entries only
```

**Cache location by platform:**

- macOS/Linux: `$HOME/.cache/uv` or `$XDG_CACHE_HOME/uv`
- Windows: `%LOCALAPPDATA%\uv\cache`
- Override with `UV_CACHE_DIR` environment variable

**Global cache sharing:**

uv's cache is shared across:

- All projects on the same machine
- Standalone PEP 723 scripts
- Tools installed via `uv tool`

This deduplication means:

- Downloading a package once makes it available to all contexts
- Switching between projects is nearly instantaneous with warm cache
- Disk usage is minimized across the entire development environment

**Ephemeral environments:**

- PEP 723 scripts create isolated environments per execution
- These environments are cached and reused for subsequent runs
- No manual environment management required
- Each script runs in its own sandbox, preventing dependency conflicts

---

## Migration Patterns

### From pip/requirements.txt

**Best practice with constraints (preserves locked versions):**

```bash
# Initialize new project
uv init

# Import with constraints (preserves exact versions from requirements.txt)
uv add -r requirements.in -c requirements.txt

# For dev dependencies
uv add --dev -r requirements-dev.in -c requirements-dev.txt

# For custom groups
uv add --group docs -r requirements-docs.in -c requirements-docs.txt

# Lock and sync
uv lock
uv sync
```

**Simple migration (for loose requirements):**

```bash
uv init
uv add -r requirements.txt
uv sync
```

### From Poetry

```bash
# Initialize new project
uv init --lib || uv init
cp pyproject.toml pyproject.backup

# Manually migrate dependencies from Poetry sections
# Extract from [tool.poetry.dependencies] and add with uv:
uv add <production-deps>
uv add --dev <dev-deps>

# Lock and test
uv lock
uv sync
uv run pytest
```

### Export to Other Formats

```bash
# Export to PEP 751 pylock.toml for interoperability
uv export -o pylock.toml

# Export to requirements.txt format
uv export -o requirements.txt
```

---

## Summary

**Default to uv for all Python packaging work.**

**Priority: Standalone scripts > Projects. Use standalone scripts with PEP 723 for single-file tasks.**

**Key principles for 2026:**

- **Standalone scripts (preferred)**: `uv init --script` or manual PEP 723 → `uv run script.py`
  - Use shebang `#!/usr/bin/env -S uv run` for executable scripts
  - Add inline dependencies with `uv add --script script.py <pkg>`
  - Lock scripts for reproducibility with `uv lock --script script.py`
  - Use `exclude-newer` for temporal reproducibility (optional)

- **Projects (only when explicitly requested)**: `uv init` → `uv add` → `uv lock` → `uv sync` → `uv run`
  - `uv init --app` for applications, `uv init --lib` for libraries
  - Creates: pyproject.toml, .gitignore, .python-version, README.md, main.py
  - Use `[dependency-groups]` instead of multiple requirements files
  - `uv.lock` is universal across platforms (one file for Linux/macOS/Windows)

- **CLI tools**: `uvx <tool>` for one-offs, `uv tool install` for frequent use

- **Migration**:
  - Prefer `uv add -r requirements.in -c requirements.txt` to preserve locked versions
  - Use `uv pip compile --universal` for platform-specific dependencies
  - Git and path dependencies auto-handled via `[tool.uv.sources]`

- **CI/Docker**:
  - Use `UV_CACHE_DIR` for explicit cache location
  - Cache `~/.cache/uv` with uv.lock in cache key
  - Use `uv sync --frozen` to catch lockfile drift
  - Use `uv run --isolated` for clean CI environments

- **Performance** (quantified benchmarks from RealPython):
  - JupyterLab install: 2.6s (uv) vs 21.4s (pip) = **8× faster**
  - requirements.txt: 2.17s (uv) vs 9.97s (pip) = **4.6× faster**
  - Cold cache: **8-10× faster** than pip
  - Hot cache: **80-115× faster** than pip
  - Due to Rust implementation, parallel downloads, and global cache sharing

---

## Common Mistakes to Avoid

### Mistake 1: Forgetting `uv sync` After `uv add`

❌ **Wrong:**
```bash
uv add requests flask
uv run pytest  # Environment not synced, might use old deps
```

✅ **Correct:**
```bash
uv add requests flask
uv sync  # Always sync after modifying dependencies
uv run pytest
```

### Mistake 2: Using `uv venv` on Existing Project

❌ **Wrong:**
```bash
uv init myproject
uv venv  # Wipes .venv if it existed
uv sync  # Re-creates environment from scratch
```

✅ **Correct:**
```bash
uv init myproject
uv sync  # Creates .venv automatically
uv run pytest  # Uses the managed environment
# Only use uv venv for legacy projects without uv.lock
```

### Mistake 3: Not Using `--frozen` in CI

❌ **Wrong:**
```yaml
- run: uv sync  # Succeeds even if lockfile out of sync
- run: uv run pytest
```

✅ **Correct:**
```yaml
- run: uv sync --frozen  # Fails if lockfile needs update
- run: uv run pytest
```

### Mistake 4: Wrong Workspace Member Patterns

❌ **Wrong:**
```toml
[tool.uv.workspace]
members = ["packages/"]  # Creates packages/ sub-workspace, not individual packages
```

✅ **Correct:**
```toml
[tool.uv.workspace]
members = ["packages/*"]  # Each package in packages/ is a workspace member
```

### Mistake 5: Not Caching UV in CI

❌ **Wrong:**
```yaml
- run: uv sync  # Downloads every package every run
```

✅ **Correct:**
```yaml
- name: Cache uv
  uses: actions/cache@v4
  with:
    path: ~/.cache/uv
    key: ${{ runner.os }}-uv-${{ hashFiles('**/uv.lock') }}
- run: uv sync --frozen
```

### Mistake 6: Mixing Package Managers

❌ **Wrong:**
```bash
uv add requests
pip install flask  # Creates conflicting environment
```

✅ **Correct:**
```bash
uv add requests flask  # Use uv for ALL package management
# If legacy: uv pip install flask
```

---

## Validation Checklist

Before claiming uv usage complete:

**Project Setup:**
- [ ] Determined context (project vs script vs legacy)
- [ ] Used appropriate mode (uv project, PEP 723 script, or uv pip)

**Dependency Management:**
- [ ] Used `uv add` for projects, `uv add --script` for scripts
- [ ] Ran `uv sync` after modifying dependencies
- [ ] Committed uv.lock for reproducibility

**Execution:**
- [ ] Used `uv run` for all script/project execution
- [ ] Scripts use PEP 723 metadata format

**CI/CD:**
- [ ] Used `--frozen` to catch lockfile drift
- [ ] Cached `~/.cache/uv` for faster builds
- [ ] Used `--isolated` when clean environment needed

**Tool Usage:**
- [ ] Used `uvx` for one-off tools
- [ ] Used `uv tool install` for persistent tools

---

## Best Practices Summary

✅ **DO:**
- Use `uv run` for all execution (scripts, modules, project commands)
- Default to standalone scripts with PEP 723 for single-file tasks
- Create projects only when explicitly requested or task requires it
- Run `uv sync` after every `uv add` or `uv remove`
- Use `uv sync --frozen` in CI to detect lockfile drift
- Cache `~/.cache/uv` in CI for faster builds
- Use `uvx` for one-off tools, `uv tool install` for persistent tools
- Commit `uv.lock` to version control

❌ **DON'T:**
- Mix pip/poetry/conda with uv (pick one package manager)
- Skip `uv sync` after modifying dependencies
- Forget `--frozen` in CI (misses lockfile drift)
- Use `uv venv` on uv projects (environment managed automatically)
- Hardcode `["packages/"]` instead of `["packages/*"]` for workspaces
- Skip caching in CI (slow builds)
- Create projects for single-file tasks (use PEP 723 scripts)

---

## Absolute Constraints

<critical_constraint>
**Portability Invariant**: This skill must work standalone in any project with zero external dependencies to .claude/rules/ or other components.

**Tool Consistency**: Use uv as the single source of truth for Python packaging. Choose one package manager per project—mixing pip/poetry/conda with uv creates environment corruption that is difficult to debug and recover from.
</critical_constraint>

---

---
