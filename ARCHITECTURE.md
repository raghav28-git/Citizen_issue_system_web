# CityCare - System Architecture

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        Flutter Web App                       │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Screens    │  │   Widgets    │  │   Providers  │      │
│  │              │  │              │  │              │      │
│  │ - Landing    │  │ - Sidebar    │  │ - Auth       │      │
│  │ - Login      │  │ - StatusBadge│  │              │      │
│  │ - Dashboards │  │              │  │              │      │
│  │ - Reports    │  │              │  │              │      │
│  └──────┬───────┘  └──────────────┘  └──────┬───────┘      │
│         │                                     │              │
│         └─────────────────┬───────────────────┘              │
│                           │                                  │
│                  ┌────────▼────────┐                         │
│                  │    Services     │                         │
│                  │                 │                         │
│                  │ - AuthService   │                         │
│                  │ - Firestore     │                         │
│                  │ - Storage       │                         │
│                  └────────┬────────┘                         │
│                           │                                  │
└───────────────────────────┼──────────────────────────────────┘
                            │
                            │ Firebase SDK
                            │
┌───────────────────────────▼──────────────────────────────────┐
│                      Firebase Backend                         │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │     Auth     │  │  Firestore   │  │   Storage    │      │
│  │              │  │              │  │              │      │
│  │ - Email/Pass │  │ - users      │  │ - Images     │      │
│  │ - Sessions   │  │ - issues     │  │              │      │
│  │              │  │ - updates    │  │              │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│                                                               │
└───────────────────────────────────────────────────────────────┘
```

## 📊 Data Flow

### Citizen Reports Issue
```
User Input → ReportIssueScreen → FirestoreService → Firestore
                                → StorageService → Storage (image)
                                → Generate Ticket ID
                                → Create Issue Document
                                → Real-time Update
```

### Admin Updates Status
```
Admin Action → AdminIssueDetailScreen → FirestoreService
                                      → Update Issue Status
                                      → Create IssueUpdate Document
                                      → Real-time Broadcast
                                      → Citizen Sees Update
```

## 🔐 Security Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Security Layers                       │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Layer 1: Authentication                                 │
│  ├─ Firebase Auth validates user                        │
│  └─ JWT tokens for session management                   │
│                                                          │
│  Layer 2: Authorization                                  │
│  ├─ Role-based access (citizen/admin)                   │
│  └─ Route guards in Flutter                             │
│                                                          │
│  Layer 3: Firestore Rules                               │
│  ├─ Citizens: Read/write own issues                     │
│  ├─ Admins: Read/write all issues                       │
│  └─ Validated at database level                         │
│                                                          │
│  Layer 4: Storage Rules                                  │
│  ├─ Authenticated users: Upload images                  │
│  ├─ Max 5MB file size                                   │
│  └─ Image types only                                    │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

## 🗂️ Database Schema

### users Collection
```
users/{userId}
├─ uid: string
├─ name: string
├─ email: string
├─ role: string (citizen | admin)
└─ createdAt: timestamp
```

### issues Collection
```
issues/{issueId}
├─ id: string
├─ ticketId: string (TKT1234567890)
├─ title: string
├─ description: string
├─ category: string (Road | Garbage | Water | Electricity | Drainage | Other)
├─ imageUrl: string (optional)
├─ location: GeoPoint (optional)
├─ status: string (Reported | In Progress | Resolved | Rejected)
├─ reportedBy: string (userId)
├─ assignedTo: string (userId, optional)
├─ createdAt: timestamp
└─ updatedAt: timestamp
```

### issue_updates Collection
```
issue_updates/{updateId}
├─ id: string
├─ issueId: string
├─ message: string
├─ updatedBy: string (userId)
├─ timestamp: timestamp
└─ type: string (status_change | comment | assignment)
```

## 🔄 State Management

```
┌─────────────────────────────────────────────────────────┐
│                   Provider Pattern                       │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  AuthProvider (ChangeNotifier)                          │
│  ├─ currentUser: UserModel?                             │
│  ├─ isLoading: bool                                     │
│  ├─ isAuthenticated: bool                               │
│  ├─ signIn()                                            │
│  ├─ signUp()                                            │
│  └─ signOut()                                           │
│                                                          │
│  Consumers:                                              │
│  ├─ main.dart (routing)                                 │
│  ├─ All screens (user data)                             │
│  └─ Sidebar (role-based menu)                           │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

