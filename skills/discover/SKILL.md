---
name: discover
description: "Pre-implementation discovery gate: surface your unknown-unknowns BEFORE you plan. Run a blindspot pass over the real codebase, map the task across the four unknowns quadrants, interview you on the decisions that change the architecture, and pin references — then hand off to /spec. Use when you're entering unfamiliar code, an unfamiliar domain, or you can't yet articulate what 'good' looks like. Don't use when you already know exactly what you want (go straight to /spec) or for trivial changes."
trigger: /discover
argument-hint: "[task or problem] [--no-html]"
allowed-tools: Read, Glob, Grep, Bash(git *), Bash(rg *), Bash(fd *), Bash(gh *), WebSearch, WebFetch, AskUserQuestion, Write
---

# /discover — Finding Your Unknowns

The map is not the territory. Your prompts, skills, and context are the **map**; the codebase and its real constraints are the **territory**. The gap between them is **unknowns** — every place the agent has to guess what you meant. This skill closes that gap *before* it gets expensive to fix in implementation.

This is the gate that runs **before `/spec`**. `spec` already assumes you understand the change (its clarify step is "only if ambiguous, ≤3 Qs"). `discover` is for when you don't yet know what you don't know: new part of the codebase, unfamiliar domain, or a design you'll only recognize when you see it.

Adapted from Thariq's *A Field Guide to Fable: Finding Your Unknowns*. The four-quadrant model, blindspot pass, and interview-first discipline are the spine.

## When to use
- You're working in an **unfamiliar part of the codebase** or an **unfamiliar domain**.
- You have a lot of **unknown-unknowns**: you don't know what questions to ask, what "good" looks like, what history or potholes exist.
- You have **unknown-knowns**: criteria you only know when you see them (visual taste, "feel"), best surfaced now, not mid-build.
- You want a thought partner to define scope *before* committing to an approach.

## When NOT to use
- **You already know exactly what you want** → go straight to `/spec`, or implement directly if trivial.
- **You want the plan itself** (decompose, signatures, acceptance) → that's `/spec` (this skill routes you there).
- Trivial changes (<25 LOC), config-only edits.

## 0. Right-size (skip when the map already matches the territory)
Before anything, gauge unknown density. If the user can already state the change in one clear sentence and knows the codebase area, say so plainly and route: go straight to `/spec` (or implement, if trivial). Do not manufacture a discovery ceremony for a known task.

## 1. Capture the starting point (the single most important input)
Discovery is only as good as the context you give it. Before searching, establish — ask the user briefly if not already clear:
- **Their experience** with this problem and this codebase (expert / familiar / new).
- **What they already know** they want (the known-knowns).
- **Where they are** in their thinking (exploring / have a rough approach / stuck on one thing).
- **What "done" looks like**, if they can say.

Generic blindspot passes are noise. A pass grounded in "I know nothing about the auth modules here" is signal.

## 2. Blindspot pass (find the unknown-unknowns)
Search the **real codebase** (Glob/Grep/Read; git history via `git log`/`gh` when useful; WebSearch/WebFetch only for genuine domain gaps). Surface what the user doesn't know to ask:
- Prior/historical work in this area and why it was done that way.
- Potholes, foot-guns, and constraints hiding in the code.
- What "good" looks like here (existing patterns, conventions, quality bar).
- The questions an expert in this area would ask that the user hasn't.

Report findings grounded in concrete files (`path:line`), not generic best-practice bullets.

## 3. Map the four quadrants
Classify everything from the prompt + the blindspot pass into the model (see `references/unknowns-framework.md` for the full method):
- **Known knowns** — what the user has already told you they want.
- **Known unknowns** — what they know they haven't figured out.
- **Unknown knowns** — so obvious they'd never write it down, but would recognize on sight. Verbalize these *now*; finding them in implementation is expensive.
- **Unknown unknowns** — what the blindspot pass revealed.

## 4. Interview (convert unknowns → knowns)
Ask via **AskUserQuestion**, **prioritized by architectural impact** — questions whose answer changes the design come first. Roughly one focused batch (~4 questions) at a time; each answer promotes an unknown-known or known-unknown into a known-known. **Stop early** when no remaining question would move the architecture. Do not interrogate for completeness's sake.

## 5. References (the cheapest way to transfer intent)
When the user can't describe what they want in words, pin a **reference** — best to worst: **source code** > design components > diagrams > docs > screenshots. "Point at `vendor/rate-limiter` and reimplement its backoff semantics in TS" beats three paragraphs, even across languages. Record the references in the map so `/spec` and `/craft` inherit them.

## 6. Emit the unknowns map
Write `unknowns-map.md` (always — source of truth) and, **by default, render `unknowns-map.html`** using the `html` house style. **Lead with the decisions most likely to change** (resolved architecture-movers, open questions), and bury settled/mechanical context at the bottom.
- Read `../html/references/principles.md` first; the HTML must pass its self-check (system font stack applied **literally, never via `var()`**; light+dark via `prefers-color-scheme`; status by color **and** icon+shape+text; `localStorage` guarded; motion guarded; no horizontal scroll).
- Use `templates/unknowns-map.html` as the starting shell. Give the `<title>` a unique slug + date (e.g. `Unknowns · auth-provider · 2026-07-04`) — the artifact's saved answers are keyed by it in `localStorage`.
- The artifact cannot talk back to Claude, so give it a **copy-back**: a natural-language directive summarizing the resolved decisions + still-open questions, self-contained enough to paste into `/spec` with the artifact closed (principles.md → *Prompt-output craft*).
- Suppress the HTML only when the invocation passes `--no-html` (also accept a bare `no-html` / `skip-html` token). Never hand-edit the HTML; it is a regenerable view of the markdown.

## 7. Handoff (soft recommendation, not a takeover)
Close by recommending `/spec` in prose — do **not** auto-invoke it. Paste the copy-back in. If visual/structural space still needs a cheap spike first, say so, then still land on `/spec` once the unknown is small enough to plan.

Discovery reduces unknowns; it does not decide for the user.

## Deslinde (why this doesn't duplicate anything)
- **vs `spec`** — `spec` plans a change you already understand and stops for approval. `discover` runs *before* that, when the change isn't understood yet. Feed `discover`'s map into `spec`.
- **vs `html`** — `html` renders docs; `discover` produces the content and reuses `html`'s principles for its one artifact. It does not rebuild the template engine.

## Scope note
`discover` covers only the **pre-implementation** techniques from the field guide (blindspot pass, four-quadrant map, interview, references). The *during* technique (implementation-notes deviation log) belongs in `/craft` and the *post* technique (quiz-before-merge) in `/vet` — tracked as future grafts, intentionally not built here.
