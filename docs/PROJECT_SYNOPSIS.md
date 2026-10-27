# PROJECT SYNOPSIS: RELIEFCONNECT

**Project Title:** ReliefConnect – Disaster Relief Volunteer Portal  
**Domain:** Mobile Application Development / Humanitarian Informatics  
**Technology Stack:** Flutter (Dart), Material 3, Provider, Firebase Authentication, Cloud Firestore  
**Evaluation Scope:** College B.Tech / Degree Subject Project (25 Marks)  

---

### 1. Introduction
During sudden-onset natural catastrophes (floods, cyclones, landslides, earthquakes), public rescue efforts are hindered by unorganized volunteer deployment, lack of skill matching, and absence of real-time need tracking. ReliefConnect is a cross-platform mobile solution that bridges affected citizens, community volunteers, and emergency coordinators within a unified, transparent portal.

### 2. Problem Statement
Current disaster coordination suffers from:
- Chaotic volunteer crowding in accessible hubs while isolated settlements starve.
- Volunteer skill mismatch (untrained individuals sent for water rescue or medical first aid).
- Lack of status tracking for affected individuals seeking food, drinking water, or shelter.
- Reliance on fragmented, unverified social media petitions.

### 3. Objectives
- Develop a responsive, mobile-first Flutter application adhering to Material 3 design standards.
- Implement Role-Based Access Control (RBAC) across Volunteers, Requesters, and Administrators.
- Provide a structured disaster request system capturing location, needed aid, headcount, and urgency level.
- Implement skill-based volunteer task assignment and real-time quota tracking.
- Provide an Administrator Command Center to triage petitions and approve volunteers.
- Ensure 100% demonstration reliability via an offline-resilient Demo Mode alongside Cloud Firestore integration.
- Align platform features with UN Sustainable Development Goals (SDG 11, SDG 13, and SDG 3).

### 4. Technical Architecture
- **Presentation Layer:** Flutter Material 3 widgets with custom cards, badges, and responsive navigation.
- **State Management:** Provider pattern with ChangeNotifier for reactive data flow.
- **Data Layer:** Cloud Firestore NoSQL collections (`users`, `relief_requests`, `relief_tasks`, `task_participants`, `activity_logs`) with fallback to an in-memory Mock Data Engine for offline viva presentation.
- **Security:** Granular Firestore Security Rules with client-side role immutability and Coordinator Bootstrap Key verification (`RELIEF2026`).

### 5. Expected Outcomes
A fully functional, demonstrable Flutter application with 21 operational screens, 100% automated test pass rate, and verifiable social impact.
