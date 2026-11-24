# Mindora — Architectural & Product Decisions Log

## 1. Confirmed Decisions

| Date | Decision | Rationale |
| :--- | :--- | :--- |
| 2026-11-24 | **Target platforms: Android & iOS** (developed on Windows) | Matches mobile product vision; keeps scope focused. iOS compilation/signing requires macOS/Xcode later. |
| 2026-11-24 | **Application identifier: `com.mindora.app`** | Clean reverse-domain identifier established at initialization. |
| 2026-11-24 | **Local Git repository (manual commits)** | Enables safe milestone tracking without automatic staging or committing. |
| 2026-11-24 | **Riverpod (`flutter_riverpod`) without codegen** | Clean state & DI for testing without `build_runner` complexity for a beginner maintainer. |
| 2026-11-24 | **GoRouter (`go_router`)** | Supports 5 persistent main tabs plus independent routes for the 5 experiences. |
| 2026-11-24 | **Feature-first architecture (Presentation / Domain / Data)** | Keeps features isolated, readable, and easy to grow milestone by milestone. |
| 2026-11-24 | **Lora + Inter locally bundled fonts** *(pending license check)* | Delivers editorial serif + readable sans-serif offline without runtime font downloads. |
| 2026-11-24 | **Approved 5-color palette** | `#F7EFE3`, `#D8D9BF`, `#A8B18A`, `#35452B`, `#EAE1D0` define Mindora's calm, organic identity. |
| 2026-11-24 | **One daily record per calendar day** | Subsequent saves update relevant fields without overwriting unrelated data; retains created/updated timestamps; preserves multiple emotions; never fabricates field timestamps or missing values. |
| 2026-11-24 | **First end-to-end experience: Feelings** | Selected for Milestone 4 to validate the full vertical slice before building the remaining four experiences. |
| 2026-11-24 | **Standard SQLite (`sqflite`) + Option B (`DailyRecord` + child `FeelingsEntry`)** | Preserves one `DailyRecord` per local calendar date while supporting multiple timestamped `FeelingsEntry` records with optional tone, unsure state, custom emotions, and non-destructive edits. |
| 2026-11-24 | **Android backup restriction (`allowBackup="false"` + `backup_rules.xml` + `data_extraction_rules.xml`)** | Excludes unencrypted SQLite and preferences from Android cloud backup and device transfer; iOS backup exclusion (`NSURLIsExcludedFromBackupKey`) documented for macOS/Xcode verification. |
| 2026-11-24 | **Zero paid APIs, ads, telemetry, or AI dependency** | Protects privacy, offline usability, and zero-cost sustainability. |

---

## 2. Technical Recommendations *(Pending Future Milestone Execution)*
- **SQLite (`sqflite`) + `sqflite_common_ffi` for Windows testing** and `shared_preferences` for non-sensitive UI flags (to be finalized in Milestone 4 after the security evaluation).
- **Deterministic local calculations for Clarity** before any optional AI layer.

---

## 3. Unresolved Decisions *(Must Be Decided Before Relevant Milestones)*
1. **Mandatory Security & Privacy Evaluation (Before Milestone 4):**
   - Evaluate OS-level sandboxing, database encryption (e.g., `sqflite_sqlcipher`), optional biometric/PIN app lock (distinct from DB encryption), key storage/recovery, Android/iOS compatibility, and migration impact before persisting sensitive health data.
2. **Font License Verification (Before Milestone 1):**
   - Verify SIL Open Font License files for Lora and Inter before bundling into `assets/fonts/`.
3. **Optional Future Decisions (Milestones 6–9):**
   - Localization scope (e.g., English-first vs. multilingual).
   - Local-only / free AI approach (if/when added in Milestone 9).
   - Cloud sync provider, conflict resolution, and free-tier limits (Milestone 9).

---

## 4. Explicitly Rejected Directions
Never reintroduce without explicit user authorization:
- Forensic, investigation, or surveillance framing.
- Constellation visual concept.
- Generic mood-tracker or clinical dashboard identity.
- Form-heavy daily questionnaires, compulsory 5-part check-ins, streaks, or guilt-based completion indicators.
- Public social feeds, follower counts, popularity metrics, or competition.
- Paid AI services as required dependencies, AI diagnosis, or AI medication recommendations.
- Random changes to the approved five-color palette.
