# Mindora — Design System

## 1. Approved Color Palette
Use these exact five colors as the foundation of Mindora's visual identity:

| Name | Hex | Intended Role |
| :--- | :--- | :--- |
| **Warm ivory** | `#F7EFE3` | Primary calm background canvas |
| **Natural beige** | `#EAE1D0` | Secondary surface, subtle cards, layered containers |
| **Soft sage** | `#D8D9BF` | Gentle accents, soft highlights, subtle dividers/surfaces |
| **Muted botanical green** | `#A8B18A` | Supporting botanical accents, calm interactive states |
| **Deep forest green** | `#35452B` | Primary typography, high-contrast ink, primary actions |

**Rules:**
- Do not replace this palette with unrelated greens.
- Do not introduce bright purple, blue, neon colors, or saturated gradients.
- Any additional neutral colors (e.g., muted warm gray for secondary text or gentle error/warning states that avoid harsh red) must complement this palette and be documented here before use.

---

## 2. Typography Direction
- **Headings:** Editorial serif — **Lora** (planned, subject to SIL Open Font License verification before bundling).
- **Body & UI:** Clean, highly readable sans-serif — **Inter** (planned, subject to SIL Open Font License verification before bundling).
- **Bundling Rule:** Font files must be **bundled locally** in the app assets. Never rely on runtime font downloads (protects offline-first behavior and privacy).
- **Hierarchy & Rhythm:** Comfortable reading sizes, generous line height, and clear distinction between editorial headings and calm body copy.

---

## 3. Visual Character
Mindora must feel:
- Sophisticated, comforting, friendly, organic, and editorial.
- Elegant without looking luxurious.
- Modern without looking generic.
- Warm without looking childish.
- Minimal without looking empty.
- Visually interesting without being overwhelming.

---

## 4. Component & Layout Principles
- **Spacing:** Generous breathing room and whitespace (especially in *My Thoughts*).
- **Surfaces:** Carefully layered warm surfaces (`#F7EFE3` → `#EAE1D0` → `#D8D9BF`), subtle borders, controlled rounded corners, and restrained shadows.
- **Layout variety:** Avoid making every screen look like a uniform grid of identical cards.
- **Empty states:** Welcoming, calm, and non-judgmental—never implying the user has failed or fallen behind.
- **Micro-interactions:** Thoughtful, gentle transitions that never feel gamified.

---

## 5. Accessibility Requirements
Accessibility is built in from Milestone 1, not added at the end:
- Verify WCAG AA contrast ratios for `#35452B` text on `#F7EFE3`, `#EAE1D0`, `#D8D9BF`, and `#A8B18A` surfaces.
- Support system font scaling (`MediaQuery.textScaler`) without clipping or overflow.
- Provide minimum `48x48` dp touch targets for interactive controls.
- Include clear semantic labels for screen readers (TalkBack / VoiceOver).

---

## 6. Explicitly Rejected Visual Concepts
Never introduce:
- Constellation imagery or metaphors.
- Investigation, surveillance, forensic, or detective imagery.
- Clinical/hospital-style forms, harsh red completion badges, or streak counters.
- Generic Material 3 default purple/blue themes.
