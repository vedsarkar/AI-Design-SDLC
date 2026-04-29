# PRD: Agentic Design Pipeline for Reltio Forge
**Status:** Draft v1.0
**Owner:** Ved Sarkar
**Date:** 2026-04-28
**Project Root:** reltio-forge

---

## 1. Problem Statement

Manual design processes take too long and edge cases are not consistently covered. As product complexity grows, relying on purely human-driven design cycles introduces delays, inconsistency, and missed scenarios that only surface during development or QA. We need agentic ways to fast-track the design process — from problem statement to validated wireframes to final output — without sacrificing quality or DS compliance.

**Primary Focus:** PM → Designer handoff quality and speed.

**Final Deliverable:**
1. [Design](#5-done-state-1--design-path) — Hi-fi Figma designs generated via Claude wireframe + Figma;
2. [Frontend Code](#6-done-state-2--frontend-code-path) — Designer builds frontend directly from approved wireframe using dev-provided UI components and vibe coding.

---

## 2. Goals & Success Metrics

| Goal                            | Metric                                          |
|---------------------------------|-------------------------------------------------|
| Reduce PM→Designer handoff time | Days from Jira ticket to first wireframe draft  |
| Reduce PM review cycles         | # of review iterations before PM sign-off       |
| Accelerate full product cycle   | Days from Jira ticket to design-ready-for-dev   |

---

## 3. Personas

### Primary — PM 
- **Need:** Validate designs against PRD without spending hours in Figma
- **Pain:** Waiting days for first wireframe draft with no itearation and concepts
- **Win:** Jira ticket → reviewed, AI driven wireframe in hours

### Primary — Designer 
- **Need:** Full context at start + know which Design components already exist
- **Pain:** Starting from zero, 10 back-and-forth questions before any design work
- **Win:** Starts with wireframe concepts with multiple itearations and move to Hi-Fid

### Secondary — Developer 
- **Need:** Figma handoff or code that doesn't shift mid-sprint
- **Pain:** Designs that change after implementation starts
- **Win:** PM-signed-off, DS-compliant design before any code is written

---

## 4. User Journey

### As-Is (Today)
```
PM writes Jira ticket/ creates PRD
→ Designer reads Jira → asks 10 questions 
→ Designer creates wireframe from scratch
→ PM reviews design with no prototypes
→ Iterate 3–4 times
→ Designer produces Figma hi-fi
→ Dev starts (unclear specs, frequent changes)

```

### To-Be (Agentic Pipeline)
```
Jira ticket created
→ PRD is used to create a Designer requirement (automated using BMAD)
→ BMAD agent for design prompt generation
→ Claude generates lo-fi wireframes iterations (automated)
→ PM reviews > Approve/Reject with structured feedback
→ FORK:
  ├── Done State 1: Figma Hi-Fi 
  └── Done State 2: Vibe Coded Frontend

```

---

## 5. Done State 1 — Design Path

### Overview

The Design path is a structured, AI-assisted UX/UI workflow where human designers stay in full creative control and AI accelerates every stage — from context generation to wireframe iteration to hi-fi production. The process is additive to the existing pipeline, not disruptive.

---

### Process Flow

```text
┌──────────────────────────────────────────────────────────────────────────────┐
│                         DONE STATE 1: DESIGN PATH                            │
└──────────────────────────────────────────────────────────────────────────────┘

[PM]                         [UX Designer]                         [UI Designer]
 │                                │                                      │
 ▼                                │                                      │
PRD Created                       │                                      │
 │                                │                                      │
 ▼                                │                                      │
UX/UI reads PRD                   │                                      │
+ uses reltio-forge               │                                      │
to generate problem               │                                      │
context                           │                                      │
 │                                │                                      │
 ▼                                │                                      │
Design Requirements               │                                      │
created -> Epics,                 │                                      │
Stories, Tasks                    │                                      │
pushed to Jira                    │                                      │
 │                                │                                      │
 └───────────────► BMAD Agent generates                                  │
                   design prompts from                                   │
                   requirements                                          │
                            │                                            │
                            ▼                                            │
                   Claude Wireframe /                                    │
                   Claude Design                                         │
                   First draft UX flow                                   │
                   (AI-generated + manual                                │
                   sketch support)                                       │
                            │                                            │
                            │                                            │
                            │                                            │
                            └────────────────────────────► UX + UI collaborate
                                                          Multi-concept exploration
                                                          per screen (2-3 options)
                                                                     │
                                                                     ▼
                                                          Present options to
                                                          Stakeholders
                                                                     │
                                                          ┌──────────┴──────────┐
                                                          │   Option selected   │
                                                          └──────────┬──────────┘
                                                                     │
                                                                     ▼
                                                          DESIGN FREEZE ✅
                                                          Final wireframe locked
                                                                     │
                                                                     ▼
                                                          UI moves to Hi-Fi
                                                          in Figma
                                                          (DS tokens applied)
                                                                     │
                                                                     ▼
                                                          Designer hygiene
                                                          check ✅
                                                                     │
                                                                     ▼
                                                          Hi-Fi delivered
                                                          -> Dev handoff
```

---

### Stage Breakdown

**Stage 1 — Context Generation**
UX/UI designer reads the PM's PRD and uses reltio-forge to generate structured problem context. This replaces the 10-question back-and-forth with the PM and gives the designer a complete picture before any design work begins.

**Stage 2 — Design Requirements in Jira**
From the generated context, the designer creates design-specific Epics, Stories, and Tasks in Jira. This ensures all design work is traceable to product requirements and sprint-plannable.

**Stage 3 — BMAD Prompt Generation**
The UX designer uses the BMAD agent to generate targeted design prompts from the Jira requirements. These prompts are the bridge between product intent and Claude's wireframe generation.

**Stage 4 — First Draft UX Flow (Claude Wireframe / Claude Design)**
Claude generates the initial UX flow wireframes from the prompts. Claude Design also supports manual sketching, enabling designers to quickly sketch ideas and feed them back into the iteration loop. This creates a fast, low-cost first draft without starting from zero.

**Stage 5 — UX + UI Concept Exploration**
UX and UI designers collaborate to produce 2–3 distinct concepts per key screen. Multiple options reduce the risk of a single direction being rejected late. Concepts are presented to stakeholders for selection.

**Stage 6 — Stakeholder Review & Design Freeze**
Stakeholders review the concept options and select one. The selected concept becomes the locked wireframe — **design freeze**. No further structural changes are made after this point.

**Stage 7 — Hi-Fi Production**
UI designer moves the frozen wireframe into Figma hi-fi, applying Reltio DS tokens, components, and interaction specs. The designer performs a final hygiene check before dev handoff.

---

### Key Benefits

- **Reduces late hi-fi expectation changes** — multiple concepts are explored and agreed before any hi-fi work begins, eliminating the most common source of rework for both UX and UI designers
- **Healthy AI–human collaboration** — AI is a tool that accelerates generation and iteration; the designer retains creative direction and performs the final quality check
- **Faster first draft** — BMAD prompt generation + Claude wireframing removes the blank-canvas problem and gets to a reviewable state in hours, not days
- **Full traceability** — every design decision traces back to a Jira story and PRD requirement

---

### North Star Vision

Use Claude Design as the primary tool to generate the final hi-fi deliverable directly from approved wireframes, with DS tokens applied automatically. The designer's role evolves to prompt engineering, concept direction, and quality validation rather than manual pixel production. Claude makes Hi-fig generator absolete 

**Technical dependency:** Claude Design capability maturity — this path becomes viable as Claude Design's fidelity and DS-awareness improves. The current workflow is designed to accommodate this transition without restructuring.

---

### Fiori Integration Path

This workflow can be adapted for SAP Fiori integration. At the BMAD prompt generation stage, Fiori design guidelines are injected as context constraints. Claude generates wireframes that are Fiori-compliant by default, and the UI designer applies Fiori component patterns in the hi-fi stage rather than Reltio DS tokens. The core process stages remain identical — only the design system context changes.

---

## 6. Done State 2 — Frontend Code Path

### Overview

The Frontend Code path skips Figma hi-fi entirely. After the wireframe is approved and design-frozen, the designer moves directly to building the frontend using UI components provided by the frontend development team. Claude (vibe coding) generates the component assembly from the wireframe context. This path is optimized for speed — one fewer translation layer between design intent and working UI.

---

### Process Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                DONE STATE 2: FRONTEND CODE PATH                     │
└─────────────────────────────────────────────────────────────────────┘

  [PM]              [UX Designer]         [UI Designer]       [Frontend Dev]
    │                    │                     │                    │
    ▼                    │                     │                    │
  PRD Created            │                     │                    │
    │                    │                     │                    │
    ▼                    │                     │                    │
  UX/UI reads PRD        │                     │                    │
  + uses reltio-forge    │                     │                    │
  to generate problem    │                     │                    │
  context                │                     │                    │
    │                    │                     │                    │
    ▼                    │                     │                    │
  Design Requirements    │                     │                    │
  → Epics, Stories,      │                     │                    │
  Tasks in Jira          │                     │                    │
    │                    │                     │                    │
    └──────────► BMAD Agent generates          │                    │
                 design prompts                │                    │
                      │                        │                    │
                      ▼                        │                    │
               Claude Wireframe /              │                    │
               Claude Design                   │                    │
               First draft UX flow             │                    │
               (AI + manual sketch)            │                    │
                      │                        │                    │
                 ◄────┤ Iterate                │                    │
                      │                        │                    │
                      └──────────────► UX + UI collaborate         │
                                         Multi-concept exploration  │
                                         per screen (2–3 options)  │
                                                  │                 │
                                                  ▼                 │
                                          Present to Stakeholders   │
                                                  │                 │
                                       ┌──────────┴──────────┐     │
                                       │   Option selected   │     │
                                       └──────────┬──────────┘     │
                                                  │                 │
                                                  ▼                 │
                                          DESIGN FREEZE ✅          │
                                          Wireframe locked          │
                                                  │                 │
                    ╔═════════════════════════════╪═════════════════╪══╗
                    ║   FORK — NO HI-FI PRODUCED  │                 │  ║
                    ╚═════════════════════════════╪═════════════════╪══╝
                                                  │                 │
                                                  │  Frontend Dev   │
                                                  │  provides ──────┘
                                                  │  UI component
                                                  │  library
                                                  │
                                                  ▼
                                          Designer uses Claude
                                          (vibe coding) to assemble
                                          frontend from:
                                          → Approved wireframe
                                          → Dev-provided components
                                          → Reltio DS tokens
                                                  │
                                             ◄────┤ Iterate
                                                  │
                                                  ▼
                                          Designer hygiene
                                          check ✅
                                          (layout, component
                                           fidelity, edge cases)
                                                  │
                                                  ▼
                                          Frontend delivered
                                          → Dev handoff
```

---

### Stage Breakdown

**Stages 1–6 — Shared with Design Path**
Context generation, Jira requirements, BMAD prompts, Claude wireframe, concept exploration, stakeholder review, and design freeze are identical to the Design path. This ensures both paths produce a high-quality, stakeholder-approved wireframe before diverging.

**Stage 7 — Component Handoff from Frontend Dev**
Before the designer begins building, the frontend development team provides the UI component library — the approved set of React (or framework) components aligned to Reltio DS. This is the designer's building block set. No components are created from scratch; the designer assembles, not authors.

**Stage 8 — Vibe Coding with Claude**
The designer uses Claude to generate frontend code directly from the approved wireframe and the provided component library. Claude composes screens by mapping wireframe elements to real components. The designer directs — specifying layout, interaction states, and edge cases — while Claude handles the boilerplate.

**Stage 9 — Designer Hygiene Check**
The designer reviews the generated frontend against the approved wireframe: layout accuracy, component fidelity, responsive behaviour, and edge case coverage. This is the human quality gate. Corrections are fed back to Claude for adjustment.

**Stage 10 — Frontend Delivered**
The reviewed, designer-verified frontend is handed off to dev for integration. No Figma file is produced — the frontend code is the deliverable.

---

### Key Difference from Design Path

|                      | Design Path              | Frontend Code Path                     |
|----------------------|--------------------------|----------------------------------------|
| Output               | Figma hi-fi file         | Working frontend code                  |
| Hi-fi step           | Required                 | Skipped entirely                       |
| Who builds           | UI Designer in Figma     | Designer via vibe coding               |
| Component source     | Reltio DS tokens         | Dev-provided component library         |
| Speed                | Slower (hi-fi production)| Faster (direct to code)                |
| Best for             | Complex, exploratory UI  | Well-scoped, component-driven screens  |

---

### Key Benefits

- **Eliminates the hi-fi translation layer** — the most common source of "it looked different in Figma" feedback disappears because there is no Figma file
- **Faster time-to-dev** — wireframe freeze → working frontend in hours, not days
- **Designer stays in control** — vibe coding means the designer directs the output; Claude does not produce unsupervised code
- **Healthy AI–human collaboration** — AI handles assembly and boilerplate; designer handles intent, judgment, and the final hygiene check
- **Reuses dev-approved components** — no design-dev component mismatch; the exact same components used in production are used in the design output

---

### North Star Vision

> The designer describes a screen in natural language, Claude assembles it from the component library, and the output is production-ready frontend code — reviewed and approved by the designer in a single session. The gap between design intent and shipped UI becomes zero.

**Technical dependency:** Quality and consistency of the dev-provided component library. The richer and better-documented the component set, the higher the fidelity of Claude's assembly. Component library maturity is the primary lever for this path's success. 

**pipeline Overview:** Designer becomes developer and QA, No design reference, possibily not scalable and steep learning curve

---

### Fiori Integration Path

This path adapts directly for Fiori. At Stage 7, the frontend dev provides SAP Fiori UI5 components instead of Reltio DS components. BMAD prompts at Stage 3 include Fiori guidelines as context constraints. Claude assembles the frontend using Fiori components, and the designer validates against Fiori interaction patterns. The process is identical — only the component source changes.

---

