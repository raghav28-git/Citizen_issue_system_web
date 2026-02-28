# Firebase Setup Guide

## Steps to Configure Firebase:

### 1. Create Firebase Project
- Go to https://console.firebase.google.com/
- Click "Add project"
- Enter project name (e.g., "citizen-issue-system")
- Follow the setup wizard

### 2. Enable Authentication
- In Firebase Console, go to "Authentication"
- Click "Get Started"
- Enable "Email/Password" sign-in method

### 3. Create Firestore Database
- Go to "Firestore Database"
- Click "Create database"
- Start in "Test mode" (for development)
- Choose a location

### 4. Register Web App
- In Project Overview, click the web icon (</>)
- Register app with a nickname
- Copy the Firebase configuration

### 5. Update main.dart
Replace the Firebase configuration in `lib/main.dart`:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'YOUR_API_KEY',           // From Firebase config
    appId: 'YOUR_APP_ID',             // From Firebase config
    messagingSenderId: 'YOUR_SENDER_ID', // From Firebase config
    projectId: 'YOUR_PROJECT_ID',     // From Firebase config
    storageBucket: 'YOUR_BUCKET',     // From Firebase config
  ),
);
```

### 6. Install Dependencies
Run in terminal:
```bash
flutter pub get
```

### 7. Run the App
```bash
flutter run -d chrome
```

## Features Implemented:
- ✅ User Authentication (Login/Signup)
- ✅ Report Issues (Title, Location, Description)
- ✅ View All Issues
- ✅ Update Issue Status (Pending → In Progress → Resolved)
- ✅ Real-time Updates with Firestore

## Default Issue Statuses:
- Pending (newly created)
- In Progress (being worked on)
- Resolved (completed)
