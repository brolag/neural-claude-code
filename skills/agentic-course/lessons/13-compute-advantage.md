# Lesson 13: Compute Advantage

## Objective

Measure and optimize your agentic leverage ratio.

## What is Compute Advantage?

```
                Compute Scaling × Autonomy Duration
        CA = ─────────────────────────────────────────
                 Time + Effort + Monetary Cost
```

**In plain words:** How much work does AI do for you vs. how much you invest?

## The Formula Components

### Numerator (What You Get)

```
COMPUTE SCALING
How many "virtual developers" are working?
├── 1 loop = 1 developer
├── 3 parallel agents = 3 developers
└── Squad of 5 = 5 developers

AUTONOMY DURATION
How long do they work without you?
├── 10 minutes supervised = 0.17 hours
├── 1 hour autonomous = 1 hour
└── 8 hours overnight = 8 hours
```

### Denominator (What You Invest)

```
TIME
Your setup and monitoring time
├── 5 min spec = 0.08 hours
├── 15 min CRAFT = 0.25 hours
└── 30 min planning = 0.5 hours

EFFORT
Cognitive load (0-10 scale)
├── Simple prompt = 1
├── CRAFT spec = 3
└── Full system design = 7

MONETARY COST
API and compute costs
├── Haiku session = $0.50
├── Sonnet session = $5
└── Opus session = $20
```

## Example Calculations

### Low CA (Bad Leverage)

```
You: Write prompts for 2 hours, supervise constantly
AI: Works for 2 hours with 1 agent

CA = (1 × 2) / (2 + 5 + 10) = 0.12
```

### High CA (Good Leverage)

```
You: 15 min CRAFT spec, then walk away
AI: 5 agents work for 4 hours

CA = (5 × 4) / (0.25 + 3 + 25) = 0.71
```

## CA Benchmarks

| CA Score | Interpretation |
|----------|----------------|
| < 0.1 | Poor leverage - might be faster to code yourself |
| 0.1 - 0.3 | Basic leverage - using AI as assistant |
| 0.3 - 0.5 | Good leverage - real productivity gains |
| 0.5 - 1.0 | Excellent leverage - AI multiplier working |
| > 1.0 | Maximum leverage - true autonomous operation |

## Track with /ca

```bash
# Calculate current session's CA
/ca

# Log a session
/ca log --agents 3 --hours 2 --setup 15 --effort 4 --cost 15

# View trends
/ca history
```

## Improving Your CA

### Increase Numerator

1. **More agents** - Use parallel execution
2. **Longer autonomy** - Better specs = less intervention
3. **Overnight loops** - Work while you sleep

### Decrease Denominator

1. **Less time** - Reuse CRAFT templates
2. **Less effort** - Let AI write first drafts
3. **Lower cost** - Use Haiku for simple tasks

## The Zero-Touch Goal

```
Zero Touch Engineering (ZTE):
You: Describe what you want (5 min)
AI: Delivers working solution (8 hours later)

CA = (1 × 8) / (0.08 + 2 + 30) = 0.25

With 5 agents:
CA = (5 × 8) / (0.08 + 2 + 50) = 0.77
```

## Try It

Calculate your last session's CA:

```bash
/ca
```

Or manually:
```
Agents used: ___
Hours worked: ___
Your setup time (hours): ___
Effort (1-10): ___
Estimated cost ($): ___

CA = (___ × ___) / (___ + ___ + ___)
```

## Check

Confirm you understand:

1. CA measures AI leverage
2. Numerator: compute × autonomy
3. Denominator: time + effort + cost
4. Higher CA = better leverage
5. Goal: maximize autonomous work, minimize investment

## Next

**Lesson 14: Building Your System** - Create your personalized agentic workflow.

```bash
/course lesson 14
```

---
*Completion: Mark this lesson done and continue*
