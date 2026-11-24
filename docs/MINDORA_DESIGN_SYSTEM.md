# Mindora — Design System

## 1. Approved Color Palette
Use these exact five colors as the foundation of Mindora's visual identity:

| Name | Hex | Intended Role |
| :--- | :--- | :--- |
| **Warm ivory** | `#F7EFE3` | Main light background canvas |
| **Natural beige** | `#EAE1D0` | Primary cards and subtle surface variation |
| **Soft sage** | `#D8D9BF` | Gentle secondary surfaces and selected accents |
| **Muted botanical green** | `#A8B18A` | Soft accents, dark-mode primary action |
| **Deep forest green** | `#35452B` | Primary typography, strong accents, light-mode primary actions |

### Documented Complementary Neutrals (Light Mode)
| Token | Hex | Purpose |
| :--- | :--- | :--- |
| `lightTextSecondary` | `#55634B` | Readable supporting copy on warm ivory/beige |
| `lightTextMuted` | `#6B7660` | Hints, placeholders, and small metadata |
| `lightBorder` | `#C9C4B4` | Subtle 1dp borders replacing heavy shadows |
| `lightDivider` | `#DDD5C4` | Soft hairline section dividers |
| `lightGentleWarning` | `#8C5A46` | Warm terracotta-earth for error states without harsh clinical red |

### Deliberate Dark Mode Palette
Dark mode uses deep organic mossy-charcoal tones rather than pure black (`#000000`) or inverted neon:

| Token | Hex | Purpose |
| :--- | :--- | :--- |
| `darkBackground` | `#1A2117` | Main dark background |
| `darkSurface` | `#232C1F` | Primary card and input surfaces |
| `darkSurfaceSecondary` | `#2C3627` | Secondary surface variation |
| `darkTextPrimary` | `#F2EAD9` | Softened warm ivory primary ink |
| `darkTextSecondary` | `#C5C9B6` | Soft sage-ivory supporting text |
| `darkTextMuted` | `#9EA592` | Hints and metadata |
| `darkBorder` | `#3B4734` | Subtle organic borders |
| `darkDivider` | `#313C2C` | Soft hairline dividers |
| `darkGentleWarning` | `#D69A82` | Soft warm terracotta for dark-mode error states |

---

## 2. Typography & Bundled Fonts
- **Headings:** `Lora` (`assets/fonts/lora/Lora-Variable.ttf`, `Lora-Italic-Variable.ttf`)
- **Body & UI:** `Inter` (`assets/fonts/inter/Inter-Variable.ttf`, `Inter-Italic-Variable.ttf`)
- **License Verification:** Both fonts are licensed under the **SIL Open Font License, Version 1.1**, with their `OFL.txt` license files bundled in `assets/fonts/lora/OFL.txt` and `assets/fonts/inter/OFL.txt`.
- **Offline Rule:** All font assets are bundled locally in `pubspec.yaml`; no runtime Google Fonts downloads are used.

### Typography Scale (`MindoraTypography`)
| Role | Material Style | Family | Size | Weight | Line Height |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Display heading | `displaySmall` | Lora | 32 | w500 | 1.25 |
| Screen heading | `headlineMedium` | Lora | 26 | w500 | 1.30 |
| Section heading | `titleLarge` | Lora | 20 | w600 | 1.35 |
| Card title | `titleMedium` | Lora | 17 | w600 | 1.35 |
| Body text | `bodyLarge` | Inter | 16 | w400 | 1.55 |
| Secondary text | `bodyMedium` | Inter | 14 | w400 | 1.50 |
| Label / chip | `labelMedium` | Inter | 13 | w500 | 1.40 |
| Button | `labelLarge` | Inter | 15 | w600 | 1.20 |
| Small metadata | `bodySmall` | Inter | 12 | w400 | 1.40 |

---

## 3. Spacing, Radii, Borders & Motion Tokens
- **Spacing (`MindoraSpacing`, 4dp base):** `xs = 4`, `sm = 8`, `md = 12`, `base = 16`, `lg = 24`, `xl = 32`, `xxl = 48`, `xxxl = 64`.
- **Corner Radii (`MindoraRadii`):** `sm = 8`, `md = 12` (controls/inputs/buttons), `lg = 16` (cards/surfaces), `pill = 999` (selection chips).
- **Borders & Elevation:** Prefer `1dp` (`MindoraBorders.thin`) and `1.5dp` (`MindoraBorders.medium`) warm borders with `0dp` elevation (`MindoraElevation.none`) over drop shadows.
- **Dimensions (`MindoraDimensions`):** `minTouchTarget = 48`, `buttonHeight = 48`, `inputMinHeight = 52`, `maxReadableWidth = 640`.
- **Motion (`MindoraMotion`):** `fast = 150ms`, `normal = 250ms`, `gentle = 400ms` with `Curves.easeOutCubic`.

---

## 4. Theme Architecture
- Implemented in `lib/core/theme/mindora_theme.dart` (`MindoraTheme.light()` and `MindoraTheme.dark()`).
- Semantic tokens are exposed via `MindoraColorTokens` (`ThemeExtension`) and `context.mindoraColors`.
- System status bar and navigation bar styling are configured cleanly via `SystemUiOverlayStyle`.

---

## 5. Reusable Component Library (`lib/core/widgets/`)
Import via `package:mindora/core/design_system.dart`:
- **Buttons (`mindora_buttons.dart`):** `MindoraPrimaryButton`, `MindoraSecondaryButton`, `MindoraTextButton`.
- **Input (`mindora_text_field.dart`):** `MindoraTextField` (label, hint, optional helper text, multi-line support).
- **Surfaces & Structure (`mindora_surface.dart`):** `MindoraSurface` (primary/secondary tones, optional tap + ink feedback), `MindoraSectionHeading`, `MindoraDivider`.
- **Selection & States (`mindora_states.dart`):** `MindoraSelectableChip`, `MindoraIconBadge`, `MindoraLoadingIndicator`, `MindoraEmptyState`.

---

## 6. Accessibility Principles & Usage Conventions
- Minimum `48x48dp` interactive touch targets on buttons and selectable chips.
- Semantic headers (`Semantics(header: true)`), button/selected states (`Semantics(button: true, selected: ...)`), and live regions on loading states.
- Verified layout stability under large system text scaling (`1.8x`).
- **Usage convention:** Always read colors via `context.mindoraColors` and text styles via `Theme.of(context).textTheme` rather than hardcoding hex values or font sizes in feature screens.
