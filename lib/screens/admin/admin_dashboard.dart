import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../models/issue.dart';
import '../../services/firestore_service.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/status_badge.dart';
import '../../utils/constants.dart';
import 'admin_issue_detail_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _firestoreService = FirestoreService();
  String? _filterStatus;
  String? _filterCategory;
  String _selectedMenu = 'Dashboard';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
                  Expanded(child: _buildContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedMenu) {
      case 'Dashboard':
        return _buildDashboardContent();
      case 'All Issues':
        return _buildAllIssuesContent();
      case 'Analytics':
        return _buildAnalyticsContent();
      case 'Settings':
        return _buildSettingsContent();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF4F46E5)],
                    ).createShader(bounds),
                    child: Text(
                      'Admin Dashboard',
                      style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1.5, height: 1.1),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manage and monitor all civic issues',
                    style: TextStyle(fontSize: 15, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 48),
          StreamBuilder<List<Issue>>(
            stream: _firestoreService.getAllIssues(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(color: Color(0xFF4F46E5), strokeWidth: 3));
              }
              final issues = snapshot.data!;
              final total = issues.length;
              final reported = issues.where((i) => i.status == 'Reported').length;
              final inProgress = issues.where((i) => i.status == 'In Progress').length;
              final resolved = issues.where((i) => i.status == 'Resolved').length;

              return Row(
                children: [
                  _buildStatCard('Total Issues', total, Icons.folder_rounded, [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                  SizedBox(width: 24),
                  _buildStatCard('Reported', reported, Icons.schedule_rounded, [Color(0xFFF59E0B), Color(0xFFFBBF24)]),
                  SizedBox(width: 24),
                  _buildStatCard('In Progress', inProgress, Icons.sync_rounded, [Color(0xFF8B5CF6), Color(0xFFA78BFA)]),
                  SizedBox(width: 24),
                  _buildStatCard('Resolved', resolved, Icons.check_circle_rounded, [Color(0xFF10B981), Color(0xFF34D399)]),
                ],
              );
            },
          ),
          SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Issues', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.3)),
            ],
          ),
          SizedBox(height: 24),
          _buildIssuesTable(),
        ],
      ),
    );
  }

  Widget _buildAllIssuesContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF4F46E5)],
            ).createShader(bounds),
            child: Text('All Issues', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1.5)),
          ),
          SizedBox(height: 48),
          Row(
            children: [
              _buildFilterDropdown(
                hint: 'Status',
                value: _filterStatus,
                items: ['All Statuses', ...AppConstants.statuses],
                onChanged: (val) => setState(() => _filterStatus = val == 'All Statuses' ? null : val),
              ),
              SizedBox(width: 16),
              _buildFilterDropdown(
                hint: 'Category',
                value: _filterCategory,
                items: ['All Categories', ...AppConstants.categories],
                onChanged: (val) => setState(() => _filterCategory = val == 'All Categories' ? null : val),
              ),
            ],
          ),
          SizedBox(height: 24),
          _buildIssuesTable(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsContent() {
    return Center(child: Text('Analytics - Coming Soon', style: TextStyle(fontSize: 24, color: Color(0xFF64748B))));
  }

  Widget _buildSettingsContent() {
    return Center(child: Text('Settings - Coming Soon', style: TextStyle(fontSize: 24, color: Color(0xFF64748B))));
  }

  Widget _buildSidebar(AuthProvider authProvider) {
    return Container(
      width: 280,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.08), blurRadius: 30, offset: Offset(0, 10)),
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(28),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.4), blurRadius: 12, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 24),
                ),
                SizedBox(width: 14),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF4F46E5)],
                  ).createShader(bounds),
                  child: Text('Admin Panel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.3)),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          _buildMenuItem(Icons.dashboard_rounded, 'Dashboard'),
          _buildMenuItem(Icons.list_alt_rounded, 'All Issues'),
          _buildMenuItem(Icons.analytics_rounded, 'Analytics'),
          _buildMenuItem(Icons.settings_rounded, 'Settings'),
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
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    final isActive = _selectedMenu == title;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF4F46E5) : Colors.transparent,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: Offset(0, 4)),
        ],
      ),
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
                  hintText: 'Search issues...',
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
              gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Text(
                authProvider.currentUser?.name[0].toUpperCase() ?? 'A',
                style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, List<Color> gradientColors) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: gradientColors[0].withOpacity(0.25), blurRadius: 16, offset: Offset(0, 6)),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            SizedBox(height: 24),
            Text(count.toString(), style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -1.5, height: 1)),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w600, letterSpacing: 0.3)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({required String hint, String? value, required List<String> items, required Function(String?) onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: DropdownButton<String>(
        hint: Text(hint, style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500)),
        value: value,
        underline: SizedBox(),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: TextStyle(fontSize: 14)))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildIssuesTable() {
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
          stream: _filterStatus != null
              ? _firestoreService.getIssuesByStatus(_filterStatus!)
              : _filterCategory != null
                  ? _firestoreService.getIssuesByCategory(_filterCategory!)
                  : _firestoreService.getAllIssues(),
          builder: (context, snapshot) {
            print('StreamBuilder state: ${snapshot.connectionState}');
            print('Has data: ${snapshot.hasData}');
            print('Data length: ${snapshot.data?.length}');
            print('Error: ${snapshot.error}');
            
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(padding: EdgeInsets.all(80), child: Center(child: CircularProgressIndicator(color: Color(0xFF4F46E5), strokeWidth: 3)));
            }

            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.all(80),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, size: 72, color: Color(0xFFEF4444)),
                      SizedBox(height: 24),
                      Text('Error: ${snapshot.error}', style: TextStyle(fontSize: 16, color: Color(0xFFEF4444))),
                    ],
                  ),
                ),
              );
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
                      Text('No issues found', style: TextStyle(fontSize: 20, color: Color(0xFF0F172A), fontWeight: FontWeight.w700)),
                      SizedBox(height: 8),
                      Text('Issues will appear here once reported', style: TextStyle(fontSize: 15, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
              );
            }

            final issues = snapshot.data!;
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
                rows: issues.map((issue) {
                  return DataRow(
                    cells: [
                      DataCell(Text(issue.ticketId, style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w700, fontSize: 14))),
                      DataCell(SizedBox(width: 250, child: Text(issue.title, style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 15), overflow: TextOverflow.ellipsis))),
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
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminIssueDetailScreen(issue: issue))),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Color(0xFF4F46E5),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 12, offset: Offset(0, 4)),
                                ],
                              ),
                              child: Text('Manage', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
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
}
