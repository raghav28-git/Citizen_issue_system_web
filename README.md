# CityCare – Civic Issue Reporting System

🏙️ A production-ready Flutter Web application for reporting and managing civic issues.

## 🎯 Overview

CityCare is a comprehensive civic issue reporting platform that enables citizens to report city problems (potholes, garbage, water leakage, etc.) and allows administrators to manage and resolve these issues efficiently.

## ✨ Features

### 👥 Citizen Features
- Report issues with category, title, and description
- Upload images for evidence
- Add location coordinates
- Track issue status in real-time
- View personal issue history
- Status timeline for each issue

### 👨‍💼 Admin Features
- Dashboard with statistics (Total, Reported, In Progress, Resolved)
- View all issues in data table
- Filter by status and category
- Update issue status
- Add comments and notes
- Complete timeline view
- Assign to field officers (structure ready)

### 🔐 Security
- Role-based access control
- Firestore security rules
- Firebase Storage rules
- Image validation (5MB limit)
- Protected routes

## 🛠️ Tech Stack

- **Frontend**: Flutter Web (Responsive)
- **Authentication**: Firebase Authentication (Email/Password)
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage
- **State Management**: Provider
- **Hosting**: Firebase Hosting ready

## 📁 Project Structure

```
lib/
├── models/          # Data models (Issue, User, IssueUpdate)
├── services/        # Firebase services (Auth, Firestore, Storage)
├── providers/       # State management (AuthProvider)
├── screens/         # All UI screens
├── widgets/         # Reusable widgets
├── utils/           # Constants and helpers
└── main.dart        # App entry point
```

## 🚀 Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Firebase Setup
- Enable Authentication (Email/Password)
- Create Firestore Database
- Enable Firebase Storage
- Deploy security rules from `firestore.rules` and `storage.rules`

### 3. Run Application
```bash
flutter run -d chrome
```

### 4. Create Admin User
- Sign up as normal user
- Go to Firestore Console → users collection
- Change `role` field to `admin`

## 📊 Database Schema

### Collections

**users**
- uid, name, email, role, createdAt

**issues**
- id, ticketId, title, description, category, imageUrl, location, status, reportedBy, assignedTo, createdAt, updatedAt

**issue_updates**
- id, issueId, message, updatedBy, timestamp, type

## 🎨 UI/UX

- Clean, modern design
- White background with blue/teal accents
- Sidebar navigation for web
- Responsive layout
- Color-coded status badges:
  - 🟡 Reported (Yellow)
  - 🔵 In Progress (Blue)
  - 🟢 Resolved (Green)
  - 🔴 Rejected (Red)

## 📱 Application Flow

```
Splash Screen → Landing Page → Login/Signup → Role-based Dashboard
                                                ├─ Citizen Dashboard
                                                └─ Admin Dashboard
```

## 🔒 Security Rules

See `firestore.rules` and `storage.rules` for complete security implementation.

## 🚢 Deployment

### Build for Production
```bash
flutter build web --release
```

### Deploy to Firebase Hosting
```bash
firebase init hosting
firebase deploy --only hosting
```

## 📚 Documentation

- `QUICK_START.md` - Get started in 5 minutes
- `DEPLOYMENT_GUIDE.md` - Complete deployment instructions
- `firestore.rules` - Database security rules
- `storage.rules` - Storage security rules

## 🎯 Categories

- Road
- Garbage
- Water
- Electricity
- Drainage
- Other

## 📈 Status Flow

1. **Reported** - Initial status when issue is created
2. **In Progress** - Admin marks issue as being worked on
3. **Resolved** - Issue is fixed and closed
4. **Rejected** - Issue is rejected by admin

## 🧪 Testing

Create test accounts:
- Citizen: `citizen@test.com`
- Admin: `admin@test.com` (manually set role to 'admin')

## 🔮 Future Enhancements

- Field Officer role implementation
- Push notifications (FCM)
- Google Maps integration
- PDF export
- Analytics dashboard
- Email notifications
- Mobile app version

## 📄 License

This project is created for hackathon purposes.

## 🤝 Contributing

This is a hackathon project. Feel free to fork and enhance!

---

**Built with ❤️ using Flutter & Firebase**
