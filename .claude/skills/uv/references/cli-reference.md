# uv CLI Reference

<fetch_protocol>
**MANDATORY FETCH**: Before using uv commands, fetch from https://docs.astral.sh/uv/

This contains the authoritative and complete CLI reference. The local content focuses on Seed System philosophy and workflow patterns.
</fetch_protocol>

---

## Seed System uv Philosophy

The Seed System uses uv for modern Python package management with these principles:

- **Speed**: uv is 10-100x faster than pip
- **Reliability**: Deterministic dependency resolution
- **Simplicity**: Single tool for all Python workflows
- **Compatibility**: Drop-in pip replacement

---

## Core Workflow Patterns

### Project Initialization

```bash
# Create new project
uv init my-project
cd my-project

# Add dependencies (auto-syncs environment)
uv add fastapi uvicorn
uv add --dev pytest ruff

# Run with project environment
uv run python main.py
uv run pytest
```

### Script Workflow

```bash
# Single-file Python script with inline dependencies
uv init --script app.py
uv add --script app.py requests pydantic

# Run script (manages virtualenv transparently)
uv run app.py
```

### Global Tools

```bash
# Install CLI tools globally
uv tool install ruff
uv tool install black
uv tool install mypy

# Run tools directly
uvx ruff check .
uvx black .
```

---

## Environment Management

uv automatically manages virtual environments:

```bash
# Environment created automatically at first dependency
uv add requests  # Creates .venv if needed

# Explicit venv creation (rarely needed)
uv venv --python 3.12

# Environment location
# - Project: .venv in project root
# - Global: ~/.local/share/uv/tool/
```

---

## Seed System Best Practices

### Dependency Organization

```bash
# Production dependencies
uv add fastapi pydantic

# Development dependencies (not installed in production)
uv add --dev pytest ruff mypy

# Optional dependency groups
uv add --group docs mkdocs-material
uv add --group test pytest-cov

# Install specific group
uv sync --group test
```

### Version Constraints

```bash
# Pin exact version
uv add "package==1.2.3"

# Minimum version
uv add "package>=1.0.0"

# Range constraint
uv add "package>=1.0.0,<2.0.0"

# From git repository
uv add "package @ git+https://github.com/user/repo.git"
```

### CI/CD Integration

```bash
# Frozen mode (requires up-to-date lockfile)
uv sync --frozen

# No development dependencies
uv sync --no-dev

# Specific Python version
uv run --python 3.12 script.py
```

---

## Common Seed System Workflows

### Adding New Dependencies

1. Search for package: `uv search <package>` (check availability)
2. Add to project: `uv add <package>`
3. Auto-sync: Environment updates automatically
4. Commit: `uv.lock` (lockfile) and `pyproject.toml`

### Updating Dependencies

```bash
# Update specific package
uv lock --upgrade-package <package>

# Update all (caution: may break)
uv lock --upgrade
```

### Type Safety Workflow

```bash
# Add type checker
uv add --dev mypy

# Install type stubs for packages
uv add --dev types-requests

# Run type checking
uv run mypy .
```

---

## Configuration (pyproject.toml)

Seed System projects use this structure:

```toml
[project]
name = "my-project"
version = "0.1.0"
dependencies = [
    "fastapi>=0.100.0",
    "pydantic>=2.0.0",
]

[project.optional-dependencies]
dev = ["pytest>=7.0", "ruff>=0.1.0", "mypy>=1.0.0"]

[tool.uv]
dev-dependencies = [
    "pytest>=7.0",
    "ruff>=0.1.0",
]

[tool.uv.workspace]
members = ["packages/*"]
```

---

## Migration from pip

```bash
# One-time migration
pip install uv
uv pip compile requirements.in -o requirements.lock
uv pip sync requirements.lock

# Then switch to native uv workflow
uv add <package>  # Instead of pip install
```

---

<critical_constraint>
MANDATORY: Consult https://docs.astral.sh/uv/ for complete command reference
MANDATORY: Use uv over pip for all new Seed System Python projects
MANDATORY: Commit uv.lock to version control for reproducibility
MANDATORY: Use --dev flag for development-only dependencies
No exceptions. uv provides superior performance and reliability.
</critical_constraint>
