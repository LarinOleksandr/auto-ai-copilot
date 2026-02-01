# Product PRD (Whole Application) - Template

Use this when you are defining the whole product or a big initiative (not just one feature).

## Summary

- Problem (one sentence):
- Proposed solution (one sentence):
- Why now (timing):
- Primary success metric (baseline -> target):
- Biggest risk:

## Market opportunity (optional)

Use this only if market timing and business value matter for the decision.

- Market / category:
- Evidence of growth or urgency (links, sources, or notes):
- Rough size (if known) and assumptions:
- External factors (regulatory, platform, macro) that matter:
- Biggest risk in our market assumptions:

## Strategic alignment (optional)

Use this only if you must justify "why us" and "why now".

- What company/product goal does this support?
- Why is this the right problem for our team to solve?
- What strengths do we have (data, distribution, partnerships, integrations)?
- What tradeoffs are we choosing (speed vs quality, breadth vs depth)?

## Customer and user needs

- Target segment(s) and key constraints (region, language, compliance):
- Primary job-to-be-done:
- Top pains (frequency + severity + evidence if available):
- What we will NOT solve (to stay focused):

## Primary user profile

Describe the main user we optimize for.

- User role:
- Context (when/where/conditions):
- Goals (concrete outcomes):
- Needs (what they must be able to do):
- Time constraints:
- Habits (current workflows):
- Tools they use today:
- Competencies (domain knowledge):
- Technical skills (low/medium/high + why):
- Frustrations:
- Expectations (speed, clarity, defaults, reliability):

Example (invoice app):
- User role: solo consultant
- Context: invoicing between client calls, often from phone/laptop
- Goals: bill 5-20 clients/month with no mistakes
- Needs: create/send invoice in under 2 minutes with sensible defaults
- Time constraints: must be immediate or gets postponed
- Habits: reuse templates, copy/paste details, batch weekly
- Tools: Google Sheets / lightweight SaaS
- Competencies: basic invoicing knowledge
- Technical skills: medium; dislikes setup
- Frustrations: bloated tools, slow flows, unclear terms
- Expectations: instant usability, professional output by default

## Jobs-to-be-done

Describe the primary job we optimize for and the jobs around it.

### Primary Job

Format: When <situation>, I want to <motivation>, so I can <desired outcome>.

- Primary job:

Example:
- When I finish work for a client, I want to create and send an invoice immediately, so I get paid without delays or extra mental effort.

### Functional Jobs

Concrete tasks the user must complete to accomplish the job.

- ...

Example:
- Create a professional invoice in under 2 minutes.
- Reuse saved client and service data without manual copying.
- Send the invoice to the client in a few clicks.
- See whether an invoice is sent, unpaid, or paid.

### Emotional Jobs

How the user wants to feel while and after completing the job.

- ...

Example:
- Feel confident the invoice is correct.
- Avoid stress from admin work.
- Feel relief after finishing invoicing quickly.

### Social Jobs

How the user wants to be perceived by others.

- ...

Example:
- Look professional and organized to clients.
- Avoid appearing careless or disorganized.

### Related Jobs

Supporting or adjacent jobs that occur before, during, or after the main job.

- ...

Example:
- Create invoices between meetings or calls.
- Handle invoicing without switching tools.
- Return to billable work immediately after invoicing.

### Job Triggers

Events or situations that cause the job to arise.

- ...

Example:
- A client call or milestone ends.
- End of week or end of month.
- A client payment is overdue.

### Desired Outcomes

Measurable success criteria from the user's perspective. These often become product baselines and success metrics.

- ...

Example:
- Invoice sent in under 2 minutes.
- No setup or onboarding required.
- Client receives a clean, professional invoice instantly.

### Current Alternatives

How users solve the job today, including workarounds.

- ...

Example:
- Google Sheets / Excel templates.
- Lightweight SaaS tools used minimally.
- Copying data from previous invoices.

### Constraints

Limits that shape solutions (time, skills, environment, tolerance).

- ...

Example:
- Very limited time and attention.
- Medium technical comfort.
- Low tolerance for complexity or feature overload.

## Product rules and baselines

These are the product-level decisions every Feature PRD must follow (unless explicitly changed here first).

- Product scope boundaries (global in-scope / out-of-scope):
- Success metrics (north star + guardrails):
- Non-functional baselines (performance, reliability, security/privacy, accessibility, observability):
- Protected contracts (must-not-break defaults): `DOC_PROJECT_PROTECTED_CONTRACTS`
- AI rules (only if AI exists): grounding, safety limits, evaluation cadence:
- Data policy (retention, export, deletion), if applicable:

## Value story (narrative)

Write in simple user language. Focus on what changes for the user.

- Who its for:
- Context (when/where this matters):
- What happens today (why it fails):
- What changes with this product:
- Moment of value (the first point a user feels the benefit):
- Simple walkthrough (3-7 steps):

## Value proposition and messaging (optional)

Use this only if positioning matters right now.

- Outcomes for the user (measurable if possible):
- How this differs from alternatives:
- One-sentence positioning statement:

## Competitive advantage (optional)

- What makes this hard to copy (data, integrations, partnerships, workflows, distribution)?
- How durable is the advantage (and what could erode it)?

## Product scope

### Key use cases

- Use case 1:
- Use case 2:
- Use case 3:

### In scope (high-level capabilities)

List 5-12 capabilities at a high level.

Acceptance criteria here are **capability-level** (short, outcome-focused). Feature PRDs will refine them with build/test-level detail.

For each capability:

- Capability:
- Intended user outcome:
- Acceptance criteria (capability-level; 1-3 pass/fail outcome checks):
- Priority: P0 / P1 / P2 (rough)

### Out of scope

- ...

### Backlog outline (feature PRDs)

List the next features that will need their own **Feature PRD**. Keep this as a numbered list.

- 1. Feature name - 1 sentence goal
- 2. Feature name - 1 sentence goal

## Non-functional requirements (only what matters)

These are product-level baselines. Feature PRDs should only state deltas.

- Performance (targets):
- Scalability (targets):
- Reliability / availability (targets):
- Security / privacy / compliance:
- Accessibility:
- Observability (logs/metrics/alerts):
- Data retention / export / deletion:

### AI quality requirements (only if this includes AI)

Keep this measurable and testable.

- Quality target (what "good output" means):
- How we reduce wrong answers (grounding, citations, refusal rules):
- Safety: what the system must never do:
- Evaluation plan (test set, human review, cadence):
- Monitoring for drift (how we detect quality degradation over time):

## Go-to-market approach (optional)

Use this only if launch and adoption are part of the decision.

- First segment to launch to (smallest clear segment):
- How we prove value fast (timebox + measurable outcome):
- Adoption plan (channels / enablement):
- Phases (MVP, beta, GA) and what unlocks each phase:

## Milestones, dependencies, resourcing

- Milestones:
- Dependencies:
- Resourcing (roles):

## Assumptions and open questions

Use strict format.

- ASSUMPTION:
  - VALIDATE BY:
  - IMPACT IF FALSE:
- OPEN QUESTION:
  - OWNER:
  - DUE:

## Appendices (optional)

- Research evidence:
- Flows / wireframes:
- Metrics spec:
- Technical notes:
- Risk register:
