---
description: Universal Learning - Auto-detects source type (YouTube, GitHub, X, PDF, web) and extracts knowledge
allowed-tools: Bash, WebFetch, Read, Write
---

# /learn - Universal Learning Command

Smart learning command that auto-detects the source type and routes to the appropriate extraction process.

## Usage

```
/learn <url-or-path> [--verbose] [--focus "<topic>"] [--summary] [--deep]
```

## Arguments

- `url-or-path`: URL or file path to learn from (required)
- `--verbose`: Show what the bot is doing at each step
- `--focus "<topic>"`: Focus extraction on a specific topic
- `--summary`: Quick summary only (skip full analysis)
- `--deep`: Extract more detail, including code examples and technical specifics

## Source Auto-Detection

**IMPORTANT**: Before processing, detect the source type and route accordingly:

| URL Pattern | Source Type | Process |
|-------------|-------------|---------|
| `youtube.com/*`, `youtu.be/*` | YouTube | Extract transcript via Python script, then analyze |
| `github.com/*` | GitHub | Use `gh` CLI to analyze repo structure, then extract patterns |
| `x.com/*`, `twitter.com/*` | X/Twitter | Use browser automation to extract post/thread |
| `*.pdf` (local path) | PDF | Use PyMuPDF to extract text, then analyze |
| Any other URL | Web Article | Use WebFetch to extract content |

## Verbose Mode (--verbose)

When `--verbose` is provided, output each step:

```
🔍 Analyzing input: <url>
→ Source type: YouTube video
→ Process: Extracting transcript first...

📥 Step 1: Getting transcript
→ Running: python3 .claude/scripts/youtube-transcript.py "<url>"
→ Transcript length: 4,532 words

📊 Step 2: Analyzing content
→ Identifying key insights...
→ Extracting main concepts...

💾 Step 3: Saving to knowledge base
→ File: inbox/youtube-2026-01-12-video-title.md

✅ Learning complete!
```

## Routing Logic

```
IF url contains "youtube.com" OR "youtu.be":
    → Use YouTube learning process (transcript extraction first)

ELSE IF url contains "github.com":
    → Use GitHub learning process (gh CLI analysis)

ELSE IF url contains "x.com" OR "twitter.com":
    → Use X learning process (browser automation required)

ELSE IF path ends with ".pdf":
    → Use PDF learning process (PyMuPDF extraction)

ELSE:
    → Use Web learning process (WebFetch)
```

## Process by Source Type

### YouTube Videos
1. Extract transcript using: `python3 .claude/scripts/youtube-transcript.py "<url>"`
2. Parse JSON response for transcript text
3. Analyze transcript for insights
4. Save to `inbox/youtube-YYYY-MM-DD-{title}.md`

### GitHub Repositories
1. Parse owner/repo from URL
2. Run `gh repo view` and `gh api` commands
3. Analyze structure, README, and patterns
4. Save to `inbox/github-YYYY-MM-DD-{repo}.md`

### X/Twitter Posts
1. Use browser automation (claude-in-chrome MCP)
2. Extract post content, author, engagement
3. Analyze for insights
4. Save to `inbox/x-YYYY-MM-DD-{author}-{topic}.md`

### PDF Documents
1. Validate file exists
2. Extract with PyMuPDF
3. Analyze content by sections
4. Save to `inbox/book-YYYY-MM-DD-{title}.md`

### Web Articles (default)
1. Fetch with WebFetch
2. Extract main content
3. Analyze for insights
4. Save to `inbox/web-YYYY-MM-DD-{title}.md`

## Prompt

You are a Universal Learning Agent. Your task is to detect the source type and transform content into structured, actionable knowledge.

### Input
$ARGUMENTS

### Process

1. **Parse Arguments**
   - Extract the URL or file path
   - Parse flags: --verbose, --focus, --summary, --deep
   - Check for --verbose flag first

2. **Detect Source Type** (CRITICAL STEP)
   Analyze the input to determine the source:

   ```
   IF --verbose: output "🔍 Analyzing input: <url>"

   IF input contains "youtube.com" OR "youtu.be":
       source_type = "youtube"
       IF --verbose: output "→ Source type: YouTube video"

   ELSE IF input contains "github.com":
       source_type = "github"
       IF --verbose: output "→ Source type: GitHub repository"

   ELSE IF input contains "x.com" OR "twitter.com":
       source_type = "x"
       IF --verbose: output "→ Source type: X/Twitter post"

   ELSE IF input ends with ".pdf":
       source_type = "pdf"
       IF --verbose: output "→ Source type: PDF document"

   ELSE:
       source_type = "web"
       IF --verbose: output "→ Source type: Web article"
   ```

