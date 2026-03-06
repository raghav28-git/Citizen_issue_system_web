import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/common/splash_screen.dart';
import 'screens/common/landing_page.dart';
import 'screens/common/login_screen.dart';
import 'screens/user/citizen_dashboard.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/user/report_issue_screen.dart';
import 'screens/user/my_issues_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCoe-K-o-_Cd4cg7lyT5Az5x1dEvfE0O2E',
        authDomain: 'citizen-issue-system-web.firebaseapp.com',
        appId: '1:1033164091742:web:2d5e84d09f763cb3191fcf',
        messagingSenderId: '1033164091742',
        projectId: 'citizen-issue-system-web',
        storageBucket: 'citizen-issue-system-web.firebasestorage.app',
      ),
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'CityCare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
          fontFamily: 'Inter',
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isLoading) {
              return const SplashScreen();
            }
            if (!authProvider.isAuthenticated) {
              return const LandingPage();
            }
            final isAdmin = authProvider.currentUser?.role == 'admin';
            return isAdmin ? const AdminDashboard() : const CitizenDashboard();
          },
        ),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/dashboard': (_) => Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  final isAdmin = authProvider.currentUser?.role == 'admin';
                  return isAdmin ? const AdminDashboard() : const CitizenDashboard();
                },
              ),
          '/report': (_) => const ReportIssueScreen(),
          '/my-issues': (_) => const MyIssuesScreen(),
        },
      ),
    );
  }
}
