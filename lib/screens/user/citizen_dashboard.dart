import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../models/issue.dart';
import '../../models/issue_update.dart';
import '../../widgets/status_badge.dart';
import 'issue_detail_screen.dart';
import 'profile_screen.dart';

class CitizenDashboard extends StatefulWidget {
  const CitizenDashboard({super.key});

  @override
  State<CitizenDashboard> createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard> {
  String _selectedMenu = 'Dashboard';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreService = FirestoreService();

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Row(
        children: [
          _buildSidebar(authProvider),
          Expanded(
            child: Column(
              children: [
                if (_selectedMenu == 'Dashboard') _buildTopNavbar(authProvider),
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
      case 'Profile':
        return ProfileScreen();
      case 'Settings':
        return _buildPlaceholder('Settings', Icons.settings);
      default:
        return _buildDashboardContent(firestoreService, authProvider);
    }
  }

  Widget _buildDashboardContent(FirestoreService firestoreService, AuthProvider authProvider) {
    final hour = DateTime.now().hour;
    String greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
    
    if (authProvider.currentUser == null) {
      return Center(child: CircularProgressIndicator());
    }
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting,',
                    style: TextStyle(fontSize: 18, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Text(
                    authProvider.currentUser?.name ?? 'User',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -1, height: 1.2),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFDDD6FE)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF6366F1)),
                        SizedBox(width: 6),
                        Text(
                          DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now()),
                          style: TextStyle(fontSize: 13, color: Color(0xFF6366F1), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/report'),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.4), blurRadius: 20, offset: Offset(0, 8)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_rounded, size: 22, color: Colors.white),
                        SizedBox(width: 12),
                        Text('Report New Issue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                  _buildStatCard('Total Reports', issues.length.toString(), Icons.folder_open_rounded, [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                  SizedBox(width: 20),
                  _buildStatCard('Pending', pending.toString(), Icons.schedule_rounded, [Color(0xFFF59E0B), Color(0xFFFBBF24)]),
                  SizedBox(width: 20),
                  _buildStatCard('In Progress', inProgress.toString(), Icons.sync_rounded, [Color(0xFF8B5CF6), Color(0xFFA78BFA)]),
                  SizedBox(width: 20),
                  _buildStatCard('Resolved', resolved.toString(), Icons.check_circle_rounded, [Color(0xFF10B981), Color(0xFF34D399)]),
                ],
              );
            },
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Activity', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: -0.5)),
              if (_searchQuery.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFBAE6FD)),
                  ),
                  child: Text('Results for "$_searchQuery"', style: TextStyle(fontSize: 13, color: Color(0xFF0284C7), fontWeight: FontWeight.w600)),
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
    if (authProvider.currentUser == null) {
      return Center(child: CircularProgressIndicator());
    }
    
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
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/splash/logo.png',
                    height: 28,
                  ),
                ),
                SizedBox(width: 12),
                Text('CityCare', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildMenuItem(Icons.dashboard_rounded, 'Dashboard', '/dashboard'),
                _buildMenuItem(Icons.list_alt_rounded, 'All Reports', '/my-issues'),
                _buildMenuItem(Icons.person_rounded, 'Profile', '/profile'),
                _buildMenuItem(Icons.settings_rounded, 'Settings', '/settings'),
              ],
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFDDD6FE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_rounded, color: Color(0xFF6366F1), size: 20),
                    SizedBox(width: 8),
                    Text('Quick Tip', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF4F46E5))),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Add photos to your reports for faster resolution',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6366F1), height: 1.4),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  await authProvider.signOut();
                  if (mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFFECACA)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 20),
                      SizedBox(width: 10),
                      Text('Logout', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w700, fontSize: 15)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String route) {
    final isActive = _selectedMenu == title;
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        gradient: isActive ? LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
        ) : null,
        color: isActive ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isActive ? [
          BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.25), blurRadius: 12, offset: Offset(0, 4)),
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
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
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 15,
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
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Search reports...',
                      hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
                      prefixIcon: Icon(Icons.search_rounded, size: 22, color: Color(0xFF64748B)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, size: 20, color: Color(0xFF64748B)),
                              onPressed: () => setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              }),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _showNotifications,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFE2E8F0)),
                    ),
                    child: Icon(Icons.notifications_rounded, color: Color(0xFF64748B), size: 22),
                  ),
                ),
              ),
              SizedBox(width: 16),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMenu = 'Profile'),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              authProvider.currentUser?.name[0].toUpperCase() ?? 'U',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              authProvider.currentUser?.name.split(' ').first ?? 'User',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                            ),
                            Text(
                              'Citizen',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFF64748B)),
                      ],
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

  Widget _buildStatCard(String title, String value, IconData icon, List<Color> gradientColors) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: gradientColors[0].withOpacity(0.25), blurRadius: 12, offset: Offset(0, 4)),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -1, height: 1)),
                SizedBox(height: 4),
                Text(title, style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsTable(FirestoreService firestoreService, AuthProvider authProvider, {bool showAll = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: StreamBuilder<List<Issue>>(
          stream: firestoreService.getIssuesByUser(authProvider.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(padding: EdgeInsets.all(80), child: Center(child: CircularProgressIndicator(color: Color(0xFF4F46E5), strokeWidth: 3)));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(80),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(Icons.inbox_rounded, size: 72, color: Color(0xFFCBD5E1)),
                      ),
                      SizedBox(height: 24),
                      Text('No reports yet', style: TextStyle(fontSize: 20, color: Color(0xFF0F172A), fontWeight: FontWeight.w700)),
                      SizedBox(height: 8),
                      Text('Start by creating your first report', style: TextStyle(fontSize: 15, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
              );
            }

            final issues = snapshot.data!;
            final filteredIssues = _searchQuery.isEmpty
                ? issues
                : issues.where((issue) =>
                    issue.title.toLowerCase().contains(_searchQuery) ||
                    issue.ticketId.toLowerCase().contains(_searchQuery) ||
                    issue.category.toLowerCase().contains(_searchQuery) ||
                    issue.status.toLowerCase().contains(_searchQuery)).toList();
            final displayIssues = showAll ? filteredIssues : filteredIssues.take(10).toList();
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Color(0xFFF8FAFC)),
                dataRowHeight: 80,
                headingRowHeight: 64,
                columnSpacing: 48,
                horizontalMargin: 32,
                columns: [
                  DataColumn(label: Text('TICKET ID', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF64748B), fontSize: 12, letterSpacing: 1))),
                  DataColumn(label: Text('TITLE', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF64748B), fontSize: 12, letterSpacing: 1))),
                  DataColumn(label: Text('CATEGORY', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF64748B), fontSize: 12, letterSpacing: 1))),
                  DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF64748B), fontSize: 12, letterSpacing: 1))),
                  DataColumn(label: Text('DATE', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF64748B), fontSize: 12, letterSpacing: 1))),
                  DataColumn(label: Text('', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF64748B), fontSize: 12))),
                ],
                rows: displayIssues.map((issue) {
                  return DataRow(
                    cells: [
                      DataCell(Text(issue.ticketId, style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w700, fontSize: 14))),
                      DataCell(SizedBox(width: 200, child: Text(issue.title, style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 15), overflow: TextOverflow.ellipsis))),
                      DataCell(Container(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xFFE2E8F0)),
                        ),
                        child: Text(issue.category, style: TextStyle(color: Color(0xFF475569), fontSize: 13, fontWeight: FontWeight.w600)),
                      )),
                      DataCell(StatusBadge(status: issue.status)),
                      DataCell(Text(DateFormat('MMM dd, yyyy').format(issue.createdAt), style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500))),
                      DataCell(
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => IssueDetailScreen(issue: issue))),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Color(0xFF4F46E5),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 12, offset: Offset(0, 4)),
                                ],
                              ),
                              child: Text('View Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
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
    );
  }

  void _showNotifications() {
    final firestoreService = FirestoreService();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.currentUser == null) return;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 500,
          constraints: BoxConstraints(maxHeight: 600),
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.notifications_rounded, color: Colors.white, size: 24),
                      ),
                      SizedBox(width: 16),
                      Text('Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Expanded(
                child: StreamBuilder<List<IssueUpdate>>(
                  stream: firestoreService.getUserNotifications(authProvider.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: Color(0xFF4F46E5)));
                    }
                    
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_none, size: 64, color: Color(0xFFCBD5E1)),
                            SizedBox(height: 16),
                            Text('No notifications yet', style: TextStyle(fontSize: 16, color: Color(0xFF64748B))),
                          ],
                        ),
                      );
                    }
                    
                    final updates = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: updates.length,
                      itemBuilder: (context, index) {
                        final update = updates[index];
                        return _buildNotificationItem(
                          _getNotificationTitle(update.type),
                          update.message,
                          _getNotificationIcon(update.type),
                          _getNotificationColor(update.type),
                          _getTimeAgo(update.timestamp),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getNotificationTitle(String type) {
    switch (type) {
      case 'status_change':
        return 'Issue Updated';
      case 'comment':
        return 'New Comment';
      case 'assignment':
        return 'Issue Assigned';
      default:
        return 'Update';
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'status_change':
        return Icons.sync_rounded;
      case 'comment':
        return Icons.comment_rounded;
      case 'assignment':
        return Icons.person_add_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'status_change':
        return Color(0xFF8B5CF6);
      case 'comment':
        return Color(0xFF4F46E5);
      case 'assignment':
        return Color(0xFF10B981);
      default:
        return Color(0xFF64748B);
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return DateFormat('MMM dd').format(timestamp);
  }

  Widget _buildNotificationItem(String title, String message, IconData icon, Color color, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                SizedBox(height: 4),
                Text(message, style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                SizedBox(height: 4),
                Text(time, style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
