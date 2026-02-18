---
description: Git Save - Professional commits with Conventional Commits v1.0.0
allowed-tools: Bash
---

# Git Save - Conventional Commits with Emoji

Create professional git commits following Conventional Commits v1.0.0 specification with emoji enhancements and intelligent change analysis.

# COMMIT DETAILS:
$ARGUMENTS

## Process

1. **Analyze Git Status**
   - Run `git status` to check for uncommitted changes
   - If no changes, display message and exit gracefully
   - Stage all changes with `git add .`
   - Analyze staged changes with `git diff --cached`

2. **Intelligent Type Detection**
   Analyze git diff patterns to suggest commit type:
   - New files in src/ → suggest `feat`
   - Modified files with "fix", "bug", "issue" → suggest `fix`
   - Documentation files only (.md, .txt) → suggest `docs`
   - Package.json, build configs → suggest `build`
   - Test files (.test., .spec.) → suggest `test`
   - CI/CD files (.github/, .gitlab-ci) → suggest `ci`
   - Formatting changes only → suggest `style`
   - Code restructuring → suggest `refactor`
   - Performance improvements → suggest `perf`
   - Other maintenance → suggest `chore`

3. **Display Commit Type Options**
   ```
   Available commit types:
   ✨ feat     - New feature (MINOR version bump)
   🐛 fix      - Bug fix (PATCH version bump)
   📝 docs     - Documentation changes
   🎨 style    - Code formatting/style changes
   ♻️  refactor - Code restructuring
   ⚡ perf     - Performance improvements
   ✅ test     - Adding or updating tests
   🔧 build    - Build system/dependency changes
   🚀 ci       - CI/CD configuration changes
   🧹 chore    - Maintenance tasks
   ⏪ revert   - Revert previous commits
   ```

4. **Interactive Commit Creation**
   - Show detected files and suggested commit type with explanation
   - Prompt for commit type (with intelligent default)
   - Ask for optional scope (e.g., api, auth, ui, parser)
   - Request description following specification:
     * Use imperative mood ("add" not "added")
     * Don't capitalize first letter
     * No period at end
     * Keep under 50 characters
   - Check for breaking changes (show MAJOR version impact warning)
   - Optional: multi-line body for additional context
   - Optional: footers (Refs: #123, Closes: #456)

5. **Message Validation**
   - Verify format matches Conventional Commits specification
   - Check description length and format rules
   - Validate scope format (noun in parentheses)
   - Ensure proper breaking change notation

6. **Format Complete Message**
   ```
   <emoji> <type>(<scope>): <description>
   
   <body>
   
   <footers>
   ```

7. **Review and Execute**
   - Display complete formatted commit message
   - Show SemVer impact (PATCH/MINOR/MAJOR)
   - Confirm before executing commit
   - Execute `git commit` with constructed message
   - Display commit hash and success confirmation

## Conventional Commits Format

**Basic Structure:**
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Required Types:**
- `fix:` - Patches a bug (PATCH in SemVer)
- `feat:` - Introduces new feature (MINOR in SemVer)

**Additional Types:**
- `build:` - Build system or external dependencies
- `chore:` - Other changes that don't modify src or test files
- `ci:` - CI configuration files and scripts
- `docs:` - Documentation only changes
- `style:` - Code formatting, white-space, etc.
- `refactor:` - Code change that neither fixes bug nor adds feature
- `perf:` - Performance improvements
- `test:` - Adding or correcting tests
- `revert:` - Reverts a previous commit

**Breaking Changes:**
- Add `!` after type/scope: `feat!: breaking change`
- Or add `BREAKING CHANGE:` footer (MAJOR in SemVer)

## Example Messages

```
✨ feat(auth): add OAuth2 integration

🐛 fix(parser): correct array parsing for nested objects

📝 docs: update API documentation for v2.0

♻️ refactor(core): simplify event handling logic

🐛 fix(api)!: change user endpoint response format

BREAKING CHANGE: user endpoint now returns nested user object
instead of flat structure. Update client code accordingly.

Refs: #123
Closes: #456
```

## Command Options Support

- `--no-verify` - Skip pre-commit hooks
- `--amend` - Amend previous commit
- `--scope <scope>` - Pre-specify commit scope
- `--breaking` - Mark as breaking change
- `--type <type>` - Pre-specify commit type
- `--message <msg>` - Pre-specify description

## SemVer Impact Display

- `fix:` → PATCH release (0.0.X)
- `feat:` → MINOR release (0.X.0)
- `BREAKING CHANGE` → MAJOR release (X.0.0)

## Validation Rules

- Type MUST be one of the specified types
- Scope MUST be noun in parentheses (optional)
- Description MUST use imperative mood
- Description MUST NOT be capitalized
- Description MUST NOT end with period
- Breaking changes MUST use ! or BREAKING CHANGE footer
- Footers MUST follow git trailer format

## Usage

```bash
# Basic commit with interactive prompts
/git-save

# Commit with pre-specified message
/git-save --message "add user authentication"

# Commit with type and scope
/git-save --type feat --scope auth

# Commit with breaking change flag
/git-save --breaking --message "change API response format"

# Skip pre-commit hooks
/git-save --no-verify

# Amend the previous commit
/git-save --amend

# Full example with all options
/git-save --type fix --scope api --message "correct pagination logic" --no-verify
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No changes to commit | Working directory is clean | Make changes before running git-save |
| Invalid commit type | Type not in allowed list | Use one of: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert |
| Description too long | Message exceeds 50 characters | Shorten the commit description |
| Pre-commit hook failed | Linting or tests failed | Fix issues or use `--no-verify` to skip hooks |
| Not a git repository | No .git directory found | Initialize git with `git init` first |
| Merge conflict detected | Unresolved conflicts exist | Resolve conflicts before committing |

**Fallback**: If git-save fails, you can manually create commits using standard git commands: `git add .` followed by `git commit -m "type(scope): description"`.