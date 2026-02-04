# Lesson 5: 6 Core Areas

## Objective

Learn the six areas every specification must cover for completeness.

## The 6 Core Areas

```
┌─────────────────────────────────────────────────────────────────┐
│                     6 CORE AREAS                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. COMMANDS      Full executable commands with flags           │
│  2. TESTING       Framework, locations, coverage expectations   │
│  3. STRUCTURE     Clear directory organization                  │
│  4. CODE STYLE    One real snippet > lengthy descriptions       │
│  5. GIT WORKFLOW  Branch naming, commit format, PR requirements │
│  6. BOUNDARIES    What agents should NEVER touch                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Area 1: Commands

**Don't say:** "Build the project"
**Do say:**
```bash
npm run build
npm run build:prod -- --sourcemap
npm run build:analyze
```

Give exact commands with all flags.

## Area 2: Testing

```yaml
testing:
  framework: jest           # or vitest, pytest, etc.
  location: tests/          # or __tests__, src/**/*.test.ts
  coverage_target: 80       # minimum coverage %
  run_before_commit: true

  commands:
    unit: "npm test"
    integration: "npm run test:integration"
    e2e: "npm run test:e2e"
```

## Area 3: Structure

```
src/
├── components/    # React components
├── hooks/         # Custom hooks
├── utils/         # Helper functions
├── api/           # API client
└── types/         # TypeScript types

tests/
├── unit/          # Unit tests
├── integration/   # Integration tests
└── e2e/           # End-to-end tests
```

## Area 4: Code Style

**Don't write paragraphs.** Show ONE example:

```typescript
// THIS is the style to follow:
async function fetchUser(id: string): Promise<User> {
  const response = await api.get(`/users/${id}`);
  if (!response.ok) {
    throw new ApiError(response.status, response.statusText);
  }
  return response.data;
}
```

One real example beats 100 words of description.

## Area 5: Git Workflow

```yaml
git_workflow:
  branch_naming: "feature/short-description"
  commit_format: "feat: description" # conventional commits
  pr_required: true
  review_required: true

  protected_branches:
    - main
    - production
```

## Area 6: Boundaries

What the AI should NEVER touch:

```yaml
boundaries:
  forbidden_files:
    - .env*
    - secrets/
    - production.config.js

  forbidden_actions:
    - Push to main
    - Delete database tables
    - Modify CI/CD config
```

## Checklist Template

Use this when writing any spec:

```markdown
## Specification Checklist

### 1. Commands
- [ ] Build: `___`
- [ ] Test: `___`
- [ ] Lint: `___`
- [ ] Dev: `___`

### 2. Testing
- [ ] Framework: ___
- [ ] Location: ___
- [ ] Coverage: ___%

### 3. Structure
- [ ] Source: ___
- [ ] Tests: ___
- [ ] Docs: ___

### 4. Code Style
- [ ] Example included

### 5. Git Workflow
- [ ] Branch format: ___
- [ ] Commit format: ___
- [ ] PR required: yes/no

### 6. Boundaries
- [ ] Protected files listed
- [ ] Forbidden actions listed
```

## Try It

Review your current project's CLAUDE.md. Does it cover all 6 areas?

```bash
# Check what's missing
cat .claude/CLAUDE.md
```

If areas are missing, add them!

## Check

Confirm you understand:

1. Specifications need all 6 areas for completeness
2. Commands must be exact (copy-pasteable)
3. One code example > paragraphs of description
4. Boundaries prevent accidents

## Next

**Lesson 6: 3-Tier Boundaries** - The safety system for autonomous agents.

```bash
/course lesson 6
```

---
*Completion: Mark this lesson done and continue*
