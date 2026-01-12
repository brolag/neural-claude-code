---
description: Transform vault knowledge into platform-optimized content for social media, articles, and presentations. Use when user wants to create content, write posts, generate threads, or produce educational material.
allowed-tools: Read, Write, Edit, Glob, Grep, WebSearch
---

# Content Creation Skill

Generate content from the second brain knowledge base for external sharing.

## When Claude Should Use This Skill

- User mentions "create content", "write a post", "make a thread"
- User wants to "share this knowledge", "teach this concept"
- User asks for "article", "presentation", "educational content"
- User mentions specific platforms: Twitter, LinkedIn, Blog, YouTube
- Working with knowledge that could be shared externally

## Capabilities

### Content Types

| Type | Platform | Format |
|------|----------|--------|
| Threads | Twitter/X | Multi-tweet educational content |
| Articles | Blog/Medium | Long-form deep dives |
| Posts | LinkedIn | Professional insights |
| Presentations | Slides | Structured talks |
| Scripts | YouTube | Video content |
| Case Studies | All | Project learnings |

### Process

1. **Identify Topic** - Extract from vault knowledge
2. **Gather Sources** - Collect related notes and research
3. **Analyze Audience** - Understand target platform
4. **Create Outline** - Structure the content
5. **Generate Draft** - Write platform-optimized content
6. **Add Examples** - Include references from experience
7. **Optimize** - Format for specific platform

## Source Locations

- Project learnings: `01_projects/`
- Knowledge base: `03_resources/`
- Personal insights: `05_daily/`
- Research: `03_resources/MOCs/`

## Platform Guidelines

### Twitter/X Threads
- Hook in first tweet
- One idea per tweet
- Use line breaks for readability
- End with CTA or summary

### LinkedIn Posts
- Professional tone
- Personal stories welcome
- Include actionable takeaways
- Ask engaging questions

### Blog Articles
- Clear structure with headers
- Include code examples if technical
- Add internal/external links
- Meta description for SEO

## Usage

```bash
# Create content from topic
/content "productivity tips" --platform twitter

# Generate thread from note
/content --from "inbox/learning-note.md" --type thread

# Create article draft
/content "second brain methodology" --platform blog
```

## Output

- Platform-optimized content
- Source citations from vault
- Suggested hashtags/tags
- Content calendar recommendations

## Output Format

```markdown
## Content Created

**Platform**: [Twitter/LinkedIn/Blog]
**Type**: [Thread/Post/Article]
**Source**: [vault notes used]

### Content
[The actual content]

### Hashtags
#tag1 #tag2 #tag3

### Publishing Notes
- Best time to post: [recommendation]
- Related content to schedule: [suggestions]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No source material | Topic not in vault | Research topic first or provide context |
| Platform not supported | Unknown platform | Use generic format |
| Content too long | Exceeds platform limits | Auto-split into series |

**Fallback**: If vault search fails, generate content from general knowledge with disclaimer.
