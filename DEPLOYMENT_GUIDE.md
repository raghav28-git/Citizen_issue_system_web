# CityCare - Production Deployment Guide

## Project Structure
```
lib/
├── models/
│   ├── issue.dart
│   ├── issue_update.dart
│   └── user_model.dart
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   └── storage_service.dart
├── providers/
│   └── auth_provider.dart
├── screens/
│   ├── splash_screen.dart
│   ├── landing_page.dart
│   ├── login_screen.dart
│   ├── citizen_dashboard.dart
│   ├── admin_dashboard.dart
│   ├── report_issue_screen.dart
│   ├── my_issues_screen.dart
│   ├── issue_detail_screen.dart
│   └── admin_issue_detail_screen.dart
├── widgets/
│   ├── sidebar.dart
│   └── status_badge.dart
├── utils/
│   └── constants.dart
└── main.dart
```

## Firebase Setup

### 1. Enable Authentication
- Go to Firebase Console → Authentication
- Enable Email/Password sign-in method

### 2. Create Firestore Database
- Go to Firestore Database
- Create database in production mode
- Deploy security rules from `firestore.rules`

### 3. Enable Firebase Storage
- Go to Storage
- Get started
- Deploy security rules from `storage.rules`

### 4. Deploy Security Rules
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize project
firebase init

# Deploy rules
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
```

## Create Admin User

After first user signup, manually update their role in Firestore:
1. Go to Firestore Console
2. Navigate to `users` collection
3. Find the user document
4. Change `role` field from `citizen` to `admin`

## Run Application

### Development
```bash
flutter pub get
flutter run -d chrome
```

### Production Build
```bash
flutter build web --release
```

### Deploy to Firebase Hosting
```bash
firebase init hosting
# Select build/web as public directory
firebase deploy --only hosting
```

## Features Implemented

### Citizen Features
- ✅ Landing page with hero section
- ✅ Email/Password authentication
- ✅ Report issues with category, title, description
- ✅ Upload images to Firebase Storage
- ✅ Add location (lat/lng)
- ✅ View own issues
- ✅ Track issue status
- ✅ View status timeline

### Admin Features
- ✅ Dashboard with statistics
- ✅ View all issues
- ✅ Filter by status/category
- ✅ Update issue status
- ✅ Add comments
- ✅ View complete timeline
- ✅ Assign to field officers (structure ready)

### Security
- ✅ Role-based access control
- ✅ Firestore security rules
- ✅ Storage security rules
- ✅ Image validation (5MB limit)
- ✅ Route protection

## Database Collections

### users
- uid (string)
- name (string)
- email (string)
- role (string: 'citizen' | 'admin')
- createdAt (timestamp)

### issues
- id (string)
- ticketId (string)
- title (string)
- description (string)
- category (string)
- imageUrl (string, optional)
- location (GeoPoint, optional)
- status (string)
- reportedBy (string - uid)
- assignedTo (string - uid, optional)
- createdAt (timestamp)
- updatedAt (timestamp)

### issue_updates
- id (string)
- issueId (string)
- message (string)
- updatedBy (string - uid)
- timestamp (timestamp)
- type (string: 'status_change' | 'comment' | 'assignment')

## Status Flow
1. Reported (default when created)
2. In Progress (admin updates)
3. Resolved (admin marks complete)
4. Rejected (admin rejects)

## Categories
- Road
- Garbage
- Water
- Electricity
- Drainage
- Other

## Environment Variables
All Firebase config is in `lib/main.dart`. For production, consider using:
- flutter_dotenv for environment variables
- Firebase Remote Config for dynamic configuration

## Testing
Create test accounts:
1. Citizen: citizen@test.com / password123
2. Admin: admin@test.com / password123 (manually set role to 'admin')

## Performance Optimization
- Images are compressed before upload
- Firestore queries use indexes
- Real-time listeners for live updates
- Pagination ready (can be added to queries)

## Future Enhancements
- Field Officer role implementation
- Push notifications (FCM)
- Google Maps integration
- Export reports to PDF
- Analytics dashboard
- Email notifications