## 🎨 UI Component Hierarchy

```
MaterialApp
└─ Consumer<AuthProvider>
   ├─ SplashScreen (loading)
   ├─ LandingPage (not authenticated)
   └─ Dashboard (authenticated)
      ├─ CitizenDashboard (role: citizen)
      │  ├─ AppBar
      │  ├─ Sidebar
      │  └─ Body
      │     ├─ Report Issue Card
      │     └─ My Issues Card
      │
      └─ AdminDashboard (role: admin)
         ├─ AppBar
         ├─ Sidebar
         └─ Body
            ├─ Statistics Cards
            ├─ Filters
            └─ Issues DataTable
```

## 🚀 Deployment Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   Development                            │
│  flutter run -d chrome                                   │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                   Build                                  │
│  flutter build web --release                             │
│  Output: build/web/                                      │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                   Deploy                                 │
│  firebase deploy --only hosting                          │
│  URL: https://citizen-issue-system-web.web.app          │
└─────────────────────────────────────────────────────────┘
```

## 📱 Responsive Design

```
┌─────────────────────────────────────────────────────────┐
│                  Breakpoints                             │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Mobile (< 600px)                                        │
│  ├─ Drawer navigation                                   │
│  ├─ Stacked cards                                       │
│  └─ Single column layout                                │
│                                                          │
│  Tablet (600px - 1024px)                                │
│  ├─ Drawer navigation                                   │
│  ├─ 2-column grid                                       │
│  └─ Responsive tables                                   │
│                                                          │
│  Desktop (> 1024px)                                     │
│  ├─ Persistent sidebar                                  │
│  ├─ Multi-column layout                                 │
│  └─ Full data tables                                    │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

## 🔧 Service Layer

```
AuthService
├─ signIn(email, password) → UserModel
├─ signUp(name, email, password) → UserModel
├─ getUserData(uid) → UserModel
├─ signOut() → void
└─ currentUser → User?

FirestoreService
├─ addIssue(issue) → void
├─ getIssuesByUser(uid) → Stream<List<Issue>>
├─ getAllIssues() → Stream<List<Issue>>
├─ getIssuesByStatus(status) → Stream<List<Issue>>
├─ getIssuesByCategory(category) → Stream<List<Issue>>
├─ updateIssueStatus(id, status, updatedBy, message) → void
├─ assignIssue(id, assignedTo, updatedBy) → void
├─ addComment(issueId, comment, updatedBy) → void
├─ getIssueUpdates(issueId) → Stream<List<IssueUpdate>>
├─ getIssueCounts() → Map<String, int>
├─ generateTicketId() → String
└─ generateId() → String

StorageService
└─ uploadImage(imageData, fileName) → String?
```

## 🎯 Key Design Patterns

1. **Repository Pattern**: Services abstract Firebase operations
2. **Provider Pattern**: State management with ChangeNotifier
3. **Factory Pattern**: Model.fromMap() constructors
4. **Singleton Pattern**: Service instances
5. **Observer Pattern**: StreamBuilder for real-time updates

## 🔄 Real-time Updates Flow

```
Firestore Change
    ↓
StreamBuilder listens
    ↓
Widget rebuilds
    ↓
UI updates automatically
```

## 📊 Performance Optimizations

- Firestore indexes for queries
- Image compression before upload
- Lazy loading with StreamBuilder
- Efficient widget rebuilds with Provider
- Cached network images
- Pagination-ready queries

---

**Architecture designed for scalability, security, and maintainability**
