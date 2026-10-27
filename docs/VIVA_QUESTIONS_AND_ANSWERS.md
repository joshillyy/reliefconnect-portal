# VIVA QUESTIONS AND ANSWERS (15+ QUESTIONS)

This document prepares you for technical and design questions frequently asked by university examination panels during mobile application and Flutter project defenses.

---

### Q1: What is the primary purpose and problem solved by ReliefConnect?
**Answer:**  
ReliefConnect is a humanitarian mobile application designed to eliminate logistical chaos during environmental emergencies like floods, cyclones, and earthquakes. Traditional response models suffer from unorganized volunteer crowding and severe information asymmetry. ReliefConnect provides centralized request triage, skill-based volunteer matchmaking, and real-time operational oversight for emergency coordinators.

---

### Q2: Why did you choose Flutter instead of native Android (Java/Kotlin) or React Native?
**Answer:**  
1. **Single Codebase, Native Performance:** Flutter compiles directly to ARM/x86 native machine code using Dart's Ahead-Of-Time (AOT) compiler, delivering consistent 60fps performance across Android, iOS, Windows, and Web.
2. **Material 3 Ecosystem:** Flutter provides first-class support for Material 3 design tokens, allowing us to build an accessible, high-contrast humanitarian interface quickly.
3. **Rich Reactive UI:** Flutter's declarative widget tree pairs naturally with reactive state management libraries like Provider, making it ideal for live disaster dashboards.

---

### Q3: Which state management approach did you use, and why?
**Answer:**  
We implemented the **Provider pattern** with `ChangeNotifier` (`AuthProvider`, `ReliefRequestProvider`, `ReliefTaskProvider`, `AppStateProvider`, `ActivityProvider`).  
**Reasons:**
- It is officially recommended by Google for small-to-medium production Flutter apps.
- It cleanly decouples business logic from UI widgets.
- It avoids unnecessary widget rebuilds through selective listeners (`Consumer` and `listen: false`).
- It is straightforward to test using automated widget tests without complex mocking frameworks.

---

### Q4: How does your application handle offline scenarios or missing Firebase credentials?
**Answer:**  
We engineered a **Dual-Mode Persistence Architecture**:
- When Firebase is initialized with valid credentials, the repository layer reads and writes to Cloud Firestore and Firebase Authentication.
- If Firebase initialization fails or credentials (`google-services.json`) are absent, the application gracefully activates an in-memory **Demo Data Engine** (`DemoDataService`) pre-seeded with realistic disaster relief data.
- The UI displays an explicit **Demo Mode Banner** so evaluators know the app is operating on local mock data rather than falsely claiming cloud persistence.

---

### Q5: How do you prevent ordinary users from granting themselves Administrator privileges?
**Answer:**  
Security is enforced at three levels:
1. **Client-side Registration Barrier:** Selecting the Administrator role reveals a required Coordinator Bootstrap Key field (`RELIEF2026`). Without this key, registration is blocked.
2. **Profile Immutability:** User roles cannot be edited from the profile screen.
3. **Cloud Firestore Security Rules:** The `firestore.rules` file enforces that users can only write to their own profile, and the `role` field cannot be modified once created. Only users whose token indicates admin role can update task statuses or approve volunteers.

---

### Q6: How does volunteer task capacity math work in ReliefConnect?
**Answer:**  
In `ReliefTaskModel`, we maintain two integer fields: `requiredVolunteers` and `currentVolunteers`.
- The getter `isFull` returns `currentVolunteers >= requiredVolunteers`.
- The getter `spotsRemaining` returns `(requiredVolunteers - currentVolunteers).clamp(0, requiredVolunteers)`.
- When a volunteer taps "Join Mission", the system checks if `isUserRegistered()` returns true. If not, it creates a `TaskParticipantModel` record and increments `currentVolunteers`. If the volunteer cancels, `currentVolunteers` is decremented.

---

### Q7: Explain the role and structure of your Firestore Security Rules.
**Answer:**  
In `firestore.rules`:
- Helper functions `isAuthenticated()`, `isOwner(userId)`, and `isAdmin()` define permission boundaries.
- The `users` collection allows reads for authenticated users but restricts writes to the owner.
- The `relief_requests` collection allows anyone authenticated to read and create petitions, but only the original requester can edit while status is 'Pending'. Only admins can update status and remarks.
- The `relief_tasks` collection permits `create`, `update`, and `delete` operations exclusively for verified administrators.

