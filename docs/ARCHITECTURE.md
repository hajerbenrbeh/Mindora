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
├── app/
│   ├── app.dart                  # MaterialApp.router & light/dark theme wiring
│   ├── router.dart               # GoRouter with StatefulShellRoute.indexedStack
│   └── shell/
│       └── mindora_shell_scaffold.dart # Persistent 5-tab scaffold & MindoraBottomNavBar
├── core/
│   ├── design_system.dart        # Design system barrel export
│   ├── theme/                    # MindoraPalette, MindoraColorTokens, Spacing, Typography, Theme
│   ├── widgets/                  # Reusable calm UI primitives
│   └── preview/                  # Milestone 1 design-system showcase
└── features/                     # Self-contained feature modules
    ├── home/presentation/
    │   ├── home_screen.dart      # Welcome, Living Tapestry, Dimensions, Portals, Recent Activity
    │   └── widgets/              # home_welcome_header, living_tapestry, dimensions_overview, exploration_portals, recent_activity_section
    ├── experiences/presentation/ # Temporary Milestone 3 placeholder routes for the 5 experiences
    ├── track/presentation/
    ├── clarity/presentation/
    ├── toolkit/presentation/
    └── profile/presentation/
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

## 4. Navigation Strategy (Implemented in Milestone 2)
- **Choice:** `go_router` using `StatefulShellRoute.indexedStack`.
- **Five Persistent Branches:**
  1. `Home` (`/home`)
  2. `Track` (`/track`, with nested `/track/detail` verifying independent stack preservation)
  3. `Clarity` (`/clarity`)
  4. `Toolkit` (`/toolkit`)
  5. `Profile` (`/profile`)
- **Behavior:**
  - Each branch owns an independent `GlobalKey<NavigatorState>` so pushing nested routes inside one tab preserves that stack when switching to other tabs and handles Back navigation cleanly.
  - Custom `MindoraBottomNavBar` uses `MindoraColorTokens` (`surface`, `divider`, `accentSoft`, `textPrimary`, `textMuted`), 48dp+ touch targets, semantic hints/selected states, and `FittedBox` label scaling to prevent overflow on small screens.
  - The five independent experiences (`/experiences/feelings`, `/experiences/my-state`, `/experiences/my-body`, `/experiences/what-shaped-today`, `/experiences/my-thoughts`) are registered on the root navigator so users can enter any experience independently from Home without altering tab stacks. (Full recording workflows will be built in Milestones 4–5.)

---

## 5. Persistence & Security Strategy *(Pre-Implementation Baseline)*
- **Milestone 2 Status:** No database or speculative data models are implemented yet.
- **Confirmed Data Model Principle:**
  - One daily record per calendar day.
  - Subsequent saves on the same day update relevant fields without deleting unrelated information.
  - Creation and update timestamps are retained on the daily record; per-field timestamps are never fabricated.
  - Missing values remain missing; multiple emotions are preserved.
- **Mandatory Pre-Persistence Security Evaluation:** Before storing sensitive personal health data (Milestone 4), we must formally evaluate OS-level sandboxing, database encryption options, optional biometric/PIN app lock (distinct from DB encryption), key storage/recovery, Android/iOS compatibility, and migration implications.

---

## 6. Testing Approach
- **Unit & Theme tests:** Palette tokens, spacing/touch-target constants, light/dark themes.
- **Widget & Navigation tests:** All 5 destinations render, tab switching preserves nested stacks, back navigation pops cleanly, semantic selection states, 48dp+ touch targets, light/dark switching, and zero overflow on small screens (`320x568`) at `1.6x`–`1.8x` text scale.
- **Static analysis:** `flutter analyze` with `flutter_lints` must pass with zero issues after every milestone.

---

## 7. Platform Limitations
- **Development environment:** Windows PC. Android builds and emulator/device testing run directly here.
- **iOS support:** iOS project files (`ios/`) are maintained in the repository, but actual iOS compilation, signing, and device verification require **macOS and Xcode**.
