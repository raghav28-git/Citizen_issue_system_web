# CityCare – Civic Issue Reporting System

🏙️ A production-ready Flutter Web application with premium UI for reporting and managing civic issues.

## 🎯 Overview

CityCare is a comprehensive civic issue reporting platform that enables citizens to report city problems (potholes, garbage, water leakage, etc.) and allows administrators to manage and resolve these issues efficiently with a modern, professional interface.

## ✨ Features

### 👥 Citizen Features
- Modern dashboard with greeting and statistics
- Report issues with category, title, and description
- Upload images for evidence (5MB limit)
- Add location coordinates (GeoPoint)
- Track issue status in real-time
- View personal issue history with search
- Interactive notifications panel
- Status timeline for each issue
- Professional profile management

### 👨‍💼 Admin Features
- Premium gradient dashboard with statistics
- Advanced issue management with filters
- Modern table view with color-coded categories
- Interactive status update interface
- Real-time comment system
- Visual timeline with icons
- Quick info sidebar
- Map view for issue locations
- Filter by status and category
- Assign to field officers (structure ready)

### 🔐 Security
- Role-based access control (Citizen/Admin)
- Firestore security rules
- Firebase Storage rules
- Image validation (5MB limit)
- Protected routes
- Secure logout functionality

## 🛠️ Tech Stack

- **Frontend**: Flutter Web (Responsive)
- **Authentication**: Firebase Authentication (Email/Password, Google Sign-In)
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage
- **State Management**: Provider
- **UI Framework**: Material Design 3
- **Fonts**: Google Fonts (Inter)
- **Hosting**: Firebase Hosting ready

## 📁 Project Structure

```
lib/
├── models/          # Data models (Issue, User, IssueUpdate)
├── services/        # Firebase services (Auth, Firestore, Storage)
├── providers/       # State management (AuthProvider)
├── screens/         # All UI screens
│   ├── common/      # Splash, Landing, Login
│   ├── user/        # Citizen Dashboard, Report Issue
│   └── admin/       # Admin Dashboard, Issue Management
├── widgets/         # Reusable widgets (StatusBadge)
├── utils/           # Constants and helpers
└── main.dart        # App entry point
```

## 🚀 Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Firebase Setup
- Enable Authentication (Email/Password, Google)
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
- id, ticketId, title, description, category, imageUrl, location (GeoPoint), status, reportedBy, assignedTo, createdAt, updatedAt

**issue_updates**
- id, issueId, message, updatedBy, timestamp, type

## 🎨 UI/UX Design

### Design System
- **Primary Colors**: Indigo (#4F46E5), Purple (#6366F1)
- **Status Colors**: 
  - Reported: Amber (#F59E0B)
  - In Progress: Purple (#8B5CF6)
  - Resolved: Green (#10B981)
  - Rejected: Red (#EF4444)
- **Typography**: Inter font family
- **Shadows**: Multi-layered for depth
- **Gradients**: Linear gradients throughout

### Premium Features
- Glassmorphism effects
- Gradient backgrounds
- Smooth animations
- Interactive hover states
- Color-coded categories with icons
- Modern card designs
- Professional data tables
- Visual timelines

## 📱 Application Flow

```
Splash Screen → Landing Page → Login/Signup → Role-based Dashboard
                     ↓                              ↓
              Clickable Logo                  ├─ Citizen Dashboard
                                              │   ├─ Report Issue
                                              │   ├─ My Issues
                                              │   ├─ Profile
                                              │   └─ Notifications
                                              └─ Admin Dashboard
                                                  ├─ All Issues (Premium Table)
                                                  ├─ Issue Management (Status Update)
                                                  ├─ Map View
                                                  └─ Analytics
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

## 🎯 Categories

- 🚧 Road (Red)
- 🗑️ Garbage (Green)
- 💧 Water (Blue)
- ⚡ Electricity (Amber)
- 🌊 Drainage (Purple)
- 📦 Other (Gray)

## 📈 Status Flow

1. **Reported** - Initial status when issue is created (Yellow badge)
2. **In Progress** - Admin marks issue as being worked on (Purple badge)
3. **Resolved** - Issue is fixed and closed (Green badge)
4. **Rejected** - Issue is rejected by admin (Red badge)

## 🧪 Testing

Create test accounts:
- Citizen: `citizen@test.com`
- Admin: `admin@test.com` (manually set role to 'admin')

## 🎨 Recent UI Updates

### Admin Portal
- ✅ Premium gradient header with issue count
- ✅ Modern filter panel with icons
- ✅ Enhanced table with category icons and colors
- ✅ Interactive status update buttons with gradients
- ✅ Two-column layout for issue details
- ✅ Visual timeline with connected dots
- ✅ Quick info sidebar

### Citizen Portal
- ✅ Fixed logout navigation
- ✅ Modern dashboard with statistics
- ✅ Search functionality
- ✅ Notifications panel

### Login Page
- ✅ Clickable logo to navigate to landing page
- ✅ Updated logo to match landing page style

## 🔮 Future Enhancements

- Field Officer role implementation
- Push notifications (FCM)
- Google Maps integration
- PDF export
- Advanced analytics dashboard
- Email notifications
- Mobile app version
- Dark mode
- Multi-language support

## 📄 License

This project is created for hackathon purposes.

## 🤝 Contributing

This is a hackathon project. Feel free to fork and enhance!

---

**Built with ❤️ using Flutter & Firebase**
**Designed with modern UI/UX principles**
