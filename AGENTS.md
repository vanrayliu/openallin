# OpenAllIn — Unified AI Coding Harness

> A layered, composable engineering framework combining the best of OpenSpec, Superpowers, GSD, OMC, ECC, and Trellis.

## Architecture

OpenAllIn uses a **layered, composable** design where each layer is independently optional and freely combinable:

```
┌─────────────────────────────────────────────────┐
│  Layer 6: Workspace  — Project Memory &          │  ← Trellis
│             Parallel Pipeline                     │
├─────────────────────────────────────────────────┤
│  Layer 5: Orchestration — Multi-Agent Team       │  ← OMC
│             Coordination                          │
├─────────────────────────────────────────────────┤
│  Layer 4: Execution — Phase-Based Workflow &     │  ← GSD
│             Context Engineering                   │
├─────────────────────────────────────────────────┤
│  Layer 3: Enhancement — Security / Memory /      │  ← ECC
│             Learning / Verification               │
├─────────────────────────────────────────────────┤
│  Layer 2: Skills — Engineering Methodology       │  ← Superpowers
│             Library                               │
├─────────────────────────────────────────────────┤
│  Layer 1: Spec — Spec-Driven Development         │  ← OpenSpec
└─────────────────────────────────────────────────┘
```

## Core Principles

1. **Spec First** — Align on requirements before writing code
2. **Engineering Discipline** — Make best practices the default behavior
3. **Context Hygiene** — Small tasks, phase separation, structured information
4. **Team Orchestration** — Multiple agents collaborate like a real team
5. **Capability Enhancement** — Security, memory, learning, verification loops
6. **Project Memory** — File-based persistence over LLM memory

## Quick Start

See README.md (Chinese) for full documentation.

### Commands

```
/oa:propose <name>    → Create change proposal
/oa:apply <name>      → Execute tasks from checklist
/oa:discuss <phase>   → Discuss and clarify requirements
/oa:plan <phase>      → Plan atomic tasks
/oa:execute <phase>   → Execute in waves
/oa:verify <phase>    → Verify quality
/oa:ship <phase>      → Ship and create PR
/oa:brainstorm        → Brainstorming session
/oa:tdd               → Test-driven development
/oa:debug             → Systematic debugging
/oa:review            → Code review
```

## License

MIT
