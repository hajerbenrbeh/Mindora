# Mindora — Product Requirements

## 1. Product Identity
- **Name:** Mindora
- **Category:** Mental wellbeing, self-understanding, and personal health management.
- **Target Platforms:** Android and iOS.
- **Core Philosophy:** *Understanding yourself should feel natural, not like completing homework.*
- **What Mindora Is:** A personal, privacy-first, offline-first sanctuary to understand emotional and mental experiences, record physical wellbeing, recognize lifestyle relationships, explore personal patterns, organize health information, access supportive tools, and optionally prepare information for healthcare professionals.
- **What Mindora Is Not:** An ordinary mood tracker, medical dashboard, clinical questionnaire, productivity app, public social network, or generic chatbot.

---

## 2. Four Organizing Dimensions
Personal wellbeing is organized around four broad dimensions (lenses for organization, never four compulsory forms):
1. **Mental wellbeing:** Emotional experiences, mood, mental state, stress, focus/concentration, anxiety-related experiences, and user-selected mental health areas.
2. **Physical wellbeing:** Physical sensations, energy, sleep, physical tension, pain/discomfort, and optional body-related experiences.
3. **Lifestyle:** Daily influences, habits and routines, social connection, activity, nutrition/hydration, sleep-related routines, and other lifestyle factors.
4. **Personal understanding:** Thoughts, reflections, triggers and context, personal baseline, values and boundaries, life experiences, patterns, and self-discovery.

---

## 3. Five Main Navigation Sections
1. **Home:** Calm, personalized overview and gentle starting point (not for completing an entire daily record). Includes the non-numeric **Living Tapestry** concept, gentle access to the five independent experiences, recent activity, meaningful summaries, non-diagnostic pattern context, and optional invitations.
2. **Track:** Detailed recording, chronological history, daily records, filters by dimension and experience, editing existing entries, multi-emotion support, search, historical navigation, and meaningful connections between entries.
3. **Clarity:** Pattern discovery without clinical claims. Emotional and state patterns, mental–physical–lifestyle relationships, personal baselines, recurring triggers, comparison periods, and calm visualizations. Must distinguish observations from conclusions, never present correlation as causation, never diagnose, and work via **transparent deterministic local calculations** without external AI.
4. **Toolkit:** Useful, interactive wellbeing tools—grounding exercises, breathing exercises, reflection prompts, journaling exercises, emotional regulation tools, stress-management exercises, self-understanding activities, and personalized tools. No generic motivational quote cards.
5. **Profile:** User control over identity, selected wellbeing areas/conditions, personal baseline, medication and health information, goals/preferences, privacy and security settings, data export (PDF, CSV, JSON), backup/restore, optional professional access, social-circle management, and AI companion preferences/consent.

---

## 4. Five Independent Experiences
These are standalone destinations, never five compulsory steps in one daily form. Using one alone is never treated as incomplete.
1. **Feelings:** Expressive emotional recording supporting multiple emotions per entry, positive/negative/mixed/neutral experiences, user's own words, optional context, editing, retained timestamps, and skipping emotion selection when unsure. *(Selected as the first complete end-to-end experience for Milestone 4.)*
2. **My State:** Optional recording of perceived mental state (mood, energy, anxiety, stress, focus, mental clarity). Qualitative descriptions must never become invented numbers; missing dimensions remain missing.
3. **My Body:** Optional exploration of physical wellbeing (energy, sleep, tension, pain/discomfort, sensations). Descriptive input is supported without forcing numbers.
4. **What Shaped Today:** Optional context recording (stressors, triggers, social interactions, events, environment, routine changes, work/study, relationships, positive moments) without assuming causation.
5. **My Thoughts:** Dedicated full-screen writing sanctuary with comfortable typography, generous whitespace, minimal distractions, optional prompts, free writing, editing/continuing past entries, no minimum word count, no compulsory categories, and optional reliable voice notes in later phases.

---

## 5. Tracking & Data Integrity Rules
- **Flexible recording:** Optional morning, afternoon, and evening suggestions (never mandatory), unlimited quick saves, skippable categories, editable entries, retained timestamps, and zero punishment for missed days.
- **Daily-record model (Confirmed):**
  - One daily record per calendar day.
  - Users can save and update that record multiple times ("unlimited quick saves" = unlimited updates to the daily record, not a separate event-log architecture).
  - Subsequent saves update relevant information without deleting unrelated fields.
  - The record retains its creation and update timestamps.
  - Do not fabricate individual field timestamps.
  - Do not silently replace missing values with zeros or invent numerical intensities.
  - Preserve multiple emotions within an entry.

---

## 6. Non-Negotiable UX Rules & Explicit Exclusions
Never implement:
- Compulsory daily questionnaires or mandatory completion of all five experiences.
- Completion percentages, streaks, missed-day warnings, guilt-inducing reminders, or red completion indicators.
- Overwhelming dashboards or clinical-looking interfaces.
- Public social feeds, follower counts, popularity metrics, or competition.

---

## 7. Long-Term Capabilities *(Later Milestones)*
- **Personalized Mental Health Journeys:** Optional tailored tracking and educational tools for user-selected areas (e.g., bipolar-related experiences, anxiety, OCD, depression) without forcing diagnosis disclosure, clinical thresholds, or automated episode declarations.
- **Medication & Personal Health Management:** Medication logs (dosage, purpose, custom schedules, taken/skipped status, history, reminders) and optional health modules (sleep, hydration, nutrition, activity, cycle, pain). Strictly never recommend dose changes or starting/stopping medication.
- **Personal Organization & Self-Discovery:** Values/boundaries, life events, goals, planner/calendar/appointments, personal documents, health history, and clinician-friendly summaries.
- **Emergency & Safety Support:** User-configured emergency contacts, key health/medication info, instructions, and verified location-appropriate crisis resources (no monitoring or auto-dispatch claims).
- **Professional Access:** User-controlled sharing (what is shared, duration, revocation; never unrestricted full-account access).

---

## 8. AI Companion Requirements & Restrictions
- **Capabilities (Long-Term):** Conversational companion (custom user instructions, empathetic/psychologically informed style without pretending to be a licensed therapist) and intelligent pattern understanding (summarizing themes, appointment prep).
- **Mandatory Constraints:**
  - No paid APIs, subscriptions, or paid external AI dependencies.
  - The application must remain 100% useful without AI.
  - Explicit, informed user consent before AI accesses personal/journal data or sends data externally.
  - Strictly no AI diagnosis, no medication-change advice, and no crisis-detection/monitoring claims.

---

## 9. Privacy, Security & Social Requirements
- **Privacy & Ownership:** Local-first, offline-first core functionality; user-controlled export (PDF, CSV, JSON) with preview before sharing; user-controlled deletion; optional app-level lock/biometrics; no sale of health data; no ads or telemetry SDKs. Multi-device sync is deferred and must define conflict handling and real free-tier limits first.
- **Private Social Circles (Later Milestone):** Invite-only, maximum 8 members per circle, 1:1 text and voice messaging, explicit consent before sharing updates, journal access disabled by default, reporting/blocking. No public feeds or engagement-pressure mechanics.
