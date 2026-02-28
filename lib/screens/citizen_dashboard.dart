import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';
import '../models/issue.dart';
import '../widgets/status_badge.dart';
import 'issue_detail_screen.dart';
import 'map_view_screen.dart';

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFEEF2FF), Color(0xFFF1F5F9)],
          ),
        ),
        child: Row(
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
        return MapViewScreen();
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
    final hour = DateTime.now().hour;
    String greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Color(0xFF1E293B), Color(0xFF4F46E5), Color(0xFF6366F1)],
            ).createShader(bounds),
            child: Text(
              '$greeting, ${authProvider.currentUser?.name}! 👋',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1, height: 1.2),
            ),
          ),
          SizedBox(height: 10),
          Text(
            DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now()),
            style: TextStyle(fontSize: 16, color: Color(0xFF64748B), fontWeight: FontWeight.w500, letterSpacing: 0.3),
          ),
          SizedBox(height: 40),
          StreamBuilder<List<Issue>>(
            stream: firestoreService.getIssuesByUser(authProvider.currentUser!.uid),
            builder: (context, snapshot) {
              final issues = snapshot.data ?? [];
              final pending = issues.where((i) => i.status == 'Reported').length;
              final inProgress = issues.where((i) => i.status == 'In Progress').length;
              final resolved = issues.where((i) => i.status == 'Resolved').length;

              return Row(
                children: [
                  _buildStatCard('Total Reports', issues.length.toString(), Icons.description_rounded, [Color(0xFF4F46E5), Color(0xFF6366F1)], '+12%'),
                  SizedBox(width: 20),
                  _buildStatCard('Pending', pending.toString(), Icons.pending_actions_rounded, [Color(0xFFF59E0B), Color(0xFFFBBF24)], '+5%'),
                  SizedBox(width: 20),
                  _buildStatCard('In Progress', inProgress.toString(), Icons.autorenew_rounded, [Color(0xFF8B5CF6), Color(0xFFA78BFA)], '+8%'),
                  SizedBox(width: 20),
                  _buildStatCard('Resolved', resolved.toString(), Icons.check_circle_rounded, [Color(0xFF10B981), Color(0xFF34D399)], '+15%'),
                ],
              );
            },
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Reports', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), letterSpacing: -0.5)),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/report'),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.4), blurRadius: 16, offset: Offset(0, 6)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add_rounded, size: 20, color: Colors.white),
                        SizedBox(width: 8),
                        Text('New Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildReportsTable(firestoreService, authProvider),
        ],
      ),
    );
  }

  Widget _buildAllReportsContent(FirestoreService firestoreService, AuthProvider authProvider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF4F46E5)],
                ).createShader(bounds),
                child: Text('All My Reports', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.8)),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/report'),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.4), blurRadius: 16, offset: Offset(0, 6)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add_rounded, size: 20, color: Colors.white),
                        SizedBox(width: 8),
                        Text('New Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
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
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F46E5).withOpacity(0.1), Color(0xFF6366F1).withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Color(0xFF4F46E5).withOpacity(0.2), width: 2),
            ),
            child: Icon(icon, size: 80, color: Color(0xFF4F46E5).withOpacity(0.6)),
          ),
          SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Color(0xFF1E293B), Color(0xFF4F46E5)],
            ).createShader(bounds),
            child: Text(title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
          ),
          SizedBox(height: 12),
          Text('Coming soon!', style: TextStyle(fontSize: 18, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSidebar(AuthProvider authProvider) {
    return Container(
      width: 280,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.1), blurRadius: 30, offset: Offset(0, 10)),
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(28),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.4), blurRadius: 12, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Icon(Icons.location_city, color: Colors.white, size: 24),
                    ),
                    SizedBox(width: 14),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Color(0xFF1E293B), Color(0xFF4F46E5)],
                      ).createShader(bounds),
                      child: Text('CityCare', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.5)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              _buildMenuItem(Icons.dashboard_rounded, 'Dashboard', '/dashboard'),
              _buildMenuItem(Icons.list_alt_rounded, 'All Reports', '/my-issues'),
              _buildMenuItem(Icons.map_rounded, 'Map View', '/map'),
              _buildMenuItem(Icons.category_rounded, 'Categories', '/categories'),
              _buildMenuItem(Icons.bar_chart_rounded, 'Analytics', '/analytics'),
              _buildMenuItem(Icons.person_rounded, 'Profile', '/profile'),
              _buildMenuItem(Icons.settings_rounded, 'Settings', '/settings'),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(20),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      await authProvider.signOut();
                      if (context.mounted) Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFEF4444).withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 20),
                          SizedBox(width: 12),
                          Text('Logout', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w600, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String route) {
    final isActive = _selectedMenu == title;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: isActive ? LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
        ) : null,
        borderRadius: BorderRadius.circular(14),
        boxShadow: isActive ? [
          BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 12, offset: Offset(0, 4)),
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => _selectedMenu = title),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: isActive ? Colors.white : Color(0xFF64748B), size: 22),
                SizedBox(width: 14),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? Colors.white : Color(0xFF475569),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 15,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavbar(AuthProvider authProvider) {
    return Container(
      height: 80,
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Color(0xFFE2E8F0), width: 1),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search reports...',
                      hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
                      prefixIcon: Icon(Icons.search_rounded, size: 22, color: Color(0xFF64748B)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFE2E8F0)),
                ),
                child: Icon(Icons.notifications_rounded, color: Color(0xFF64748B), size: 22),
              ),
              SizedBox(width: 16),
              Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Text(
                    authProvider.currentUser?.name[0].toUpperCase() ?? 'U',
                    style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, List<Color> gradientColors, String trend) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.6)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(color: gradientColors[0].withOpacity(0.1), blurRadius: 20, offset: Offset(0, 8)),
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradientColors),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(color: gradientColors[0].withOpacity(0.3), blurRadius: 12, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 26),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF10B981).withOpacity(0.2), Color(0xFF34D399).withOpacity(0.1)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF10B981).withOpacity(0.3)),
                      ),
                      child: Text(trend, style: TextStyle(color: Color(0xFF059669), fontSize: 13, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(value, style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: Color(0xFF1E293B), letterSpacing: -1)),
                SizedBox(height: 6),
                Text(title, style: TextStyle(fontSize: 15, color: Color(0xFF64748B), fontWeight: FontWeight.w500, letterSpacing: 0.2)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportsTable(FirestoreService firestoreService, AuthProvider authProvider, {bool showAll = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: StreamBuilder<List<Issue>>(
            stream: firestoreService.getIssuesByUser(authProvider.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(padding: EdgeInsets.all(60), child: Center(child: CircularProgressIndicator(color: Color(0xFF4F46E5))));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(60),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.inbox_rounded, size: 64, color: Color(0xFFCBD5E1)),
                        ),
                        SizedBox(height: 20),
                        Text('No reports yet', style: TextStyle(fontSize: 18, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                        SizedBox(height: 24),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/report'),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.4), blurRadius: 16, offset: Offset(0, 6)),
                                ],
                              ),
                              child: Text('Create First Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          ),
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
                  headingRowColor: MaterialStateProperty.all(Color(0xFFF8FAFC).withOpacity(0.5)),
                  dataRowHeight: 72,
                  headingRowHeight: 56,
                  columns: [
                    DataColumn(label: Text('Report ID', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF475569), fontSize: 14, letterSpacing: 0.5))),
                    DataColumn(label: Text('Issue Title', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF475569), fontSize: 14, letterSpacing: 0.5))),
                    DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF475569), fontSize: 14, letterSpacing: 0.5))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF475569), fontSize: 14, letterSpacing: 0.5))),
                    DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF475569), fontSize: 14, letterSpacing: 0.5))),
                    DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF475569), fontSize: 14, letterSpacing: 0.5))),
                  ],
                  rows: displayIssues.map((issue) {
                    return DataRow(
                      cells: [
                        DataCell(Text(issue.ticketId, style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w600, fontSize: 14))),
                        DataCell(Text(issue.title, style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w500, fontSize: 14))),
                        DataCell(Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(issue.category, style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w600)),
                        )),
                        DataCell(StatusBadge(status: issue.status)),
                        DataCell(Text(DateFormat('MMM dd, yyyy').format(issue.createdAt), style: TextStyle(color: Color(0xFF64748B), fontSize: 14))),
                        DataCell(
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => IssueDetailScreen(issue: issue))),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('View', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
