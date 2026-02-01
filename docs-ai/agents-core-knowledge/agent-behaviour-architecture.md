# Agent-Behaviour-Architecture

## Purpose

- Optimizes context usage
- Prevents rework and unsafe changes
- Scales with repo complexity
- Aligns with Codex's current architecture (AGENTS.md scoping, Skills, routed docs)

This document defines how to build and maintain the framework, not its concrete contents.

---

## Core design principles

1. **Thin always-on context** - Only constraints, routing, and completion rules are always loaded.
2. **Single source of truth** - Each rule or concept lives in exactly one place.
3. **On-demand knowledge** - Large reference material is consulted only when routed.
4. **Procedures != rules** - Rules live in AGENTS.md; procedures live in Skills.
5. **Locality of constraints** - Rules apply at the closest directory level where they differ.

---

## Instruction layers (evaluation order)

1. Root AGENTS.md
2. Nearest scoped AGENTS.md
3. Invoked Skill(s)
4. Routed reference docs

Later layers may extend but must not contradict earlier ones.

---

## Framework components

### 1) Root instruction layer

**Role:** Constitution + router  
**Properties:**

- Always read by Codex
- Small, stable, low-churn

**Responsibilities:**

- Non-negotiable constraints (security, data, migrations, outputs)
- Minimal workflow expectations (not step-by-step procedures)
- Routing rules ("if touching X -> consult Y")
- Definition of done
- Index of available docs and skills (names only)

**Non-responsibilities:**

- Detailed architecture
- Command lists or tool catalogs (live in docs-ai/agents-core-knowledge/tools.md)
- Step-by-step procedures

---

### 2) Scoped instruction layers

**Role:** Local rules or root rules overrides  
**Placement:** Only where constraints materially differ

**Rules:**

- Extend or override root rules
- Must stay smaller than root
- Must not restate global rules
- Must be colocated with the code they govern

**Use when:**

- A directory has different safety, data, or output rules
- A component enforces unique patterns or guarantees

---

### 3) Routed reference documentation

**Role:** On-demand knowledge  
**Location:** Dedicated folder (e.g. `docs-ai/agents-core-knowledge/`)

**Characteristics:**

- Not automatically loaded
- Accessed only via explicit routing
- Single-topic ownership per file

**Required structure:**

- Agent-oriented summary at top
- Decision rules and checklists
- Canonical commands/examples when relevant
- No duplication across files

**Examples of suitable content:**

- Architecture principles
- Runtime topology
- Data/storage rules
- Testing strategy
- Output/schema rules
- Tools and commands

---

### 4) Skills (Codex procedural units)

**Role:** Executable procedures  
**Definition:** A Skill encapsulates a repeatable, multi-step workflow.

**Use a Skill when the task is:**

- Procedural
- Error-prone
- Repeated across the project
- Requires acceptance criteria

**Properties:**

- Explicit invocation
- Self-contained steps
- Clear success checks
- Optional scripts/templates/resources

**Non-responsibilities:**

- General policy
- Architectural explanation

---

### 5) Planning artifact

**Role:** Control for large or risky changes

**Trigger conditions:**

- Multi-component changes
- Schema or contract evolution
- New agents/services/workflows
- Broad refactors

**Purpose:**

- Force explicit scope, risks, and validation
- Act as temporary coordination state
- Prevent implicit assumptions during long tasks

---

## Separation of concerns (hard rule)

| Concern                | Lives in                             |
| ---------------------- | ------------------------------------ |
| Hard constraints       | AGENTS.md                            |
| Local rules/exceptions | Scoped AGENTS.md                     |
| Knowledge/reference    | docs-ai/agents-core-knowledge |
| Procedures             | Skills                               |
| Large change intent    | Planning artifact                    |

No concern may appear in more than one category.

---

## Evolution rules

- **Root AGENTS.md:** change rarely, intentionally
- **Scoped AGENTS.md:** change only with local constraint changes
- **Reference docs:** evolve freely, keep summaries accurate; prune redundancies
- **Skills:** version as procedures change
- **Blueprint:** change only if Codex behavior model changes

---

## Maintenance workflow

- Use `$context-maintenance` for audits and updates (see `KB_CONTEXT_MAINTENANCE`).

---

## Success criteria

The framework is correct if:

- Codex can act safely with only root context
- Additional context is loaded only when relevant
- Large changes trigger planning by design
- Repeated workflows converge into Skills
- Context size grows sub-linearly with repo complexity

---

## Anti-patterns to avoid

- One giant AGENTS.md
- Duplicating rules across files
- Encoding procedures as prose rules
- Workflow procedures in reference docs
- Tool catalogs without routing discipline

---

## Final note

This blueprint defines how to instruct Codex, not what to instruct.  
Concrete rules, commands, and architecture details must live in their designated layers and be referenced, not repeated.
