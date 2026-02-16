---
name: discover-standards
description: "Discover and document coding standards from an existing codebase into .claude/rules/ files. Use when: onboarding to a new project, joining a client codebase, or documenting undocumented conventions. Don't use when: project already has comprehensive .claude/rules/ or CLAUDE.md."
trigger: /discover-standards
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, AskUserQuestion
---

# Discover Standards

Scan a codebase to extract tribal knowledge, conventions, and patterns into `.claude/rules/` files that Claude Code reads automatically.

Inspired by Agent OS's discovery workflow, adapted for Neural Claude Code's existing infrastructure.

## Philosophy

Standards worth documenting are:
- **Non-obvious** — skip things any senior dev would assume
- **Opinionated** — choices your team made deliberately
- **Consistent** — patterns applied uniformly across the codebase
- **Token-efficient** — Claude reads these every turn; brevity is respect

## Process

### Step 1: Assess Current State

```bash
# Check what rules already exist
ls -la .claude/rules/ 2>/dev/null
cat .claude/CLAUDE.md 2>/dev/null | head -50
```

Report what's already documented. Don't duplicate.

### Step 2: Structural Scan

Analyze the project shape:

```bash
# Tech stack detection
ls package.json Cargo.toml pyproject.toml go.mod Gemfile requirements.txt composer.json *.csproj 2>/dev/null

# Framework detection
grep -l "next\|react\|vue\|angular\|svelte" package.json 2>/dev/null
grep -l "django\|flask\|fastapi" requirements.txt pyproject.toml 2>/dev/null

# Directory structure (depth 2)
find . -maxdepth 2 -type d -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/venv/*' | head -40

# File type distribution
find . -type f -not -path '*/node_modules/*' -not -path '*/.git/*' | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -15
```

From this, identify 3-5 **focus areas** (e.g., "API layer", "React components", "Database models", "Testing patterns", "State management").

### Step 3: Focus Area Selection

Present the focus areas to the user:

```
I've identified these focus areas in your codebase:

1. **API Layer** — 23 route files, Express + middleware pattern
2. **React Components** — 47 components, mix of class and functional
3. **Database** — Prisma ORM, 12 models
4. **Testing** — Jest + React Testing Library, 30% coverage
5. **State Management** — Redux Toolkit, 8 slices

Which areas should I analyze for undocumented standards?
```

Use `AskUserQuestion` to let user select 1-3 areas.

### Step 4: Deep Pattern Analysis

For each selected area, read 5-10 representative files. Look for:

| Signal | What to Extract |
|--------|----------------|
| **Unusual patterns** | Deviations from framework defaults |
| **Naming conventions** | File names, variable casing, prefixes/suffixes |
| **Import ordering** | Grouped? Sorted? Third-party vs local? |
| **Error handling** | Try/catch patterns, error types, logging |
| **Type patterns** | Interface vs type, naming, location |
| **File structure** | Co-location? Feature folders? Barrel exports? |
| **API conventions** | Response shapes, auth patterns, validation |
| **Test patterns** | Describe/it nesting, mock strategies, fixtures |
| **Comments/docs** | JSDoc? Inline? None? |
| **Git conventions** | Commit message format (check `git log --oneline -20`) |

For each pattern found, note:
- The pattern itself
- How consistently it's applied (check 3+ files)
- Whether it's obvious or needs documenting

### Step 5: Selective Extraction

Present 3-5 potential standards per area. For each:

```
**Potential Standard: API Response Envelope**
Found in 8/8 route handlers — all responses wrapped in `{ success, data, error }`.
This is consistent and non-obvious.

Document this? [Yes/Skip]
```

Use `AskUserQuestion` for selection. Don't batch — present one area at a time.

### Step 6: Why-Driven Documentation

For each selected standard, ask ONE clarifying question:

```
Why does your team use this pattern? (Helps me write the "Why" section)
- Convention inherited from a previous project
- Specific technical reason (e.g., frontend expects this shape)
- Team preference after trying alternatives
- Not sure / just happened organically
```

### Step 7: Write Rules Files

Create files in `.claude/rules/` following this format:

```markdown
# [Standard Name]

[Rule statement — lead with the rule, explain why second.]

## Pattern

```[language]
// Good
[example of correct usage]

// Avoid
[example of what NOT to do]
```

## Why

[1-2 sentences explaining the reasoning]

## Applies To

[File patterns or contexts where this rule matters, e.g., "All files in src/api/"]
```

**Naming convention**: `{area}-{pattern}.md`
- `api-response-format.md`
- `react-component-structure.md`
- `testing-mock-strategy.md`
- `git-commit-format.md`

### Step 8: Summary Report

After writing all rules:

```markdown
## Standards Discovered

| Rule File | Area | Pattern | Consistency |
|-----------|------|---------|-------------|
| api-response-format.md | API | Response envelope | 8/8 files |
| react-component-structure.md | Components | Feature folders | 12/15 dirs |

**Files created**: {n} rules in .claude/rules/
**Areas scanned**: {list}
**Skipped**: {n} patterns (too obvious or inconsistent)

These rules are now automatically loaded by Claude Code on every prompt.
```

## Output Format

```markdown
## Discover Standards: {project-name}

### Scan Results
- **Tech stack**: {detected}
- **Focus areas**: {n} identified, {n} selected
- **Files analyzed**: {n}

### Standards Created
| File | Pattern | Why |
|------|---------|-----|
| {filename} | {description} | {reason} |

### Skipped Patterns
- {pattern}: {reason for skipping}

---
{n} rules written to .claude/rules/
```

## Examples

### Example: Onboarding to a Django Project

```
/discover-standards
```

Discovers:
- `api-serializer-pattern.md` — All serializers use `SerializerMethodField` for computed fields
- `model-soft-delete.md` — All models inherit `SoftDeleteModel` with `is_active` field
- `testing-factory-pattern.md` — Tests use `factory_boy`, never raw `Model.objects.create()`
- `git-branch-naming.md` — Branches follow `type/JIRA-123-description` format

### Example: Onboarding to a Next.js Project

```
/discover-standards
```

Discovers:
- `react-server-components.md` — Default to RSC, `'use client'` only for interactivity
- `api-route-validation.md` — All API routes use Zod schemas in `lib/validations/`
- `state-zustand-stores.md` — Zustand over Redux, one store per feature in `stores/`
- `css-tailwind-conventions.md` — No custom CSS files, `cn()` utility for conditional classes

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No source files found | Empty or non-code project | Check you're in the right directory |
| Too many patterns | Large codebase | Narrow focus to 1-2 areas |
| Inconsistent patterns | No team conventions exist | Document what SHOULD be the standard (aspirational) |
| Rules dir doesn't exist | New project | Create `.claude/rules/` first |

**Fallback**: If interactive discovery fails, fall back to reading README, CONTRIBUTING.md, and .editorconfig for documented conventions.

## Integration

- Works with any project that has `.claude/` directory
- Rules auto-loaded by Claude Code (no injection step needed)
- Complements existing CLAUDE.md and .claude/rules/ files
- Run periodically as codebase evolves (`/discover-standards --refresh`)
