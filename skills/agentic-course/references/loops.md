# Quick Reference: Autonomous Loops

## Basic Usage

```bash
/loop "Task description" --max 10
```

## Options

| Flag | Description | Default |
|------|-------------|---------|
| `--max N` | Maximum iterations | 10 |
| `--timeout Xm` | Time limit | 30m |
| `--type TYPE` | Loop type | standard |
| `--craft` | Use CRAFT prompt | false |
| `--promise TEXT` | Completion signal | auto |

## Loop Types

```bash
/loop "Fix tests" --type standard    # Default
/loop "Add tests" --type tdd         # Test-driven
/loop "Fix lint" --type lint         # Linting
/loop "Feature" --craft              # With CRAFT spec
```

## Circuit Breakers

```
1. --max N        → Stop after N iterations
2. --timeout Xm   → Stop after X minutes
3. Stuck          → Same error 3x
4. Regression     → Tests regress
5. Token limit    → Context exhausted
```

## Commands

```bash
/loop "task"       # Start loop
/loop-status       # Check progress
/loop-cancel       # Stop loop
/todo-check        # See task status
```

## When to Use

✅ Good: Tests, linting, docs, consistent changes
❌ Bad: Design decisions, unclear requirements

---
*Quick reference from /course ref loops*
