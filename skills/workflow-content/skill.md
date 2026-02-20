---
name: workflow-content
description: Content creation workflow for social media posts, newsletters, blog posts, and platform content. Use when: creating public-facing content, transforming knowledge into posts, writing for an audience. Don't use when: internal docs, code comments, technical specs, or private notes.
trigger: write a post, create content, LinkedIn, tweet, newsletter, blog post, content for
---

# Workflow: Content

Structure → Create → Clean. No AI slop in public content.

## Chain

```
1. craft?                    → SKIP if: format + platform + audience already specified by user
2. content-creation          → ALWAYS — transform knowledge into platform-optimized content
3. stop-slop                 → ALWAYS — no AI writing patterns in anything public
```

## Skip Gates

| Step | Skip When |
|---|---|
| `craft` | User already specified: platform + format + target audience + key message |
| `content-creation` | Never skip |
| `stop-slop` | Never skip — always clean public content |

## Platform Routing (inside content-creation)

| Platform | Format | Tone |
|---|---|---|
| LinkedIn | Long-form, structured | Professional, insight-driven |
| X/Twitter | Short, punchy | Opinionated, conversational |
| Instagram | Visual-first, caption | Lifestyle, aspirational |
| Newsletter | Multi-section | Curated, editorial |
| Blog | Long-form, SEO | Educational, authoritative |

## Done When

- [ ] Content formatted for target platform
- [ ] No AI writing patterns (stop-slop passed)
- [ ] Hooks are strong — first line earns the read
- [ ] Ready to publish or schedule

## Entry Signals

"write a post about...", "LinkedIn post for...", "tweet about...", "newsletter on...", "content for [platform]", "turn this into content"