3. **Route to Appropriate Process**

   **For YouTube (`source_type = "youtube"`):**
   ```
   IF --verbose: output "📥 Step 1: Getting transcript..."
   Run: python3 .claude/scripts/youtube-transcript.py "<url>"
   Parse JSON response
   IF --verbose: output "→ Transcript extracted: X words"
   Continue with analysis...
   Save to: inbox/youtube-YYYY-MM-DD-{title}.md
   ```

   **For GitHub (`source_type = "github"`):**
   ```
   IF --verbose: output "📥 Step 1: Analyzing repository..."
   Run: gh repo view owner/repo --json name,description,languages
   Run: gh api repos/owner/repo/git/trees/main?recursive=1
   IF --verbose: output "→ Found X files, analyzing structure..."
   Continue with pattern extraction...
   Save to: inbox/github-YYYY-MM-DD-{repo}.md
   ```

   **For X/Twitter (`source_type = "x"`):**
   ```
   IF --verbose: output "📥 Step 1: Loading post via browser..."
   Use browser automation (claude-in-chrome MCP required)
   IF --verbose: output "→ Post extracted from @username"
   Continue with analysis...
   Save to: inbox/x-YYYY-MM-DD-{author}-{topic}.md
   ```

   **For PDF (`source_type = "pdf"`):**
   ```
   IF --verbose: output "📥 Step 1: Extracting PDF content..."
   Run PyMuPDF extraction
   IF --verbose: output "→ Extracted X pages"
   Continue with analysis...
   Save to: inbox/book-YYYY-MM-DD-{title}.md
   ```

   **For Web (default):**
   ```
   IF --verbose: output "📥 Step 1: Fetching web content..."
   Use WebFetch to retrieve content
   IF --verbose: output "→ Content fetched: X words"
   Continue with analysis...
   Save to: inbox/web-YYYY-MM-DD-{title}.md
   ```

4. **Fetch Content** (for web sources)
   Use WebFetch to retrieve and analyze the content:
   ```
   WebFetch(url, "Extract the main content: title, author, publication date, and full article text. Ignore navigation, ads, and sidebars.")
   ```

3. **Identify Content Type**
   Determine what kind of content this is:
   - Technical article/tutorial
   - Blog post/opinion piece
   - Documentation
   - News article
   - Research paper
   - How-to guide
   - Case study

4. **Extract Core Information**
   - **Title**: Main headline
   - **Author**: Writer/creator (if available)
   - **Source**: Publication/site name
   - **Date**: Publication date (if available)
   - **Reading time**: Estimated length

5. **Analyze Content**
   Transform into structured knowledge:

   **Key Insights** (3-5 main takeaways)
   - What are the most important points?
   - What's new or surprising?

   **Main Concepts** (organized by topic)
   - Core ideas explained
   - Technical details (if --deep)
   - Code examples (if --deep and present)

   **Actionable Items**
   - What can be applied immediately?
   - What requires more exploration?

   **Notable Quotes** (if present)
   - Memorable statements
   - Key definitions

6. **Focus Area** (if --focus provided)
   Deep dive into the specified topic:
   - Extract all mentions of the focus topic
   - Summarize relevant sections
   - Note specific techniques or approaches

7. **Generate Connections**
   Suggest links to:
   - Related topics in the knowledge base
   - Follow-up learning resources
   - Potential projects or experiments

8. **Save to Knowledge Base**
   Create note in `inbox/` with format:
   ```
   web-YYYY-MM-DD-{slugified-title}.md
   ```

### Output Format

```markdown
# Learning: [Title]

**Source**: [URL]
**Author**: [Name] (if available)
**Type**: [Article/Tutorial/Docs/etc.]
**Processed**: [Date]

## TL;DR
[1-2 sentence summary]

## Key Insights
1. [Most important takeaway]
2. [Second key point]
3. [Third key point]

## Main Concepts

### [Concept 1]
[Explanation]

### [Concept 2]
[Explanation]

## Action Items
- [ ] [First actionable task]
- [ ] [Second actionable task]

## Notable Quotes
> "[Memorable quote]"

## Code Examples (if applicable)
```[language]
[code snippet]
```

## Related Topics
- [[Topic 1]]
- [[Topic 2]]

## Follow-up
- [Resource to explore]
- [Question to research]

---
Tags: #learning #web #[content-type]
```

