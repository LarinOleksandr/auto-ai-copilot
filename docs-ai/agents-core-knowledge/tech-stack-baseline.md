# Tech Stack

## Agent summary

- Baseline/default stack for this framework (not project-specific).
- Current project stack lives in `DOC_PROJECT_CONTEXT`.
- Changes to this baseline require user approval.

## Project stack ownership

If the current project stack differs from this baseline, update `DOC_PROJECT_CONTEXT` with the actual stack and note the reason. If the baseline itself changes, update this file and get user approval.

---

## Frontend

- **React 18** - Render dynamic UI and manage component state for the step-by-step wizard.
- **TypeScript** - Provide static typing to ensure safe data flow between UI and agents.
- **Vite** - Compile and bundle frontend code with fast tooling and optimized builds.
- **Tailwind CSS** - Provide utility-first styling for consistent, rapid UI development.
- **shadcn/ui** - Supply ready UI components for forms, dialogs, and wizard panels.
- **React Router** - Map wizard steps to URLs and manage navigation state.
- **TanStack Query** - Handle async data fetching, caching, and state synchronization.
- **TipTap** - Provide in-app rich-text editing for agent-generated documents.
- **React Flow** - Visualize the multi-agent workflow graph and execution state.
- **Zod** - Validate user inputs and agent outputs with typed schemas.

---

## Backend and data

- **Supabase Postgres** - Store projects, workflow states, document versions, and agent outputs.
- **Supabase Auth** - Manage user authentication and secure project separation.
- **Supabase Storage** - Persist deliverables such as PDFs, DOCX, and JSON files.
- **Supabase Realtime** - Push live updates when agents finish or documents change.
- **pgvector** - Enable semantic search and retrieval of embeddings for agent context.
- **Supabase Edge Functions** - Execute backend logic for orchestration and exports.
- **Row-Level Security** - Enforce per-user access control on database rows.
- **supabase-js** - Provide unified client APIs for DB, auth, storage, and functions.

---

## AI and orchestration

- **LangGraph JS** - Define and run multi-agent workflows as a directed graph.
- **LangChain.js** - Manage prompts, LLM calls, retrieval, and agent tooling integration.
- **Ollama** - Run local open-source LLMs for cost-free inference.
- **Embedding Service (FastAPI)** - Compute text embeddings for pgvector-based semantic search.
- **Parsing and export tools** - Convert agent outputs into PDF, DOCX, Markdown, or structured formats.
- **JSON generation and validation layer** - Enforce structured JSON outputs via schemas and LLM modes.

---

## File deliverables

- **Supabase Storage** - Store versioned deliverable files produced by agents.
- **Postgres version metadata** - Track document versions, approvals, and change history.
- **Document diffing** - Compare text/JSON versions to detect changes between iterations.
- **JSON Schema / Zod validators** - Validate structural correctness of generated JSON deliverables.
- **Export libraries** - Generate output formats such as DOCX, PDF, and Markdown.
- **jszip** - Bundle deliverables into downloadable ZIP archives.
- **Automatic file naming** - Standardize storage paths and naming for agent outputs.

---

## Infrastructure and DevOps

- **GitHub monorepo** - Centralize all code for unified versioning and CI/CD.
- **Netlify** - Host and auto-deploy frontend builds.
- **Supabase Hosting** - Host database, storage, auth, and serverless backend.
- **Linux VM with Docker** - Host AI runtime services including LLM and embedding APIs.
- **Docker** - Containerize agents for reproducible deployment.
- **GitHub Actions** - Run tests and deploy backend and AI services automatically.
- **Sentry** - Monitor runtime errors in frontend and backend.
- **PostHog** - Collect analytics for wizard usage and behavior patterns.
- **Central log aggregation** - Aggregate logs from agents, containers, and backend for debugging.
- **Testing stack** - Provide automated tests across UI, workflows, and AI microservices.
- **Code quality tools** - Enforce linting, formatting, and strict type safety.

---

## Analytics, monitoring, quality

- **PostHog** - Analyze user flow metrics and step completion rates.
- **Sentry** - Capture agent and backend execution errors.
- **Supabase Logs** - Provide backend logs for workflow and agent operations.
- **OpenSearch / Logflare** - Store and query full-system logs across services.
- **Vitest** - Run unit tests for UI components and shared logic.
- **Playwright** - Execute end-to-end tests validating wizard flows.
- **Pytest** - Test Python embedding and AI microservices.
- **ESLint + Prettier** - Maintain code hygiene and formatting consistency.
- **TypeScript Strict Mode** - Prevent invalid data structures across agent pipelines.
