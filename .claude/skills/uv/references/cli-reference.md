# uv CLI Reference

Detailed command reference for uv. See official docs at https://docs.astral.sh/uv/

---

## Project Commands

### uv init

Initialize a new project.

```bash
uv init [project-name]              # Initialize new project
uv init --lib                       # Initialize library project
uv init --script script.py          # Initialize standalone script
uv init --app                       # Initialize application project
```

**Options:**

- `--python <version>` - Set Python version
- `--no-readme` - Skip README.md creation
- `--no-workspace` - Don't create workspace

### uv add

Add dependencies to the project.

```bash
uv add <package>                    # Add to production dependencies
uv add --dev <package>              # Add to dev dependencies
uv add --group <name> <package>     # Add to optional group
uv add "package>=1.0,<2.0"          # With version constraint
uv add package @ git+https://...    # From git repository
uv add package --index-url <url>    # From custom index
```

**Options:**

- `--dev` - Add to dev dependencies
- `--group <name>` - Add to optional dependency group
- `--extras <names>` - Include extras
- `--script <path>` - Add to script instead of project
- `--python <version>` - Require specific Python version

### uv remove

Remove dependencies from the project.

```bash
uv remove <package>
uv remove --dev <package>
uv remove --group <name> <package>
```

### uv lock

Create or update the lockfile.

```bash
uv lock                            # Update uv.lock
uv lock --upgrade <package>        # Upgrade specific package
uv lock --upgrade-package <package> # Same as above
uv lock --no-refresh               # Don't refresh package metadata
```

**Options:**

- `--upgrade` / `--upgrade-package` - Upgrade specific packages
- `--no-refresh` - Don't refresh package metadata
- `--script <path>` - Lock script instead of project

### uv sync

Synchronize the environment with the lockfile.

```bash
uv sync                            # Sync all dependencies
uv sync --frozen                   # Fail if lockfile out of date
uv sync --no-dev                   # Skip dev dependencies
uv sync --all-extras               # Include all optional extras
uv sync --group <name>             # Include specific group
```

**Options:**

- `--frozen` - Require up-to-date lockfile (CI mode)
- `--no-dev` - Skip development dependencies
- `--all-extras` - Include all optional dependency groups
- `--group <name>` - Include specific optional group
- `--no-build-isolation` - Disable build isolation

### uv run

Run commands in the project environment.

```bash
uv run python script.py            # Run Python script
uv run pytest                      # Run pytest
uv run -m pytest                   # Run as module
uv run --with <package> script.py  # Run with temporary extra dep
uv run --no-sync script.py         # Skip auto-sync
```

**Options:**

- `--with <package>` - Add temporary dependency
- `--no-sync` - Skip automatic sync
- `--no-active` - Don't use active environment
- `--python <version>` - Use specific Python version

---

## Script Commands

```bash
uv run script.py                   # Run script
uv add --script script.py <pkg>    # Add script dependency
uv remove --script script.py <pkg> # Remove script dependency
uv lock --script script.py         # Lock script
```

---

## Tool Commands (uvx/uv tool)

### uvx / uv tool run

Run tools in isolated environments.

```bash
uvx ruff check .                   # Run ruff
uvx ruff@0.3.0 check .             # Run specific version
uvx --from ruff black .            # Install from compatible package
uv tool run ruff check .           # Same as uvx
```

**Options:**

- `--from <package>` - Install from different package
- `--with <package>` - Include additional dependency
- `--python <version>` - Use specific Python version

### uv tool install

Install tools globally.

```bash
uv tool install ruff               # Install ruff
uv tool install ruff black mypy    # Install multiple
uv tool list                       # List installed tools
uv tool uninstall ruff             # Uninstall tool
uv tool update-shell               # Update shell integration
```

---

## Python Version Commands

```bash
uv python install 3.12             # Install Python 3.12
uv python install 3.12.1           # Install specific version
uv python list                     # List available versions
uv python list --only-installed    # List installed versions
uv python find 3.12                # Find matching version
uv python pin 3.12                 # Pin project to version
```

---

## Pip Interface Commands

```bash
uv pip install <package>           # Install package
uv pip install -r requirements.txt # Install from file
uv pip freeze                      # List installed packages
uv pip list                        # List installed packages
uv pip show <package>              # Show package details
uv pip uninstall <package>         # Uninstall package
uv pip check                       # Check for conflicts
uv pip tree                        # Show dependency tree
```

### uv pip compile

Compile requirements to lockfile format.

```bash
uv pip compile requirements.in -o requirements.lock
uv pip compile requirements.in --extra-index-url <url>
uv pip compile requirements.in --upgrade <package>
```

**Options:**

- `-o` / `--output-file` - Output file
- `--extra-index-url` - Additional package index
- `--upgrade` - Upgrade packages
- `--no-header` - Exclude generation header

### uv pip sync

Sync environment with requirements file.

```bash
uv pip sync requirements.txt       # Sync environment
uv pip sync requirements.lock      # Sync from lockfile
```

---

## Build and Publish

```bash
uv build                           # Build wheel and sdist
uv build --out-dir dist/           # Specify output directory
uv build --package <name>          # Build specific package (workspace)

uv publish                         # Publish to PyPI
uv publish --publish-url <url>     # Publish to custom URL
uv publish --token <token>         # Use auth token
```

---

## Virtual Environment Commands

```bash
uv venv                            # Create .venv
uv venv --python 3.11              # Create with specific Python
uv venv .venv-name                 # Create with custom name
```

---

## Cache Commands

```bash
uv cache dir                       # Show cache directory
uv cache clean                     # Clear all caches
uv cache prune                     # Remove unused cache entries
```

---

## Tree Commands

```bash
uv tree                            # Show project dependency tree
uv pip tree                        # Show environment dependency tree
uv tree --in-depth                 # Show full tree
uv tree --duplicate <name>         # Show duplicates
```

---

## Environment Variables

```bash
UV_CACHE_DIR=<path>                # Cache directory
UV_NO_CACHE=1                      # Disable cache
UV_INDEX_URL=<url>                 # Default package index
UV_EXTRA_INDEX_URL=<url>           # Additional package index
UV_PYTHON_INSTALL_DIR=<path>       # Python installations
UV_TOOL_DIR=<path>                 # Tool installations
UV_TOOL_BIN_DIR=<path>             # Tool binary directory
```

---

## Configuration (pyproject.toml)

```toml
[tool.uv]
dev-dependencies = [
    "pytest>=7.0",
    "ruff>=0.1",
]

[tool.uv.sources]
# Custom package sources
my-package = { workspace = true }
private-package = { url = "https://..." }

[tool.uv.workspace]
members = ["packages/*"]
exclude = ["packages/deprecated"]

[tool.uv.dependency-groups]
docs = ["sphinx", "sphinx-rtd-theme"]
test = ["pytest", "pytest-cov"]
```

---

## Common Flags (Global)

```bash
-v, --verbose                      # Increase verbosity
-q, --quiet                        # Decrease verbosity
--no-cache                         # Disable cache
--offline                          # Work offline
--python <version>                 # Python version constraint
```
