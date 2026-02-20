# SKILLS_MAP
> Lightweight routing index. Read this to select skills and workflows.
> Load individual skill.md files only when actually invoking a skill.

---

## Workflow Router

Pick the workflow first. It handles skill sequencing and skip logic.

| Task Type | Workflow |
|---|---|
| New component, page, redesign, mockup implementation | `workflow-frontend-design` |
| CSS fix, spacing, copy edit, minor UI tweak | `workflow-frontend-maintenance` |
| New feature, API, backend logic | `workflow-engineering` (mode: feature) |
| Bug fix, regression | `workflow-engineering` (mode: bugfix) |
| Urgent production fix | `workflow-engineering` (mode: hotfix) |
| Research, investigate, learn about a topic | `workflow-research` |
| Social post, newsletter, blog, platform content | `workflow-content` |

---

## Skills Index

### Frontend
| skill | use when | skip when |
|---|---|---|
| `workflow-frontend-design` | new UI, redesign, mockup | maintenance-only change |
| `workflow-frontend-maintenance` | minor fix, copy edit | new component or redesign |
| `frontend-design` | any visual output needed | pure backend/logic |
| `visual-compare` | mockup/reference image provided | no reference image |
| `react-best-practices` | React or Next.js project | other frameworks |
| `playwright-browser` | browser automation or UI test needed | no URL to test |
| `ui-review` | parallel review of full page/component | minor tweak |
| `stop-slop` | user-facing copy present | pure code, no text |
| `discover-standards` | before generating any code | never skip |

### Engineering
| skill | use when | skip when |
|---|---|---|
| `workflow-engineering` | any code task | frontend-only visual change |
| `craft` | complex task, ambiguous scope | loc_delta ≤ 25, clear spec |
| `spec` | delegating to async agent (Codex/Gemini) | executing directly right now |
| `tdd` | any logic change | config/copy-only fix |
| `debugging` | unknown root cause | cause is already known |
| `slop-scan` | post-feature quality check | hotfix, loc_delta ≤ 50 |
| `slop-fix` | after slop-scan found issues | no slop-scan run first |
| `overseer` | before merge/commit | never skip on features |
| `git-save` | changes ready to commit | tests failing, WIP |
| `todo-new` | multi-step task with 3+ phases | single-step or hotfix |
| `loop` | autonomous iteration until done | interactive task |
| `plan-execute` | Opus plans + Gemini executes (cost savings) | simple task |
| `worktree-manager` | parallel feature development | single branch is fine |

### Research & Knowledge
| skill | use when | skip when |
|---|---|---|
| `workflow-research` | any research task | simple factual question |
| `recall` | ALWAYS before researching | never skip |
| `super-search` | need fresh external info (Perplexity + Grok X + YT) | memory hit < 7 days (AI/tech), < 30 days (patterns) |
| `deep-research` | single-source comprehensive dive | broad topic scan |
| `research-swarm` | multiple topics simultaneously | single topic |
| `learn` | process URL/PDF into knowledge | already processed |
| `memory-system` | save/read facts, events, learnings | never skip saving |
| `knowledge-management` | connect notes, find patterns | single quick fact |
| `capture` | inbox item with PARA categorization | already categorized |

### Content
| skill | use when | skip when |
|---|---|---|
| `workflow-content` | any public-facing content | internal docs |
| `content-creation` | transform knowledge into platform content | pure code output |
| `stop-slop` | ANY public content | pure code, internal notes |
| `prompt-engineering` | reviewing or improving a prompt | prompt is already tested |

### Multi-AI Routing
| skill | use when | skip when |
|---|---|---|
| `route` | unsure which model to use | task is clearly Claude's strength |
| `ai-collab` | want multi-AI perspectives | single clear answer needed |
| `parallel-verification` | high-stakes decision, multiple hypotheses | simple lookup |
| `pv-mesh` | max confidence, multi-AI verification | standard tasks |
| `plan-execute` | complex multi-step, cost matters | simple or interactive |
| `squad` | true multi-agent with worktrees | single-agent is enough |

### Media Generation
| skill | use when |
|---|---|
| `image-gen` | generate image via ComfyUI |
| `face-gen` | face-consistent images (IP-Adapter) |
| `nano-banana` | Gemini Pro image with reference |
| `video-gen` | image-to-video via Wan 2.2 |
| `music-gen` | music via ACE-Step 1.5 |
| `tts-gen` | speech audio via Qwen3-TTS |
| `zimage-lora` | train custom image LoRA |

### Project & System
| skill | use when |
|---|---|
| `autonomous-dev` | deploy scanner-executor on a project |
| `evaluator` | run golden task evaluations |
| `pattern-detector` | find automation opportunities in logs |
| `kpi` | track agentic coding metrics |
| `planning` | weekly review, project status session |
| `morning-orchestrator` | start-of-day context prep |
| `project-setup` | initialize Claude Code in a new project |
| `meta-skill` | create a new skill from a pattern |
| `skill-builder` | build skill from user request |
| `frontier-scan` | scan AI agent landscape |
| `agentic-course` | interactive learning mode |

---

## Global Skip Rules

| Condition | Skip These |
|---|---|
| `loc_delta <= 10`, single file | overseer, slop-scan, craft |
| `loc_delta <= 25`, no logic change | craft, tdd, slop-scan |
| No user-facing copy in output | stop-slop |
| No mockup/reference image | visual-compare |
| Framework ≠ React/Next | react-best-practices |
| Memory hit found AND age < recency threshold | super-search |
| Hotfix mode | craft, spec, todo-new, slop-scan |
| Single-step task | todo-new, loop |
| Task executing directly (not delegating) | spec |
