---
name: youtube-learner
description: Extract transcripts from YouTube videos and transform them into actionable knowledge. Use when user wants to learn from a video, extract insights, or add video content to their knowledge base.
trigger: /yt-learn
---

# YouTube Learner Skill

Transform YouTube videos into structured knowledge by extracting transcripts and generating insights.

## When to Use

- "Learn from this video: [URL]"
- "Extract insights from YouTube video"
- "Summarize this video"
- "Add this video to my knowledge base"
- Any YouTube URL shared for learning purposes

## Process

### Phase 1: Extract Transcript

Use the Python script for reliable extraction:

```bash
# Primary method: Use transcript extraction script
python3 .claude/scripts/youtube-transcript.py "<youtube-url>"
```

Returns JSON with:
- `success`: boolean
- `video_id`: extracted ID
- `transcript`: full text
- `segments`: array with timestamps

Extract VIDEO_ID from URL formats:
- `youtube.com/watch?v=VIDEO_ID`
- `youtu.be/VIDEO_ID`
- `youtube.com/embed/VIDEO_ID`

### Phase 2: Get Metadata

Use noembed for video metadata:
```
WebFetch: https://noembed.com/embed?url=<youtube-url>
```

Returns:
- Video title
- Channel/author name
- Thumbnail URL

### Phase 3: Process Content

1. **Clean transcript** - Remove timestamps, fix formatting
2. **Identify structure** - Main topics, sections, key points
3. **Extract insights** - Core ideas, actionable takeaways

### Phase 4: Generate Learning Output

Structure as:

```markdown
# Video Learning: [Title]

**Source**: [YouTube URL]
**Channel**: [Channel Name]
**Date Processed**: [Today's Date]

## Key Insights
1. [Insight 1]
2. [Insight 2]
3. [Insight 3]

## Main Concepts

### [Concept 1]
[Explanation]

### [Concept 2]
[Explanation]

## Actionable Takeaways
- [ ] [Action 1]
- [ ] [Action 2]

## Notable Quotes
> "[Quote 1]"
> "[Quote 2]"

## Connections
- Related to: [[existing note 1]]
- See also: [[existing note 2]]

---
Tags: #youtube #learning #[topic-tags]
```

### Phase 5: Knowledge Integration

1. Save to appropriate location:
   - Quick learning: `inbox/`
   - Topic-specific: Relevant project folder

2. Create connections to existing knowledge

3. Add to review queue if desired

## Output Locations

| Type | Location |
|------|----------|
| Quick capture | `inbox/[date]-[title].md` |
| Project-related | `projects/[project]/resources/` |
| Reference | `resources/videos/` |

## Examples

```bash
# Learn from a video
/yt-learn https://youtube.com/watch?v=abc123

# Learn with specific focus
/yt-learn https://youtu.be/xyz789 --focus "marketing strategies"

# Quick summary only
/yt-learn https://youtube.com/watch?v=def456 --summary
```

## Fallback Methods

If Python script fails:

### Web Services (may have limitations)
```
WebFetch: https://youtubetranscript.com/?v=[VIDEO_ID]
```

### Manual Transcript
User can:
1. Open video on YouTube
2. Click "..." > "Show transcript"
3. Copy/paste transcript text

## Dependencies

- Python 3
- `youtube-transcript-api` package (auto-installed on first run)

## Usage

```bash
# Learn from a video
/yt-learn https://youtube.com/watch?v=abc123

# Learn with specific focus
/yt-learn https://youtu.be/xyz789 --focus "marketing strategies"

# Quick summary only
/yt-learn https://youtube.com/watch?v=def456 --summary
```

## Output Format

```markdown
## Video Learning Complete

**Video**: [Title]
**Channel**: [Name]
**Duration**: [length]
**Saved to**: inbox/[date]-[title].md

### Key Insights
1. [Insight 1]
2. [Insight 2]
3. [Insight 3]

### Action Items
- [ ] [Action 1]
- [ ] [Action 2]

### Connections
- Related to: [[existing note]]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Invalid URL | Not a YouTube URL | Provide valid youtube.com or youtu.be URL |
| No transcript | Video has no captions | Try WebFetch fallback or manual transcript |
| API rate limit | Too many requests | Wait and retry |
| Package missing | youtube-transcript-api not installed | Auto-installs on first use |
| Private video | Video not accessible | Request public video or manual transcript |

**Fallback**: If transcript API fails, try WebFetch on youtubetranscript.com.

## Quality Criteria

- Clear identification of main topics
- Actionable insights (not just summary)
- Connections to existing knowledge
- Proper attribution and source link
- Tags for future retrieval
