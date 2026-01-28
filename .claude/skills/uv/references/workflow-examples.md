# uv Workflow Examples

Complete, copy-pasteable workflows for common Python development tasks.

---

## New Project From Scratch

```bash
# 1. Create and enter project
uv init myapi
cd myapi

# 2. Set Python version
uv python pin 3.12

# 3. Add dependencies
uv add fastapi uvicorn pydantic
uv add --dev pytest pytest-cov ruff httpx

# 4. Create lockfile
uv lock

# 5. Create environment and install
uv sync

# 6. Create basic app
cat > main.py << 'EOF'
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"hello": "world"}
EOF

# 7. Run the app
uv run uvicorn main:app --reload

# 8. Verify everything works
uv run pytest
uv run ruff check .
```

---

## Migrating from pip/requirements.txt

```bash
# 1. Initialize new project (or skip if existing)
uv init

# 2. Convert requirements.txt
uv add -r requirements.txt

# 3. Create lockfile
uv lock

# 4. Test that everything works
uv sync
uv run pytest    # if you have tests

# 5. Clean up old files
rm requirements.txt
# (optional) rm -rf venv/  # old virtualenv
```

---

## Migrating from Poetry

```bash
# 1. Backup existing pyproject.toml
cp pyproject.toml pyproject.poetry.backup

# 2. Initialize with uv (keeps same name)
uv init --lib

# 3. Manually migrate dependencies
# Extract from [tool.poetry.dependencies] and [tool.poetry.dev-dependencies]
# Then add with uv:
uv add <production-deps>
uv add --dev <dev-deps>

# 4. Create lockfile
uv lock

# 5. Test
uv sync
uv run pytest

# 6. Update pyproject.toml to remove Poetry sections
```

---

## Standalone Script with PEP 723

```bash
# 1. Create script
cat > scrape.py << 'EOF'
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "requests",
#     "beautifulsoup4",
# ]
# ///

import requests
from bs4 import BeautifulSoup

url = "https://example.com"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'html.parser')
print(soup.title.string)
EOF

# 2. Run script (uv auto-honors the metadata)
uv run scrape.py

# 3. Lock script (optional, for sharing)
uv lock --script scrape.py

# 4. Add additional dependency
uv add --script scrape.py rich

# 5. Run with temporary extra dep
uv run --with lxml scrape.py
```

---

## GitHub Actions CI

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Install uv
        uses: astral-sh/setup-uv@v6

      - name: Set up Python
        run: uv python install 3.12

      - name: Install dependencies
        run: uv sync --frozen --all-extras

      - name: Run tests
        run: uv run pytest

      - name: Run linter
        run: uv run ruff check .

      - name: Check formatting
        run: uv run ruff format --check .
```

---

## Docker Multi-stage Build

```dockerfile
# Builder stage
FROM python:3.12-slim AS builder

# Install uv
RUN pip install uv

WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-dev

# Runtime stage
FROM python:3.12-slim

WORKDIR /app

# Copy uv and virtualenv from builder
COPY --from=builder /usr/local/bin/uv /usr/local/bin/uv
COPY --from=builder /app/.venv /app/.venv

# Copy application
COPY . .

# Make sure we use the virtualenv
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

# Run the app
CMD ["uv", "run", "python", "-m", "myapp"]
```

---

## Docker Single-stage (Simpler)

```dockerfile
FROM python:3.12-slim

# Install uv
RUN pip install uv

WORKDIR /app

# Copy dependency files first for caching
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-dev

# Copy application code
COPY . .

# Use .venv in PATH
ENV PATH="/app/.venv/bin:$PATH"

# Run the app
CMD ["python", "-m", "myapp"]
```

---

## Pre-commit Configuration

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: ruff
        name: Ruff
        entry: uv run ruff check --fix
        language: system
        types: [python]

      - id: ruff-format
        name: Ruff Format
        entry: uv run ruff format
        language: system
        types: [python]

      - id: mypy
        name: MyPy
        entry: uv run mypy
        language: system
        types: [python]
        pass_filenames: false

      - id: pytest
        name: Pytest
        entry: uv run pytest
        language: system
        pass_filenames: false
        always_run: true
```

