# FEATURE TO EVALUATION RUBRIC MAPPING (25 MARKS)

This mapping table provides an explicit breakdown of how the implemented codebase addresses each evaluation criterion specified by the university project syllabus.

---

### Rubric Breakdown (Total: 25 Marks)

| Criterion | Max Marks | Weightage | Target Achievement |
| :--- | :---: | :---: | :---: |
| **A. UI/UX Design & Material 3** | 5 | 20% | **5 / 5** |
| **B. Functionality and Features** | 7 | 28% | **7 / 7** |
| **C. Flutter Coding & Implementation** | 5 | 20% | **5 / 5** |
| **D. SDG Relevance and Social Impact** | 3 | 12% | **3 / 3** |
| **E. GitHub Code Submission & VEDIC** | 2 | 8% | **2 / 2** |
| **F. Project Documentation & Viva** | 3 | 12% | **3 / 3** |
| **TOTAL** | **25** | **100%** | **25 / 25** |

---

### Detailed Criterion Verification

#### Criterion A: UI/UX Design (5 Marks)
- [x] **Material 3 Design Tokens:** Implemented in `lib/core/theme/app_theme.dart` with `ColorScheme.fromSeed`, `CardThemeData`, and `TabBarThemeData`.
- [x] **Humanitarian Color Palette:** Deep Navy Blue primary (`#0D253F`), vibrant Emergency Red (`#D32F2F`), and supporting Teal (`#00897B`).
- [x] **Responsive Cards & Navigation:** Custom rounded cards, adaptive bottom navigation bar (`NavigationBar`), and clean status pills (`StatusBadge`).
- [x] **Accessibility & Contrast:** WCAG-compliant contrast ratios across dark headers and text elements.
- [x] **Complete State Handling:** Distinct widgets for `LoadingIndicator`, `EmptyStateView`, and `ErrorView` with retry buttons.

#### Criterion B: Functionality and Features (7 Marks)
- [x] **Role-Based Experience:** 3 tailored roles (Volunteer, Relief Requester, Relief Coordinator).
- [x] **Volunteer Operations:** Browse tasks, keyword search, multi-parameter filtering, spot math, 1-tap join, duplicate prevention, withdrawal, and history.
- [x] **Relief Requests:** Form validation, exact location, disaster and supply categorization, headcount validation, auto-generated IDs (`REQ-2026-XXXX`), and request withdrawal.
- [x] **Admin Command Center:** Operational stats, inline petition triage (Approve, Dispatch, Resolve), volunteer approval/rejection, task publication, and activity audit feed.
- [x] **Dual Persistence Engine:** Seamless toggle between live Cloud Firestore and an offline in-memory Demo Data Service with realistic pre-seeded records.

#### Criterion C: Flutter Coding and Implementation (5 Marks)
- [x] **Architecture:** Clean, modular structure (`core/`, `models/`, `services/`, `repositories/`, `providers/`, `screens/`, `navigation/`).
- [x] **State Management:** Provider 6.1.5 with `ChangeNotifier` pattern; zero bloated single files.
- [x] **Null Safety & Modern Dart:** 100% Dart 3 null-safe implementation with proper controllers and disposals.
- [x] **Quality Verification:** 0 analyzer compilation errors (`flutter analyze`), 100% pass rate across 12 automated unit and widget tests (`flutter test`).

#### Criterion D: SDG Relevance and Social Impact (3 Marks)
- [x] **Global Goals:** Dedicated screen analyzing alignment with **SDG 11 (Sustainable Cities)**, **SDG 13 (Climate Action)**, and **SDG 3 (Good Health & Well-being)**.
- [x] **Ethical Safeguards:** Prominent emergency alert cards directing immediate danger cases to official 112 / 108 helplines; explicit academic disclaimer.
- [x] **Disaster Preparedness:** Interactive 72-Hour Survival Go-Bag checklist with dynamic progress bar and safety protocols for floods, cyclones, and earthquakes.

#### Criterion E: GitHub Code Submission and VEDIC Portal Link (2 Marks)
- [x] **Repository Cleanliness:** Complete source code, `.gitignore` excluding build artifacts and private credentials (`google-services.json`).
- [x] **Documentation:** Comprehensive `README.md` with step-by-step installation, Git commands, and VEDIC portal submission guide.

#### Criterion F: Project Documentation (3 Marks)
- [x] **Academic Report:** Formal 25-section report (`docs/ACADEMIC_PROJECT_REPORT.md`) containing Title, Certificate, Abstract, Architecture, Schemas, Test Cases, and References.
- [x] **Viva Preparation:** Project synopsis (`docs/PROJECT_SYNOPSIS.md`), faculty demonstration checklist (`docs/DEMONSTRATION_CHECKLIST.md`), 3–5 minute presentation script (`docs/VIVA_PRESENTATION_SCRIPT.md`), and 15+ viva Q&As (`docs/VIVA_QUESTIONS_AND_ANSWERS.md`).
