# Mindora — Technical Architecture

## 1. Overview & Guiding Principles
Mindora uses a **beginner-maintainable, feature-first Flutter architecture** with clear separation between **Presentation**, **Domain**, and **Data** layers.
- Build only what the current milestone needs—avoid speculative abstractions and code-generation boilerplate.
- Keep all core functionality **offline-first** and **free of paid external services**.

---

## 2. Folder Organization
```text
lib/
├── main.dart                     # Application entry point & ProviderScope
├── app/                          # App-level widget, theme wiring, and router
├── core/                         # Shared design system, utilities, and storage (later)
└── features/                     # Self-contained feature modules
    ├── home/
    ├── track/
    ├── clarity/
    ├── toolkit/
    ├── profile/
    └── experiences/
        ├── feelings/
        ├── my_state/
        ├── my_body/
        ├── what_shaped_today/
        └── my_thoughts/
```
Inside each feature (added as features are built):
- `presentation/` — Screens, widgets, and view controllers.
- `domain/` — Plain Dart models, value rules, and repository interfaces (no Flutter UI imports).
- `data/` — Local persistence implementations and mappers.

---

## 3. State Management
- **Choice:** `flutter_riverpod` **without code generation**.
- **Why:**
  - Shares state cleanly across screens without `BuildContext` coupling.
  - Makes dependency injection straightforward so tests can swap real storage for in-memory fakes.
  - Avoiding `riverpod_generator` eliminates `build_runner` complexity and generated files, keeping the codebase accessible for a beginner developer.

---

## 4. Navigation Strategy
- **Choice:** `go_router`.
- **Structure:**
  - The five main sections (**Home**, **Track**, **Clarity**, **Toolkit**, **Profile**) will use a persistent navigation shell (`StatefulShellRoute.indexedStack`) so tab state is preserved.
  - The five independent experiences (**Feelings**, **My State**, **My Body**, **What Shaped Today**, **My Thoughts**) will be registered as independent push routes accessible from any relevant section without forcing a sequence.

---

## 5. Persistence & Security Strategy *(Pre-Implementation Baseline)*
- **Milestone 0 Status:** No database or speculative data models are implemented yet.
- **Confirmed Data Model Principle:**
  - One daily record per calendar day.
  - Subsequent saves on the same day update relevant fields without deleting unrelated information.
  - Creation and update timestamps are retained on the daily record; per-field timestamps are never fabricated.
  - Missing values remain missing; multiple emotions are preserved.
- **Planned Persistence Approach:** SQLite for structured daily records and `shared_preferences` for non-sensitive UI settings (evaluated and finalized before Milestone 4).
- **Mandatory Pre-Persistence Security Evaluation:** Before storing sensitive personal health data, we must formally evaluate and decide on:
  - OS-level application sandboxing.
  - Database encryption options (e.g., `sqflite_sqlcipher` vs. OS storage).
  - Optional biometric/PIN application lock *(noting that an app lock does not by itself encrypt the database)*.
  - Encryption-key storage and recovery implications.
  - Android/iOS compatibility and future schema/encryption migration implications.

---

## 6. Testing Approach
Testing begins in Milestone 0 and expands with each milestone:
- **Unit tests:** Domain models, deterministic `Clarity` logic, and data-integrity rules.
- **Repository & persistence tests:** Real SQLite behavior (using `sqflite_common_ffi` on Windows so tests run fast without an emulator).
- **Widget & navigation tests:** Verify real UI behavior, route transitions, and accessibility semantics—not just widget existence.
- **Static analysis:** `flutter analyze` with `flutter_lints` must pass with zero issues after every milestone.

---

## 7. Platform Limitations
- **Development environment:** Windows PC. Android builds and emulator/device testing run directly here.
- **iOS support:** iOS project files (`ios/`) are maintained in the repository, but actual iOS compilation, signing, and device verification require **macOS and Xcode**.
