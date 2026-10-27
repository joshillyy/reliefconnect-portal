# ReliefConnect – Disaster Relief Volunteer Portal

A Flutter-based disaster relief coordination platform designed to connect volunteers, affected individuals, and relief coordinators through a centralized portal for managing emergency requests and volunteer activities.

<p align="center">
  <a href="https://reliefconnect-portal.web.app">
    <strong>🚀 Live Application</strong>
  </a>
  &nbsp; | &nbsp;
  <a href="https://github.com/joshillyy/reliefconnect-portal">
    <strong>💻 GitHub Repository</strong>
  </a>
</p>

---

## 📌 Project Overview

ReliefConnect is a cross-platform application developed to support disaster relief coordination during emergencies such as floods, cyclones, earthquakes, landslides, and fires.

During disasters, affected communities often struggle to communicate their needs, while volunteers and relief organizations face challenges coordinating people, tasks, and resources.

ReliefConnect addresses these challenges by providing a centralized platform where affected individuals can submit relief requests, volunteers can discover and join relief activities, and authorized coordinators can manage requests and volunteer operations.

The project is developed as an academic Flutter application with a focus on usability, structured workflows, and social impact.

## 🎯 Problem Statement

Disaster response can become inefficient when relief requests, volunteer availability, and task assignments are managed through disconnected communication channels.

ReliefConnect aims to improve coordination by organizing emergency assistance requests and volunteer activities in a single application.

## ✨ Key Features

### 👥 User Roles

- **Volunteers:** Explore relief tasks, register their skills, participate in activities, and track task status.
- **Relief Requesters:** Submit requests for assistance and monitor their request progress.
- **Administrators / Coordinators:** Review relief requests, manage volunteer applications, create relief tasks, and coordinate activities.

### 🆘 Relief Request Management

- Submit requests for food, drinking water, shelter, medical assistance, and other essential needs.
- Record the affected location, assistance category, urgency, and relevant details.
- View submitted requests and track their status.
- Support request review and status management through coordinator workflows.

### 🤝 Volunteer Coordination

- View available relief activities.
- Search and filter tasks by relevant categories and urgency.
- View task descriptions, required skills, location, and participation capacity.
- Join tasks and track participation status.
- Manage participation according to the task workflow.

### 🛡️ Coordinator Dashboard

- View relief operation statistics.
- Review and manage submitted requests.
- Approve or reject volunteer participation.
- Create, edit, and manage relief tasks.
- Track task progress and operational activity.

### 📊 Additional Features

- Role-specific dashboards and navigation.
- Form validation and user feedback.
- Emergency preparedness checklist.
- Activity feed and status indicators.
- Demo mode with sample disaster-relief data for project demonstrations.
- Firebase integration for authentication and cloud data storage when properly configured.

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application development |
| Dart | Application programming language |
| Material 3 | User interface and design system |
| Firebase Authentication | Email and password authentication |
| Cloud Firestore | Cloud database for application data |
| Provider | State management |
| `intl` | Date and time formatting |
| `uuid` | Unique request and task identifiers |
| Firebase Hosting | Deployment of the web application |
| Git and GitHub | Version control and source code submission |

## 🏗️ Project Architecture

The project uses a modular structure to separate the interface, business logic, data models, and backend operations.

```text
reliefconnect-portal/
├── android/
├── ios/
├── web/
├── windows/
├── linux/
├── macos/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── theme/
│   │   ├── utils/
│   │   └── widgets/
│   ├── models/
│   ├── services/
│   ├── repositories/
│   ├── providers/
│   ├── screens/
│   │   ├── auth/
│   │   ├── volunteer/
│   │   ├── requests/
│   │   ├── tasks/
│   │   ├── admin/
│   │   ├── profile/
│   │   ├── activity/
│   │   └── impact/
│   └── navigation/
├── docs/
├── test/
├── firebase.json
├── firestore.rules
├── firestore.indexes.json
├── pubspec.yaml
└── README.md
```

## 🚀 Live Demo

Try the deployed application:

