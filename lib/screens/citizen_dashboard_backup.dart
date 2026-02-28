import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';
import '../models/issue.dart';
import '../widgets/status_badge.dart';
import 'issue_detail_screen.dart';

class CitizenDashboard extends StatefulWidget {
  const CitizenDashboard({super.key});

  @override
  State<CitizenDashboard> createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard> {
  String _selectedMenu = 'Dashboard';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreService = FirestoreService();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Row(
        children: [
          _buildSidebar(authProvider),
          Expanded(
            child: Column(
              children: [
                _buildTopNavbar(authProvider),
                Expanded(
                  child: _buildContent(firestoreService, authProvider),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(FirestoreService firestoreService, AuthProvider authProvider) {
    switch (_selectedMenu) {
      case 'Dashboard':
        return _buildDashboardContent(firestoreService, authProvider);
      case 'All Reports':
        return _buildAllReportsContent(firestoreService, authProvider);
      case 'Map View':
        return _buildPlaceholder('Map View', Icons.map);
      case 'Categories':
        return _buildPlaceholder('Categories', Icons.category);
      case 'Analytics':
        return _buildPlaceholder('Analytics', Icons.bar_chart);
      case 'Profile':
        return _buildPlaceholder('Profile', Icons.person);
      case 'Settings':
        return _buildPlaceholder('Settings', Icons.settings);
      default:
        return _buildDashboardContent(firestoreService, authProvider);
    }
  }

  Widget _buildDashboardContent(FirestoreService firestoreService, AuthProvider authProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, ${authProvider.currentUser?.name}!',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A202C)),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now()),
            style: const TextStyle(fontSize: 14, color: Color(0xFF718096)),
          ),
          const SizedBox(height: 32),
          StreamBuilder<List<Issue>>(
            stream: firestoreService.getIssuesByUser(authProvider.currentUser!.uid),
            builder: (context, snapshot) {
              final issues = snapshot.data ?? [];
              final pending = issues.where((i) => i.status == 'Reported').length;
              final inProgress = issues.where((i) => i.status == 'In Progress').length;
              final resolved = issues.where((i) => i.status == 'Resolved').length;

              return Row(
                children: [
                  _buildStatCard('Total Reports', issues.length.toString(), Icons.description, const Color(0xFF3B82F6), '+12%'),
                  const SizedBox(width: 16),
                  _buildStatCard('Pending', pending.toString(), Icons.pending_actions, const Color(0xFFF59E0B), '+5%'),
                  const SizedBox(width: 16),
                  _buildStatCard('In Progress', inProgress.toString(), Icons.autorenew, const Color(0xFF8B5CF6), '+8%'),
                  const SizedBox(width: 16),
                  _buildStatCard('Resolved', resolved.toString(), Icons.check_circle, const Color(0xFF10B981), '+15%'),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Reports', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A202C))),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/report'),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildReportsTable(firestoreService, authProvider),
        ],
      ),
    );
  }

  Widget _buildAllReportsContent(FirestoreService firestoreService, AuthProvider authProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('All My Reports', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A202C))),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/report'),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildReportsTable(firestoreService, authProvider, showAll: true),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF718096))),
          const SizedBox(height: 8),
          const Text('Coming soon!', style: TextStyle(fontSize: 16, color: Color(0xFF718096))),
        ],
      ),
    );
  }

  Widget _buildSidebar(AuthProvider authProvider) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(2, 0))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.location_city, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Text('CityCare', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A202C))),
              ],
            ),
          ),
          _buildMenuItem(Icons.dashboard, 'Dashboard', '/dashboard'),
          _buildMenuItem(Icons.list_alt, 'All Reports', '/my-issues'),
          _buildMenuItem(Icons.map, 'Map View', '/map'),
          _buildMenuItem(Icons.category, 'Categories', '/categories'),
          _buildMenuItem(Icons.bar_chart, 'Analytics', '/analytics'),
          _buildMenuItem(Icons.person, 'Profile', '/profile'),
          _buildMenuItem(Icons.settings, 'Settings', '/settings'),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFEF4444)),
              title: const Text('Logout', style: TextStyle(color: Color(0xFFEF4444))),
              onTap: () async {
                await authProvider.signOut();
                if (context.mounted) Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String route) {
    final isActive = _selectedMenu == title;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF3B82F6).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? const Color(0xFF3B82F6) : const Color(0xFF718096), size: 20),
        title: Text(title, style: TextStyle(color: isActive ? const Color(0xFF3B82F6) : const Color(0xFF4A5568), fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
        onTap: () => setState(() => _selectedMenu = title),
      ),
    );
  }

  Widget _buildTopNavbar(AuthProvider authProvider) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search reports...',
                  prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF718096)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF718096)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFF3B82F6),
            child: Text(authProvider.currentUser?.name[0].toUpperCase() ?? 'U', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String trend) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(trend, style: const TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A202C))),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 14, color: Color(0xFF718096))),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsTable(FirestoreService firestoreService, AuthProvider authProvider, {bool showAll = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: StreamBuilder<List<Issue>>(
        stream: firestoreService.getIssuesByUser(authProvider.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator()));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    const Text('No reports yet', style: TextStyle(fontSize: 16, color: Color(0xFF718096))),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/report'),
                      child: const Text('Create First Report'),
                    ),
                  ],
                ),
              ),
            );
          }

          final issues = snapshot.data!;
          final displayIssues = showAll ? issues : issues.take(10).toList();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(const Color(0xFFF9FAFB)),
              columns: const [
                DataColumn(label: Text('Report ID', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
                DataColumn(label: Text('Issue Title', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
                DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
                DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
                DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568)))),
              ],
              rows: displayIssues.map((issue) {
                return DataRow(
                  cells: [
                    DataCell(Text(issue.ticketId, style: const TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.w500))),
                    DataCell(Text(issue.title, style: const TextStyle(color: Color(0xFF1A202C)))),
                    DataCell(Text(issue.category, style: const TextStyle(color: Color(0xFF718096)))),
                    DataCell(StatusBadge(status: issue.status)),
                    DataCell(Text(DateFormat('MMM dd, yyyy').format(issue.createdAt), style: const TextStyle(color: Color(0xFF718096)))),
                    DataCell(
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => IssueDetailScreen(issue: issue))),
                        child: const Text('View'),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