### Summary Mode (--summary)

If --summary is provided, output only:

```markdown
# Quick Learn: [Title]

**Source**: [URL]
**Type**: [Content type]

## Summary
[2-3 paragraph summary]

## Key Takeaways
1. [Point 1]
2. [Point 2]
3. [Point 3]

---
Tags: #learning #quick
```

## Examples

```bash
# YouTube video (auto-detected, extracts transcript first)
/learn https://youtube.com/watch?v=dQw4w9WgXcQ
/learn https://youtu.be/abc123 --verbose

# GitHub repository (auto-detected, uses gh CLI)
/learn https://github.com/anthropics/claude-code
/learn https://github.com/vercel/ai --focus "agent patterns" --verbose

# X/Twitter post (auto-detected, uses browser automation)
/learn https://x.com/karpathy/status/1234567890
/learn https://x.com/swyx/status/9876543210 --verbose

# PDF document (auto-detected by .pdf extension)
/learn resources/books/my-book.pdf
/learn ~/Downloads/whitepaper.pdf --focus "architecture" --verbose

# Web article (default for other URLs)
/learn https://example.com/blog/interesting-article
/learn https://martinfowler.com/articles/patterns-of-distributed-systems/wal.html --focus "write-ahead logging"

# With verbose to see what's happening
/learn https://youtube.com/watch?v=xyz789 --verbose --summary
```

## Supported Content Types

| Type | Best For |
|------|----------|
| Blog posts | Personal insights, opinions |
| Technical articles | Deep technical content |
| Tutorials | Step-by-step learning |
| Documentation | Reference material |
| News articles | Current events, announcements |
| Research summaries | Academic insights |
| Case studies | Real-world examples |

## Tools Required

- WebFetch (primary content retrieval)
- Write (saving to inbox)
- Read (checking existing notes)

## Optional Dependencies

- **YouTube**: Requires `.claude/scripts/youtube-transcript.py` installed in the project. Without it, fall back to fetching the YouTube page via WebFetch and extracting available metadata. Source: any YouTube transcript API wrapper (e.g. `youtube-transcript-api` Python package).
- **X/Twitter**: Requires `claude-in-chrome` MCP extension active.
- **PDF**: Requires `PyMuPDF` (`pip install pymupdf`). Fallback: use `pdftotext` CLI.
- **GitHub**: Requires `gh` CLI authenticated (`gh auth login`).

## Notes

- **Auto-detects source type** - no need to remember different commands
- Respects copyright - extracts insights, not full text
- Works best with text-heavy content
- May struggle with heavily JS-rendered sites (except X which uses browser automation)
- YouTube requires transcript availability
- GitHub requires `gh` CLI to be authenticated
- X/Twitter requires claude-in-chrome MCP connection

## Workflow Integration

After running `/learn`:
1. Review the generated note in `inbox/`
2. Edit to add personal insights
3. Move to appropriate location in vault
4. Run `/capture` to create connections

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| WebFetch timeout | URL is slow or unresponsive | Retry or check internet connection |
| Content blocked/paywall | Site requires login or subscription | Use a different source or copy content manually |
| JavaScript-rendered content | Site relies heavily on JS | Use `--verbose` to see if browser automation is needed |
| Invalid URL format | Malformed or missing URL | Ensure URL starts with http:// or https:// |
| Empty content extracted | No readable text found | Use `--deep` flag or try a different page on the site |
| YouTube transcript unavailable | Video has no captions | Check if video has auto-captions enabled |
| GitHub API rate limit | Too many requests | Authenticate with `gh auth login` for higher limits |
| X/Twitter browser error | MCP not connected | Ensure claude-in-chrome extension is active |
| PDF extraction failed | Corrupted or encrypted PDF | Try opening in PDF viewer first |

**Fallback**: Use `--verbose` to see which step fails. For persistent issues:
- YouTube: Use web-based transcript services
- GitHub: Read README directly via WebFetch
- X: Copy-paste the post content manually
- PDF: Use `pdftotext` CLI tool
- Web: Copy content to a local file and process
