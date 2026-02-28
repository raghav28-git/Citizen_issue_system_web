# CityCare - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Install Dependencies
```bash
flutter pub get
```

### Step 2: Firebase Setup (Already Configured)
✅ Firebase credentials are already in `lib/main.dart`
✅ Just enable services in Firebase Console:
   - Authentication (Email/Password)
   - Firestore Database
   - Storage

### Step 3: Deploy Security Rules
Copy content from `firestore.rules` and `storage.rules` to Firebase Console

### Step 4: Run the App
```bash
flutter run -d chrome
```

## 📱 Application Flow

### For Citizens:
1. Visit landing page
2. Click "Login / Sign Up"
3. Create account (role = citizen by default)
4. Access dashboard
5. Report issues
6. Track status

### For Admins:
1. Sign up as normal user
2. Manually change role to 'admin' in Firestore
3. Access admin dashboard
4. View all issues
5. Update status
6. Add comments

## 🎯 Key Features

### Citizen Dashboard
- Report new issues
- View my issues
- Track status updates

### Admin Dashboard
- Statistics overview
- All issues table
- Filter by status/category
- Update issue status
- Add comments

## 🔐 Security Rules Applied

### Firestore:
- Citizens: Read/write own issues
- Admins: Read/write all issues

### Storage:
- Authenticated users: Upload images (max 5MB)
- Everyone: Read images

## 📊 Issue Lifecycle

```
Reported → In Progress → Resolved
         ↘ Rejected
```

## 🎨 UI Components

- **Status Badges**: Color-coded (Yellow/Blue/Green/Red)
- **Sidebar Navigation**: Role-based menu
- **Responsive Design**: Works on desktop and mobile
- **Real-time Updates**: Live data from Firestore

## 🛠️ Tech Stack

- Flutter Web
- Firebase Auth
- Cloud Firestore
- Firebase Storage
- Provider (State Management)

## 📝 Test Credentials

Create these accounts for testing:
- Citizen: citizen@test.com
- Admin: admin@test.com (set role='admin' in Firestore)

## 🚢 Deploy to Production

```bash
flutter build web --release
firebase deploy --only hosting
```

## 📞 Support

Check `DEPLOYMENT_GUIDE.md` for detailed documentation.
