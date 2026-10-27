# FACULTY DEMONSTRATION CHECKLIST

Use this step-by-step checklist during your practical viva and project demonstration to systematically showcase every feature and maximize your marks (25/25).

---

### Step 1: Launch & Mode Verification
- [ ] Launch application using `flutter run -d chrome` or `flutter run -d windows` or `flutter run -d android`.
- [ ] Point out the **Splash Screen** branding animation and initialization message.
- [ ] Show the **Onboarding Carousel** (3 slides highlighting Rapid Response, Mobilization, and SDG Alignment).
- [ ] Highlight the persistent **Demo Mode Banner** at the top:
  - Explain: *"The portal includes a dual-engine architecture. It is currently operating in offline Demo Mode with pre-seeded disaster relief data, and is fully configured to connect to live Cloud Firestore."*

---

### Step 2: Role 1 – Volunteer Experience
- [ ] On the Login screen, click the **Volunteer** quick test chip (Logs in as Aarav Sharma).
- [ ] Show the **Volunteer Dashboard**:
  - Point out real-time metrics (Active Tasks, Pending Requests, Critical Alerts, Volunteers Needed).
  - Point out the **Immediate Danger Notice** with official 112/108 numbers.
- [ ] Navigate to **Browse Tasks**:
  - Show the live search bar (type "Silchar" or "Boat").
  - Open the **Filter Modal** and filter by Urgency: *Critical* or Disaster: *Flood*.
- [ ] Tap an available task to open **Task Details**:
  - Point out the volunteer capacity bar (e.g. 6/10 enrolled).
  - Point out preferred skills (Swimming, First Aid).
  - Click **Join This Relief Mission** and confirm the dialog.
  - Observe immediate success feedback and spot decrement.
- [ ] Navigate to **My Tasks**:
  - Show the tabbed filters (All, Pending, Approved, In Progress, Completed).
  - Demonstrate **Withdraw / Cancel Participation** with confirmation.
- [ ] Navigate to **Profile**:
  - Show user skills, base location, completed tasks badge, and participation history.
  - Open **Edit Profile** to demonstrate editing skills and explain role immutability.

---

### Step 3: Role 2 – Affected Requester Experience
- [ ] Open the Navigation Drawer and tap **Switch to Demo Requester** (or log in as `requester@reliefconnect.org`).
- [ ] Point out the customized bottom navigation tailored for affected citizens:
  - *New Request, My Requests, Relief Hub, Emergency, Profile*.
- [ ] Navigate to **New Request**:
  - Fill out a petition: Disaster Type = *Cyclone*, Assistance = *Drinking Water*, Exact Location = *Coastal Ward 2*, Affected Count = *25*, Urgency = *Critical*.
  - Tap **Submit Emergency Request**.
  - Show the confirmation dialog with auto-generated ID (e.g. `REQ-2026-XXXX`).
- [ ] Open **My Requests**:
  - Show the newly submitted request at the top.
  - Tap to view tracking status: *Pending (Under Review)*.

---

### Step 4: Role 3 – Administrator Command Center
- [ ] Open the Navigation Drawer and tap **Switch to Demo Admin** (or log in as `admin@reliefconnect.org`).
- [ ] Show the **Relief Command Center Dashboard**:
  - Operational metrics: Total Requests, Pending Review, Critical Emergencies, Active Operations.
  - Quick action controls.
- [ ] Navigate to **Manage Requests**:
  - Locate the newly submitted requester petition.
  - Click **Approve** or **Dispatch** to advance status immediately.
  - Open request details and enter **Coordinator Remarks** (e.g. *"Water tanker dispatched with team 3"*).
  - Save status and observe immediate update.
- [ ] Navigate to **Manage Volunteers**:
  - Review pending applications.
  - Click **Approve Volunteer** and observe status change to Approved.
- [ ] Navigate to **Manage Tasks**:
  - Show list of active relief operations.
  - Tap **Publish Task** / FAB:
    - Create a task (e.g. *"Water Purification Camp"*).
    - Save and observe it appearing immediately in the volunteer browse feed.
- [ ] Navigate to **Live Activity Feed**:
  - Show automated chronological audit trail of all actions just performed.

---

### Step 5: Social Impact & Security Defense
- [ ] Open **UN SDG Impact Screen**:
  - Explain specific connections to **SDG 11 (Target 11.5)**, **SDG 13 (Target 13.1)**, and **SDG 3 (Target 3.d)**.
  - Point out the academic project disclaimer.
- [ ] Open **Emergency Preparedness Screen**:
  - Show official helplines (112, 108, 1070, 1077, 101).
  - Interact with the **72-Hour Survival Go-Bag** checklist (check off items and show progress bar update).
- [ ] Explain **Role Security**:
  - Show `lib/screens/auth/register_screen.dart` requiring the Coordinator Bootstrap Key (`RELIEF2026`).
  - Show `firestore.rules` preventing unauthorized writes.

---

### Step 6: Code Quality & Automated Tests
- [ ] Open terminal in the project directory.
- [ ] Run `flutter test`.
- [ ] Show faculty that **all 12 unit and widget tests pass with 0 errors**.
- [ ] Run `flutter analyze` to prove zero compilation errors.