---

### Q8: How does ReliefConnect align with the United Nations Sustainable Development Goals (SDGs)?
**Answer:**  
ReliefConnect specifically aligns with three global goals:
1. **SDG 11 (Sustainable Cities & Communities) – Target 11.5:** Mitigating mortality and economic loss caused by floods and climate disasters.
2. **SDG 13 (Climate Action) – Target 13.1:** Strengthening community adaptation to severe weather hazards through volunteer preparedness.
3. **SDG 3 (Good Health & Well-being) – Target 3.d:** Timely coordination of first aid, clean drinking water, and sanitation supplies to avert post-flood epidemic outbreaks.

---

### Q9: Why is there an Emergency Alert Card directing users to dial 112 / 108?
**Answer:**  
From an ethical and software engineering standpoint, an auxiliary community volunteer portal must never position itself as an official emergency dispatch authority. During catastrophic emergencies (such as a collapsing roof or drowning), every second counts. The persistent alert card ensures citizens in immediate life danger contact national emergency services (112) or medical dispatch (108) directly.

---

### Q10: How do you format timestamps and dates cleanly across different locales?
**Answer:**  
We created a dedicated `DateFormatter` utility using the `intl` package:
- `formatDate(DateTime)` produces human-readable dates (e.g. "27 Oct 2026").
- `formatDateTime(DateTime)` includes time and AM/PM markers.
- `formatTimeAgo(DateTime)` calculates the difference between `DateTime.now()` and the event, rendering dynamic tags like "Just now", "14m ago", or "2h ago".

---

### Q11: What automated tests did you write, and what do they verify?
**Answer:**  
We wrote 12 automated unit and widget tests covering:
- **Validators:** Validates regex patterns for email, minimum password length (>= 6), 10-digit phone numbers, and positive integers.
- **Models:** Tests serialization to Map, deserialization from Firestore documents, and `copyWith` mutations.
- **Calculations:** Verifies volunteer quota calculations (`spotsRemaining`, `isFull`).
- **Widgets:** Verifies rendering of `StatusBadge`, `EmergencyAlertCard`, and tests the asynchronous splash-to-onboarding transition using `tester.pumpAndSettle()`.

---

### Q12: How do you handle asynchronous operations and prevent memory leaks in Flutter?
**Answer:**  
1. All database and auth operations use `async / await` wrapped in `try-catch` blocks.
2. In State classes, all `TextEditingController`, `TabController`, and `AnimationController` instances are strictly disposed inside `dispose()`.
3. In asynchronous callbacks, we guard UI updates using `if (!mounted) return;` to prevent calling `setState()` or accessing `BuildContext` after a widget is unmounted.

---

### Q13: What is the significance of the 1-Click Quick Demo Login on the login screen?
**Answer:**  
Faculty viva evaluations occur within strict time constraints (3 to 5 minutes). Creating new accounts and typing credentials repeatedly wastes critical evaluation time. The Quick Demo chips allow the examiner or student to log in as a Volunteer, Requester, or Coordinator with a single tap, immediately demonstrating role-specific features.

---

### Q14: What composite indexes did you configure in `firestore.indexes.json`?
**Answer:**  
Firestore queries that filter by an equality clause and order by another field require composite indexes. We defined indexes for:
1. `relief_requests`: `requesterId` ASCENDING + `createdAt` DESCENDING (for fetching a user's requests chronologically).
2. `relief_requests`: `status` ASCENDING + `createdAt` DESCENDING (for filtering requests by status in the admin dashboard).
3. `relief_tasks`: `status` ASCENDING + `date` ASCENDING (for listing upcoming tasks).
4. `task_participants`: `volunteerId` ASCENDING + `joinedAt` DESCENDING (for rendering volunteer history).

---

### Q15: What are the main limitations of the current implementation and how will you expand it?
**Answer:**  
**Current Limitations:**
- Location entry is currently text-based landmarks rather than live GPS map pins to keep the app buildable without requiring billing-enabled Google Maps API keys.
- Push notifications are delivered via the in-app activity feed rather than background FCM push.
**Future Enhancements:**
- Integrating OpenStreetMap / Google Maps SDK for route navigation to relief camps.
- Offline BLE (Bluetooth Low Energy) mesh networking for exchanging alerts when cell towers collapse.
- Adding multilingual translation (Hindi, Assamese, Bengali, Odia) for vernacular accessibility.
