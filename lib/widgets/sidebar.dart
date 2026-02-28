import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppSidebar extends StatelessWidget {
  final String currentRoute;

  const AppSidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.currentUser?.role == 'admin';

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('CityCare', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(authProvider.currentUser?.name ?? '', style: const TextStyle(color: Colors.white70)),
                Text(authProvider.currentUser?.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: currentRoute == '/dashboard',
            onTap: () => Navigator.pushReplacementNamed(context, '/dashboard'),
          ),
          if (!isAdmin) ...[
            ListTile(
              leading: const Icon(Icons.add_circle),
              title: const Text('Report Issue'),
              selected: currentRoute == '/report',
              onTap: () => Navigator.pushReplacementNamed(context, '/report'),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('My Issues'),
              selected: currentRoute == '/my-issues',
              onTap: () => Navigator.pushReplacementNamed(context, '/my-issues'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              selected: currentRoute == '/notifications',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              selected: currentRoute == '/profile',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile coming soon!')),
                );
              },
            ),
          ],
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await authProvider.signOut();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
