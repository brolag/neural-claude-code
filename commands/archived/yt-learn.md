---
description: YouTube Learning - Transform videos into actionable knowledge
allowed-tools: Bash, WebFetch, Read, Write
---

# YouTube Learning

Transform YouTube videos into actionable knowledge.

## Usage
```
/yt-learn <youtube-url> [--focus "topic"] [--summary]
```

## Arguments
- `youtube-url`: Full YouTube URL or video ID
- `--focus`: Optional focus area for extraction
- `--summary`: Quick summary only (no full analysis)

## Process

### Step 1: Extract Video Info
From the provided URL `$ARGUMENTS`, extract:
1. Video ID from URL
2. Fetch video metadata and transcript

### Step 2: Get Transcript
Primary method - use Python script:
```bash
python3 .claude/scripts/youtube-transcript.py "$ARGUMENTS"
```

Fallback - use WebFetch:
- `https://youtubetranscript.com/?v={VIDEO_ID}`
- YouTube page description and chapters

### Step 3: Get Metadata
Use noembed for video info:
```
WebFetch: https://noembed.com/embed?url=$ARGUMENTS
```

### Step 4: Process & Analyze
Transform raw transcript into:
1. **Key Insights** (3-5 main takeaways)
2. **Main Concepts** (organized by topic)
3. **Actionable Items** (what to do with this knowledge)
4. **Notable Quotes** (memorable statements)

### Step 5: Create Knowledge Note
Save structured output to `inbox/` with format:
```
YYYY-MM-DD-video-title.md
```

### Step 6: Suggest Connections
Identify related notes in the vault for linking.

## Output Format

```markdown
# Video Learning: [Title]

**Source**: [URL]
**Channel**: [Name]
**Processed**: [Date]

## Key Insights
1. ...

## Main Concepts
### [Topic]
...

## Action Items
- [ ] ...

## Quotes
> "..."

---
Tags: #learning #[topic]
```

## Examples

```bash
# Basic usage
/yt-learn https://youtube.com/watch?v=dQw4w9WgXcQ

# With focus
/yt-learn https://youtu.be/abc123 --focus "productivity tips"

# Quick summary
/yt-learn https://youtube.com/watch?v=xyz789 --summary
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Invalid URL | Not a YouTube URL | Provide valid youtube.com URL |
| No transcript | Video has no captions | Try different video |
| API rate limit | Too many requests | Wait and retry |
| Package missing | youtube-transcript-api not installed | Auto-installs on first use |

**Fallback**: If transcript API fails, try WebFetch on youtubetranscript.com.

## Dependencies

Requires `youtube-transcript-api` Python package (auto-installed on first use).
