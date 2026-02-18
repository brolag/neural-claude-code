---
description: GitHub Repository Learning - Analyze repos and extract patterns
allowed-tools: Bash, WebFetch, Read, Write
---

# /gh-learn - GitHub Repository Learning

Learn from GitHub repositories by analyzing their architecture, extracting patterns, and adopting capabilities.

## Usage

```
/gh-learn <repo-url-or-owner/repo> [--focus "<area>"] [--adopt-patterns] [--deep]
```

## Arguments

- `repo`: GitHub URL or `owner/repo` format (required)
- `--focus "<area>"`: Focus analysis on specific aspects (e.g., "agent architecture", "testing patterns")
- `--adopt-patterns`: Automatically create notes for patterns worth adopting
- `--deep`: Perform deeper analysis including recent commits and issues

## Prompt

You are a GitHub Repository Learning Agent. Your task is to analyze a GitHub repository and extract valuable learnings.

### Input
Repository: $ARGUMENTS

### Analysis Steps

1. **Parse Input**
   - Extract owner/repo from URL or direct format
   - Parse any flags (--focus, --adopt-patterns, --deep)

2. **Fetch Repository Info**
   Use `gh` CLI to gather information:
   ```bash
   # Get repo metadata
   gh repo view owner/repo --json name,description,languages,defaultBranch

   # Get directory structure
   gh api repos/owner/repo/git/trees/main?recursive=1 --jq '.tree[] | select(.type=="blob") | .path' | head -100

   # Check for Claude Code setup
   gh api repos/owner/repo/contents/.claude --jq '.[].name' 2>/dev/null || echo "No .claude directory"

   # Get README
   gh api repos/owner/repo/readme --jq '.content' | base64 -d 2>/dev/null || echo "No README"
   ```

3. **Analyze Structure**
   Look for:
   - Project organization patterns
   - Naming conventions
   - Configuration approaches
   - Testing strategies
   - Documentation patterns

4. **Extract Patterns**
   Identify:
   - Design patterns used
   - Architecture decisions
   - Interesting implementations
   - Reusable components
   - Best practices demonstrated

5. **Check Claude Code Setup** (if exists)
   - Read CLAUDE.md for instructions
   - Check for skills/agents/commands
   - Note any interesting configurations

6. **Focus Area** (if --focus provided)
   Deep dive into the specified area:
   - Find relevant files
   - Extract specific patterns
   - Note implementation details

7. **Generate Learnings Report**
   Create a structured report with:
   - Repository overview
   - Key architectural patterns
   - Notable implementations
   - Lessons learned
   - Patterns worth adopting

8. **Save to Knowledge Base** (if --adopt-patterns)
   Create a note in `inbox/` with:
   - Filename: `github-{date}-{repo-name}.md`
   - Tag: `#source/github`
   - Include actionable takeaways

### Output Format

```markdown
## Repository Analysis: {owner}/{repo}

### Overview
- **Description**: {description}
- **Languages**: {languages}
- **Stars**: {stars}

### Architecture Patterns
{List key architectural decisions and patterns}

### Notable Implementations
{Highlight interesting code patterns or solutions}

### Claude Code Setup
{If present, describe their Claude Code configuration}

### Lessons Learned
{Key takeaways from analyzing this repo}

### Patterns to Adopt
{Specific patterns worth incorporating into our workflow}

### Files of Interest
{List key files worth reading in detail}
```

### Example

```
/gh-learn anthropics/claude-code --focus "skills system" --adopt-patterns
```

Would analyze the Claude Code repository, focus on how skills work, and save learnings automatically.

## Tools Required

- `gh` CLI (GitHub CLI)
- WebFetch for README if gh fails
- Read/Write for saving learnings

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| gh CLI not authenticated | GitHub CLI not logged in | Run `gh auth login` to authenticate |
| Repository not found | Invalid owner/repo or private repo | Verify the repository exists and is public |
| API rate limit exceeded | Too many GitHub API requests | Wait an hour or authenticate with `gh auth login` for higher limits |
| No README found | Repository has no README file | Analysis will continue but overview will be limited |
| Invalid repo format | URL or owner/repo format incorrect | Use `owner/repo` format or full GitHub URL |

**Fallback**: If `gh` CLI fails, use WebFetch to read the repository's main page at `https://github.com/owner/repo` and manually extract patterns from the displayed structure.

## Notes

- Respects GitHub API rate limits
- Does not clone repositories (uses API only)
- Focuses on public information
