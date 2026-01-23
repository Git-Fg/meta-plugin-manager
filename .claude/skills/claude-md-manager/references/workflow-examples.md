# CLAUDE.md Manager - Detailed Workflow Examples

Detailed examples and templates for each workflow.

## CREATE Workflow - Detailed Examples

### Investigation Commands
```bash
ls -la
cat package.json  # Get project name, scripts, deps
cat README.md     # Get description
find . -name "*.config.*" # Tech stack
find . -name "test*" -type d # Testing setup
```

### Template Selection
- **Web App**: React, Vue, Angular
- **API**: Express, FastAPI, Rails
- **Library**: npm package, gem, PyPI
- **CLI**: Command-line tools
- **Monorepo**: Multiple packages

### Generation Example
```markdown
# {Project Name}
{Brief description from README}

## Quick Start
```bash
{install command}
{start command}
```

## Commands
| Command | Purpose |
|---------|---------|
| {script} | {description} |

## Architecture
{directory structure and tech stack}

## {Testing/Deployment/etc}
{project-specific workflows}
```

### Output Format
```
## CLAUDE.md Created

### Quality Score: {score}/100
### Template: {type}
### Lines: {count}

### Sections
- Overview
- Commands
- Architecture
- {Testing/Deployment}
```

## ACTIVE-LEARN Workflow - Detailed Examples

### Learning Extraction Keywords
- "discovered", "found", "learned", "solution", "workaround", "command that works"
- Problem-solution conversation patterns
- Architecture insights and dependencies
- Configuration quirks and gotchas

### Example Conversation
```
User: The build keeps failing
Claude: Try `npm run clean` first
User: That worked! I didn't know about that command
```

### Integration Example
```markdown
## Commands
- `npm run clean` - Clear cache when build fails

## Gotchas
- Tests fail in CI → Use `--runInBand` flag
- Build OOM → Set `NODE_OPTIONS="--max-old-space-size=4096"`

## Architecture
Auth depends on crypto initialized first (import order matters)
```

### Validation Checklist
- [ ] No duplication
- [ ] Delta Standard maintained
- [ ] Score improved by ≥10 points

## REFACTOR Workflow - Detailed Examples

### Quality Assessment Checklist
- [ ] Score against 7-dimension framework
- [ ] Identify problem areas
- [ ] List violations

### Delta Standard Application
**Remove**:
- Tutorials
- Explanations
- Generic advice

**Keep**:
- Project-specific decisions
- Working commands
- Gotchas

**Focus**: "How we do it here"

### Modularization Example
```markdown
# CLAUDE.md (core)
@import rules/coding-style
@import rules/testing
@import rules/deployment
```

### Information Loss Check
- [ ] Verify critical knowledge retained
- [ ] Ensure no broken references
- [ ] Test all commands still work

### Output Format
```
## Refactored

### Quality: {old} → {new}/100
### Changes: {count} lines removed, modularized
### Structure: CLAUDE.md + rules/
```

## AUDIT Workflow - Detailed Examples

### Scoring Process
1. Score against 7-dimension framework
2. Generate detailed breakdown
3. Identify issues by priority
4. Provide specific recommendations
5. Suggest next workflow based on score

### Report Format
```
Quality: {score}/100 (Grade: {A/B/C/D/F})

Issues:
- {issue} ({impact} points)

Recommendations:
1. {action}
2. {action}
```

### Score-Based Actions
- **90-100 (A)**: No action needed
- **75-89 (B)**: Minor improvements (REFACTOR optional)
- **60-74 (C)**: Significant issues (REFACTOR recommended)
- **<60 (D/F)**: Major overhaul (REFACTOR required)

## Quick Templates

### Web App Template
```markdown
# {Name}
{Framework} + {Backend}

## Quick Start
```bash
npm install
npm start  # http://localhost:3000
```

## Commands
| Command | Purpose |
|---------|---------|
| `npm start` | Dev server |
| `npm test` | Run tests |
| `npm run build` | Production build |

## Architecture
- /src - Source code
- /public - Static assets
- {framework specifics}

## {Testing/Deployment}
{project-specific}
```

### API Template
```markdown
# {Name}
{REST/GraphQL} API with {tech}

## Endpoints
- GET /{resource}
- POST /{resource}
- {key endpoints}

## Commands
- `npm start` - Start server
- `npm test` - Run tests

## {Database/Auth}
{project-specific}
```

### Library Template
```markdown
# {Name}
{Type} library for {purpose}

## Installation
```bash
npm install {package-name}
```

## Usage
```javascript
import {something} from '{package-name}'
```

## Commands
- `npm test` - Run tests
- `npm run build` - Build for distribution

## {Testing/Publishing}
{project-specific}
```

### CLI Template
```markdown
# {Name}
Command-line tool for {purpose}

## Installation
```bash
npm install -g {package-name}
```

## Usage
```bash
{command-name} [options]
```

## Commands
- `{command-name}` - Main command
- `{command-name} --help` - Show help

## {Options/Flags}
{project-specific}
```

### Monorepo Template
```markdown
# {Name}
Monorepo with {count} packages

## Installation
```bash
npm install
```

## Commands
- `npm run build` - Build all packages
- `npm test` - Test all packages
- `npm run dev` - Start development mode

## Packages
- `/packages/{name}` - {description}
- `/packages/{name}` - {description}

## {Testing/Deployment}
{project-specific}
```

## Success Criteria

### CREATE Workflow
- [ ] Quality score ≥80/100
- [ ] Template matches project type
- [ ] Commands are accurate
- [ ] Architecture documented
- [ ] Delta Standard applied

### ACTIVE-LEARN Workflow
- [ ] Score improved by ≥10 points
- [ ] No duplication
- [ ] Delta Standard maintained
- [ ] Learnings properly integrated
- [ ] Commands validated

### REFACTOR Workflow
- [ ] Quality score ≥85/100
- [ ] No information loss
- [ ] Modular structure (if >300 lines)
- [ ] Delta Standard applied
- [ ] All commands still work

### AUDIT Workflow
- [ ] Complete 7-dimension scoring
- [ ] Detailed breakdown provided
- [ ] Priority issues identified
- [ ] Specific recommendations given
- [ ] Next workflow suggested

### Overall Quality Standards
- [ ] No duplication: Single source of truth
- [ ] Actionable: Commands work, copy-paste ready
- [ ] Delta Standard: Project-specific only
- [ ] Concise and human-readable
- [ ] Non-obvious gotchas documented

## Common Section Templates

### Commands Section
```markdown
## Commands
| Command | Purpose |
|---------|---------|
| `npm start` | Start development server |
| `npm test` | Run test suite |
| `npm run build` | Create production build |
```

### Architecture Section
```markdown
## Architecture
- /src - Source code
- /public - Static assets
- /tests - Test files

### Tech Stack
- Frontend: {framework}
- Backend: {framework}
- Database: {database}
```

### Gotchas Section
```markdown
## Gotchas
- Tests fail in CI → Use `--runInBand` flag
- Build OOM → Set `NODE_OPTIONS="--max-old-space-size=4096"`
- Import order matters → Auth must be initialized before other modules
```

### Workflow Section
```markdown
## Workflow
1. Run `npm install` to install dependencies
2. Run `npm start` to start development server
3. Run `npm test` before committing
4. Run `npm run build` for production deployment
```
