# Mindora — Development Roadmap

Mindora is built through controlled milestones. Each milestone has a defined scope, acceptance criteria, and verification report before moving to the next.

---

## Milestone 0 — Product and Technical Foundation *(Current)*
- **Scope:** Initialize Flutter (`com.mindora.app`, Android & iOS), initialize Git (no auto-commit), add initial dependencies (`flutter_riverpod`, `go_router`, `flutter_lints`), create permanent `docs/`, add minimal entry point and initialization test.
- **Acceptance Criteria:** Clean project structure, `flutter analyze` passes, initialization test passes, Android target launches if available, iOS support preserved.

## Milestone 1 — Design System
- **Dependencies:** Milestone 0 + font license verification (Lora & Inter).
- **Scope:** Exact 5-color palette tokens, bundled typography, spacing, layout primitives, buttons, inputs, cards, navigation components, iconography guidelines, welcoming empty states, and WCAG accessibility contrast checks.
- **Acceptance Criteria:** Theme tokens verified, contrast checks documented, widget tests pass for core primitives.

## Milestone 2 — Application Shell
- **Dependencies:** Milestone 1.
- **Scope:** Persistent 5-tab navigation (`Home`, `Track`, `Clarity`, `Toolkit`, `Profile`) via `go_router`, independent routes for the 5 experiences, theme integration, Riverpod root wiring.
- **Acceptance Criteria:** Tab state persists across switches, independent routes open from any tab, navigation tests pass.

## Milestone 3 — Home
- **Dependencies:** Milestone 2.
- **Scope:** Calm overview, **Living Tapestry** concept, gentle access portals to the 5 independent experiences, recent activity placeholder/summary, non-obligatory contextual invitations.
- **Acceptance Criteria:** Zero streak/guilt UI, responsive layout, widget & accessibility tests pass.

## Milestone 4 — First Complete Experience: Feelings
- **Dependencies:** Milestone 3 + **Mandatory Security & Data Model Evaluation** (daily-record schema + encryption/app-lock trade-offs).
- **Scope:** Full end-to-end implementation of **Feelings**—UI, multiple emotions, optional description/context, editing, SQLite daily-record persistence, retained created/updated timestamps, data-integrity tests, and history integration.
- **Acceptance Criteria:** Feelings entries save, update without overwriting unrelated fields, persist across restarts, and pass unit, repository, and widget tests.

## Milestone 5 — Remaining Four Experiences
- **Dependencies:** Milestone 4.
- **Scope:** Implement **My State**, **My Body**, **What Shaped Today**, and **My Thoughts** one by one, integrating each with the shared daily-record model while preserving their independent character and missing-value integrity.
- **Acceptance Criteria:** Each experience works standalone, preserves qualitative/missing values, and passes full tests.

## Milestone 6 — Track
- **Dependencies:** Milestone 5.
- **Scope:** Chronological history, daily record view, filters by dimension and experience, editing, search, historical navigation, and meaningful connections between entries.
- **Acceptance Criteria:** Accurate timeline/filtering, non-destructive editing, repository and widget tests pass.

## Milestone 7 — Clarity
- **Dependencies:** Milestone 6.
- **Scope:** Transparent, deterministic local insights, personal baselines, comparison periods, calm non-overwhelming visualizations, and non-diagnostic observation language.
- **Acceptance Criteria:** 100% functional offline without AI; unit tests verify calculations and non-causal phrasing.

## Milestone 8 — Toolkit and Profile
- **Dependencies:** Milestone 7.
- **Scope:** Interactive grounding/breathing/reflection tools in **Toolkit**; personal settings, privacy/security controls, data management, and user-previewed local export (PDF/CSV/JSON) in **Profile**.
- **Acceptance Criteria:** Toolkit tools work offline; Profile exports/deletions are verified by tests.

## Milestone 9 — Advanced Capabilities *(Deferred)*
- **Dependencies:** Milestone 8 + dedicated design/safety reviews per module.
- **Scope:** Medication management, personalized mental health journeys, optional free/local AI companion, multi-device sync (with conflict handling), private social circles (max 8 members), optional professional access, emergency profile, and advanced reports.
- **Acceptance Criteria:** Each module is scoped, reviewed for safety/privacy, and tested independently without destabilizing the core app.
