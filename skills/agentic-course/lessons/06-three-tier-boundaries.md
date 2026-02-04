# Lesson 6: 3-Tier Boundaries

## Objective

Set up the safety guardrails that let you trust autonomous agents.

## The 3 Tiers

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  ✅ ALWAYS DO     Safe actions, no approval needed             │
│                                                                 │
│  ⚠️ ASK FIRST     High-impact, needs human review              │
│                                                                 │
│  🚫 NEVER DO      Hard stops, forbidden actions                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Tier 1: Always Do (Green Light)

Actions the AI can take freely:

```yaml
always_do:
  - Run tests before commits
  - Run linter before commits
  - Follow existing code patterns
  - Add comments for complex logic
  - Update related tests when changing code
  - Create feature branches for new work
  - Write descriptive commit messages
```

These are SAFE. No need to ask.

## Tier 2: Ask First (Yellow Light)

Actions that need human approval:

```yaml
ask_first:
  - Adding new dependencies
  - Changing database schema
  - Modifying public API contracts
  - Updating authentication logic
  - Changes to CI/CD pipeline
  - Deleting files (even if unused)
  - Major refactors
  - Changes to config files
```

AI should STOP and ask before these.

## Tier 3: Never Do (Red Light)

Hard stops, even if asked:

```yaml
never_do:
  - Commit API keys, passwords, or secrets
  - Push directly to main/master branch
  - Delete or modify production data
  - Disable security checks or linting
  - Remove tests without replacement
  - Bypass code review process
  - Force push
  - Run destructive commands (rm -rf, DROP TABLE)
```

Even if you say "do it anyway", the AI should refuse.

## Visual Decision Tree

```
                    ┌─────────────┐
                    │   Action    │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
         ✅ SAFE      ⚠️ RISKY     🚫 DANGER
              │            │            │
              ▼            ▼            ▼
           Execute      Ask User     REFUSE
                           │
                    ┌──────┴──────┐
                    │             │
                 Approved      Denied
                    │             │
                    ▼             ▼
                 Execute       Stop
```

## Setting Up Your Boundaries

Add to your CLAUDE.md or create `.claude/rules/boundaries.md`:

```markdown
## Project Boundaries

### ✅ Always Do
- Run `npm test` before committing
- Use TypeScript strict mode
- Follow ESLint configuration

### ⚠️ Ask First
- Adding packages to package.json
- Modifying prisma/schema.prisma
- Changing auth/ directory files

### 🚫 Never Do
- Commit .env files
- Push to main directly
- Modify production configs
```

## Try It

Create a boundaries file for your project:

```bash
# Create the rules directory if needed
mkdir -p .claude/rules

# Write your boundaries
cat > .claude/rules/boundaries.md << 'EOF'
## Project Boundaries

### ✅ Always Do
- Run tests before commits
- Use existing patterns
- Document complex code

### ⚠️ Ask First
- New dependencies
- Database changes
- Config modifications

### 🚫 Never Do
- Commit secrets
- Push to main
- Delete without backup
EOF
```

Now the AI knows your safety expectations.

## Check

Confirm you understand:

1. Green = autonomous, Yellow = pause and ask, Red = never
2. Boundaries go in CLAUDE.md or dedicated rules file
3. AI should refuse Red actions even if told to proceed
4. This is what makes "go work for hours" safe

## Next

**Lesson 7: Loop Fundamentals** - Deep dive into autonomous iteration.

```bash
/course lesson 7
```

---
*Completion: Mark this lesson done and continue*
