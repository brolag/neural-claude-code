---
name: init
description: "Scan project and generate a customized CLAUDE.md. Detects stack, test commands, and conventions. Use when onboarding to a new project or user says 'init', 'setup claude', 'generate CLAUDE.md'."
argument-hint: "[project path]"
allowed-tools: Read, Write, Glob, Grep, Bash(ls *), Bash(git log *)
---

# /init — Generate Project CLAUDE.md

Scan the current project and generate a CLAUDE.md tailored to its stack and conventions.

## Steps

### 1. Detect Stack
Check for these files (in order):
- `package.json` → Node.js (check for next, react, vue, angular, etc.)
- `pyproject.toml` or `requirements.txt` → Python
- `go.mod` → Go
- `Cargo.toml` → Rust
- `Gemfile` → Ruby
- `pom.xml` or `build.gradle` → Java/Kotlin
- `Package.swift` → Swift

Read the detected config file to identify:
- Language and framework
- Test command (from scripts or conventions)
- Lint command
- Build command

### 2. Map Key Directories
Run `ls` at project root. Identify:
- Source code directory (src/, app/, lib/, etc.)
- Test directory (test/, tests/, __tests__/, spec/)
- Config files (tsconfig, eslint, prettier, etc.)
- API routes or endpoints

### 3. Check Existing Conventions
- `git log --oneline -10` — commit message style
- Check for existing CLAUDE.md, .cursorrules, .github/copilot-instructions.md
- Check for existing .editorconfig, prettier, eslint configs

### 4. Generate CLAUDE.md
Read the template from the neural-claude-code install directory.
Replace placeholders:
- `{{PROJECT_NAME}}` — from package.json name or directory name
- `{{STACK_DESCRIPTION}}` — detected stack summary
- `{{LANGUAGE}}` — primary language
- `{{TEST_COMMAND}}` — detected test command or "npm test"
- `{{LINT_COMMAND}}` — detected lint command or "npm run lint"
- `{{DIRECTORY_MAP}}` — key directories found

Write to `CLAUDE.md` in project root.

### 5. Report
```
Generated CLAUDE.md for [project name]
  Stack: [detected stack]
  Tests: [test command]
  Lint: [lint command]

Review CLAUDE.md and adjust as needed.
```

## Notes
- If CLAUDE.md already exists, ask before overwriting
- If stack can't be detected, generate a minimal template and ask user to fill in
- Never add secrets, API keys, or personal data to CLAUDE.md