Install hooks:

```bash
uv add --dev pre-commit
uv run pre-commit install
```

---

## Monorepo Workspace Setup

```bash
# 1. Create workspace root
mkdir mymonorepo
cd mymonorepo

# 2. Initialize root
uv init --lib
rm src/mymonorepo/__init__.py  # cleanup

# 3. Create workspace configuration
cat > pyproject.toml << 'EOF'
[project]
name = "mymonorepo"
version = "0.1.0"

[tool.uv.workspace]
members = ["packages/*", "apps/*"]

[tool.uv.sources]
shared = { workspace = true }
EOF

# 4. Create packages
mkdir -p packages/shared
cd packages/shared
uv init --lib
echo "# Shared utilities" > src/shared/utils.py
cd ../..

mkdir -p apps/webapp
cd apps/webapp
uv init

# 5. Add workspace dependency
cat >> pyproject.toml << 'EOF'

[tool.uv.sources]
shared = { workspace = true }
EOF

uv add shared
cd ../..

# 6. Lock entire workspace
uv lock

# 7. Run specific package
uv run --package webapp python -m webapp
uv build --package shared
```

---

## Development Workflow

```bash
# Start new feature
git checkout -b feature/new-endpoint

# Add dependency for feature
uv add pydantic-settings

# Make changes
vim src/myapp/endpoints.py

# Run tests continuously
uv run pytest --watch

# Format and lint
uv run ruff format .
uv run ruff check --fix .

# Update lock if needed
uv lock

# Run tests one more time
uv run pytest

# Commit
git add pyproject.toml uv.lock
git commit -m "Add new endpoint with settings"
```

---

## Production Deployment Checklist

```bash
# 1. Update lockfile
uv lock

# 2. Freeze lockfile (check it's committed)
git add uv.lock
git commit -m "Update lockfile for production"

# 3. Test with frozen lock
uv sync --frozen
uv run pytest

# 4. Build for production
uv build

# 5. Test wheel
uv pip install dist/myapp-0.1.0-py3-none-any.whl
python -m myapp --version

# 6. Publish (when ready)
uv publish --publish-url https://pypi.org
```

---

## Troubleshooting Session

```bash
# Problem: Import error
uv run python -c "import myapp"
# ImportError: No module named 'requests'

# Solution: Check if dependency is installed
uv pip list | grep requests

# If not installed, add and sync
uv add requests
uv sync

# Problem: Lockfile conflict
uv lock
# Error: Solving failed...

# Solution: Try updating the problematic package
uv lock --upgrade requests

# Or check what's conflicting
uv tree | grep requests

# Problem: Cache corruption
uv run pytest
# Error: Checksum mismatch...

# Solution: Clean cache
uv cache clean
uv sync

# Problem: Wrong Python version
uv add numpy
# Error: numpy requires Python>=3.10

# Solution: Pin correct version
uv python pin 3.11
uv add numpy
```

---

## Dependency Update Workflow

```bash
# 1. Update specific package
uv lock --upgrade-package requests

# 2. Update all packages
uv lock --upgrade

# 3. Review changes
uv diff

# 4. Run tests
uv sync
uv run pytest

# 5. If tests fail, update one at a time
uv lock --upgrade-package pytest
uv sync
uv run pytest

# Repeat until all updated
```

---

## Quick Reference Card

```bash
# Project lifecycle
uv init → uv add → uv lock → uv sync → uv run

# Common patterns
uv add <pkg>           # Add dependency
uv run pytest          # Run tests
uvx ruff check .       # Run tool
uv sync --frozen       # CI sync

# Migration
uv init && uv add -r requirements.txt

# Debugging
uv tree                # Show dependency tree
uv cache clean         # Clear cache
uv pip list            # List installed
```
