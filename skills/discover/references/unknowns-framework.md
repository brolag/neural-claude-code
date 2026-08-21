# The Unknowns Framework

The method behind `/discover`. Adapted from Thariq's *A Field Guide to Fable: Finding Your Unknowns* (2026). Read this before running the skill; follow the reasoning, not just the steps.

---

## The core model: map vs territory

- **The map** is the representation of the work: your prompts, skills, and context — what you give the agent.
- **The territory** is where the work actually happens: the codebase, the real world, its actual constraints.
- **Unknowns** are the gap between them. When the agent hits an unknown, it *guesses* what you wanted. The more work in one pass, the more unknowns it hits, and the more guesses compound.

The skill of agentic coding is not writing more instructions — it's **reducing and planning for your unknowns**. Experts don't have zero unknowns; they *assume* unknowns and leave room for the agent to improvise through them.

---

## The four quadrants

| | **Known** | **Unknown** |
|---|---|---|
| **Known** | **Known knowns** — what's in your prompt; what you told the agent you want. | **Known unknowns** — what you're aware you haven't figured out yet. |
| **Unknown** | **Unknown knowns** — so obvious you'd never write it down, but you'd recognize it instantly if you saw it. | **Unknown unknowns** — what you haven't considered at all; knowledge you don't know exists. |

**How each quadrant fails, and the cheap fix:**

- **Known knowns** → risk is *over-specifying*. Too much detail makes the agent follow instructions even when a pivot is better. Fix: state intent and constraints, leave room to veer.
- **Known unknowns** → you know the questions. Fix: **interview** (§ below) or a targeted search.
- **Unknown knowns** → the silent killer of prototypes. You only surface the criterion when you see the wrong version. Fix: **brainstorm/prototype early** (a sketch, a spike, a throwaway mock) so you react cheaply, before it's wired into code. Small spec changes cause large code changes; reverting late is expensive.
- **Unknown unknowns** → you don't know what to ask. Fix: the **blindspot pass** — let Claude, which searches faster and knows more about the average topic, teach you your gaps.

The two-way failure of ignoring unknowns: too specific and the agent won't pivot when it should; too vague and it fills gaps with generic industry defaults that don't fit. You need to know *when the path is clear* and *when it has potholes* — that's exactly what the quadrants surface.

---

## Blindspot pass — prompt patterns

Give context about your starting point first; a pass without it is generic. Use the literal words "blindspot pass" and "unknown unknowns".

- *"I'm adding a new auth provider but I know nothing about the auth modules in this codebase. Do a blindspot pass to find my relevant unknown-unknowns and help me prompt you better."*
- *"I don't know what color grading is but I need to grade this video. Teach me my unknown-unknowns about color grading so I can prompt better."*

What the pass should return (grounded in real `path:line`, not best-practice bullets):
1. Prior/historical work in this area + why it was built that way.
2. Potholes, foot-guns, constraints hiding in the code.
3. What "good" looks like here — existing patterns and the quality bar.
4. The expert questions you didn't know to ask.

---

## Interview — heuristics

- **Architectural impact first.** Prioritize questions whose answer changes the design/architecture. A question that only changes a label can wait or be decided by default.
- **One focused batch at a time.** Later questions often depend on earlier answers; don't dump twenty at once.
- **Give context to guide the questions.** "Interview me about anything ambiguous in *this migration*" beats "interview me".
- **Stop early.** When no remaining question would move the architecture, stop. Completeness for its own sake wastes the user's attention.
- Prompt seed: *"Interview me one question at a time about anything ambiguous, prioritize questions where my answer would change the architecture."*
- **Deliberate divergence from the article:** the original says *one question at a time*; this skill batches ~4 per round via AskUserQuestion (design decision D4, 2026-07-04). Trade-off: a batch reads related decisions together and costs fewer round-trips; the price is that a later question can't react to an earlier answer within the same batch. When questions genuinely chain, split them across rounds.

---

## References — the intent-transfer ladder

When words are too slow or you lack the vocabulary, hand a reference. Best to worst:

1. **Source code** — a library/module/component that already implements the behavior or look you want. Point at the folder, say what to imitate; works even across languages ("read this Rust crate's backoff, reimplement the semantics in our TS client").
2. **Design components** — a live component whose *markup and structure* Claude can read, not just its screenshot.
3. **Diagrams / docs** — structural intent.
4. **Screenshots / images** — last resort; conveys the what, not the how.

Record references in the map so `/spec` and `/craft` inherit them.

---

## Where each field-guide technique lives (so `/discover` stays scoped)

| Technique | Phase | Home |
|---|---|---|
| Blind spot pass | pre | **`/discover`** |
| Four-quadrant map | pre | **`/discover`** |
| Interview | pre | **`/discover`** (spec does a light version if you skip discovery) |
| References | pre | **`/discover`** |
| Brainstorm / prototype | pre | a cheap spike before `/spec` |
| Implementation plan (HTML, decisions-first) | pre | `/spec` + `/html` (discover routes here) |
| Implementation notes (deviation log) | during | `/craft` — *future graft, not in discover* |
| Pitches & explainers | post | `/html` ResultViewer |
| Quiz-before-merge | post | `/vet` — *future graft, not in discover* |

---

## Why cheap now beats expensive later

Every explainer, blindspot pass, interview, prototype, and reference is a cheap way to find what you didn't know **before it gets expensive to fix**. Small changes in a spec cause drastically different implementations; reverting an agent's committed work is costly. Discovery is iterative — unknowns surface before, during, and after implementation — but the pre-implementation catch is the cheapest one there is.

## Source
Thariq (@trq212), *A Field Guide to Fable: Finding Your Unknowns*, 2026-07-03. Shared principles: `../../html/references/principles.md`.
