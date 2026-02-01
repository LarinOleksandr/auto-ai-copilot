---
name: brainstorming
description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent and requirements before implementation."
---

# Brainstorming Ideas Into PRDs

## Overview

Help turn ideas into a clear PRD through natural collaborative dialogue.

Ask questions one at a time to refine the idea. Once you understand what you're building, present the PRD in small sections (200-300 words), checking after each section whether it looks right so far.

## The Process

**Understanding the idea:**

- Ask questions one at a time to refine the idea
- Prefer multiple choice questions when possible, but open-ended is fine too
- Only one question per message - if a topic needs more exploration, break it into multiple questions
- Focus on understanding: purpose, constraints, success criteria

**Exploring approaches:**

- Propose 2-3 different approaches with trade-offs
- Present options conversationally with your recommendation and reasoning
- Lead with your recommended option and explain why

**Presenting the PRD:**

- Once you believe you understand what you're building, present the PRD
- Break it into sections of 200-300 words
- Ask after each section whether it looks right so far
- Cover: goal, problem, scope, out of scope, acceptance criteria, constraints, risks, and validation
- Be ready to go back and clarify if something doesn't make sense

## After the Design

**Documentation:**

- Write the validated PRD to `ROOT_AGENTS_ARTIFACTS/prds/YYYY-MM-DD-<topic>-prd.md`
- Repository gate (must, before proposing any planning or implementation):
  - Check `git` is installed and available on PATH (see `KB_REPOSITORY_RULES`).
  - Check we are inside a git repository.
  - Check a remote `origin` exists (so work can be pushed and shared).
  - If either is missing: invoke `$repo-bootstrap` next.
  - Otherwise: invoke `$commit-push-create-pr` next to save the PRD.

**Strict next step (no choices):**

- After the PRD is saved to a remote repo (commit + push), the next required step is `$project-setup`.
- Do not propose `$plan-creation` or feature implementation from this thread.

**User-facing handoff (required):**

- Provide:
  - Suggested next thread name (compliant with `KB_THREADS`), and
  - A copy/paste first message for the new thread that:
    - references the PRD artifact path, and
    - invokes exactly one required next skill (`$repo-bootstrap` or `$commit-push-create-pr`, based on the repository gate).
  - Path rule: use `KB_ROOTS` aliases or repo-relative paths; do not use absolute OS paths.

**Implementation (later):**

- Planning and implementation happen only after `$project-setup` is completed and saved to the repo.

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from the PRD
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design in sections, validate each
- **Be flexible** - Go back and clarify when something doesn't make sense