**[Open ReliefConnect](https://reliefconnect-portal.web.app)**

The project also includes a demo mode intended to help evaluators explore the application's role-specific interfaces using sample data.

For demonstration, use the available demo-role options on the login screen if they are enabled in the deployed version.

Demo data should not be treated as real emergency reports or live relief operations.

## 💻 Run the Project Locally

### Prerequisites

Install the following tools:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart) — included with Flutter
- [Git](https://git-scm.com/downloads)
- [Google Chrome](https://www.google.com/chrome/) for running the web version
- [Firebase Console](https://console.firebase.google.com/) if you want to configure your own Firebase backend

### Step 1: Clone the repository

Open a terminal and run:

```bash
git clone https://github.com/joshillyy/reliefconnect-portal.git
cd reliefconnect-portal
```

### Step 2: Check the Flutter installation

```bash
flutter doctor
```

Resolve any required Flutter setup issues before proceeding.

### Step 3: Install dependencies

```bash
flutter pub get
```

### Step 4: Run automated tests

```bash
flutter test
```

### Step 5: Run the application

To launch the web version in Chrome:

```bash
flutter run -d chrome
```

To run on a connected Android device or emulator:

```bash
flutter devices
flutter run
```

To check the Dart code for potential issues:

```bash
flutter analyze
```

## 🔥 Firebase Configuration

ReliefConnect includes Firebase Authentication and Cloud Firestore integration. To use a separate Firebase project, configure the Firebase services before running the application in live mode.

### 1. Create a Firebase project

Visit the [Firebase Console](https://console.firebase.google.com/) and create a project.

### 2. Enable Authentication

In Firebase Console:

1. Open **Authentication**.
2. Select **Sign-in method**.
3. Enable **Email/Password** authentication.

### 3. Create Cloud Firestore

1. Open **Firestore Database**.
2. Create a database.
3. Review and deploy the project's Firestore security rules.

### 4. Configure FlutterFire

Install and configure the FlutterFire CLI using the [official Firebase Flutter setup guide](https://firebase.google.com/docs/flutter/setup).

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Follow the prompts to select your Firebase project and supported platforms.

### 5. Deploy Firestore rules and indexes

After verifying the configuration and rules for your Firebase project, install the Firebase CLI if needed, authenticate, and deploy:

```bash
firebase login
firebase deploy --only firestore:rules,firestore:indexes
```

Review the rules before deployment and ensure administrator privileges are provisioned securely.

### 6. Run the application

```bash
flutter pub get
flutter run -d chrome
```

**Note:** Demo mode and live Firebase mode are different. Successful local execution does not by itself confirm that authentication, Firestore access, and administrative permissions are correctly configured.

## 🌍 Sustainable Development Goals (SDGs)

ReliefConnect supports the objectives of the United Nations Sustainable Development Goals through its disaster-relief coordination concept.

### SDG 11 – Sustainable Cities and Communities

Supports community resilience by organizing relief requests and coordinating volunteers during disasters.

### SDG 13 – Climate Action

Promotes disaster preparedness and coordinated community responses to climate-related emergencies, including floods and cyclones.

### SDG 3 – Good Health and Well-being

Supports the coordination of medical assistance and other essential relief needs during emergencies.

The application demonstrates how digital tools can contribute to disaster preparedness and relief coordination. Its actual impact depends on adoption, reliable information, and collaboration with appropriate response organizations.

## 🧪 Testing and Verification

Run the following commands from the project root:

```bash
dart format .
flutter analyze
flutter test
```

Recommended manual verification:

- Registration, login, and logout.
- Input validation and error messages.
- Relief request submission and status tracking.
- Volunteer task browsing and participation.
- Coordinator request and task management.
- Role-based access restrictions.
- Demo mode and sample-data workflows.
- Firebase operations with the intended project configuration.
- Web application loading and navigation.

Review command output and test results before reporting the application as fully verified.

## 📚 Project Documentation

The repository contains a `docs/` directory intended for project documentation and academic submission materials.

Use the available documents to prepare:

- Project synopsis.
- Academic project report.
- System architecture and module descriptions.
- Demonstration checklist.
- Viva presentation and questions.
- Evaluation rubric mapping.

## 🎓 Academic Evaluation Mapping

| Evaluation Criterion | Marks | Project Contribution |
|---|---:|---|
| UI/UX Design | 5 | Material 3 interface, role-specific dashboards, reusable widgets, and navigation |
| Functionality and Features | 7 | Relief requests, volunteer tasks, participation workflows, and coordinator management |
| Flutter Coding and Implementation | 5 | Dart, Flutter widgets, Provider, modular architecture, and Firebase integration |
| SDG Relevance and Social Impact | 3 | SDG 11, SDG 13, SDG 3, and disaster preparedness |
| GitHub Submission and VEDIC Portal Link | 2 | Public source repository, README, setup instructions, and project link |
| Project Documentation | 3 | Report, synopsis, testing documentation, and viva preparation |
| **Total** | **25** | **Complete project evaluation criteria** |

This table maps the project components to the evaluation rubric; the marks awarded depend on the implementation and faculty assessment.

## 🔮 Future Enhancements

Potential future improvements include:

- Multilingual support for regional communities.
- Verified integration with official emergency information sources.
- Location-aware relief coordination.
- Push notifications for request and task updates.
- Improved offline data handling and synchronization.
- Accessibility enhancements for users in emergency situations.
- Collaboration workflows for NGOs and authorized relief organizations.

## ⚠️ Disclaimer

ReliefConnect is an academic project intended to demonstrate disaster-relief coordination workflows. It is not an official emergency response service and does not replace local authorities, medical services, or emergency dispatch systems.

For immediate danger, contact the appropriate official emergency service.

## 👩‍💻 Repository

**GitHub:** [joshillyy/reliefconnect-portal](https://github.com/joshillyy/reliefconnect-portal)

**Live application:** [reliefconnect-portal.web.app](https://reliefconnect-portal.web.app)

---

*ReliefConnect — Connecting people, coordinating volunteers, and supporting communities during disasters.*
