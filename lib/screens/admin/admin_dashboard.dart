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
              child: _buildContent(),
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
      case 'Map View':
        return _buildMapViewContent();
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFAFAFA), Color(0xFFF5F7FA)],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 30, offset: Offset(0, 15)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.dashboard_customize_rounded, color: Colors.white, size: 28),
                          ),
                          SizedBox(width: 16),
                          Text('Issue Management', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1.2)),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text('Monitor, filter, and manage all civic issues in real-time', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500)),
                    ],
                  ),
                  StreamBuilder<List<Issue>>(
                    stream: _firestoreService.getAllIssues(),
                    builder: (context, snapshot) {
                      final total = snapshot.data?.length ?? 0;
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                        ),
                        child: Column(
                          children: [
                            Text('$total', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1.5)),
                            Text('Total Issues', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.tune_rounded, color: Color(0xFF4F46E5), size: 24),
                  SizedBox(width: 12),
                  Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  SizedBox(width: 32),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildModernFilterDropdown(
                          hint: 'All Statuses',
                          value: _filterStatus,
                          items: ['All Statuses', ...AppConstants.statuses],
                          icon: Icons.flag_rounded,
                          onChanged: (val) => setState(() => _filterStatus = val == 'All Statuses' ? null : val),
                        )),
                        SizedBox(width: 16),
                        Expanded(child: _buildModernFilterDropdown(
                          hint: 'All Categories',
                          value: _filterCategory,
                          items: ['All Categories', ...AppConstants.categories],
                          icon: Icons.category_rounded,
                          onChanged: (val) => setState(() => _filterCategory = val == 'All Categories' ? null : val),
                        )),
                        SizedBox(width: 16),
                        if (_filterStatus != null || _filterCategory != null)
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _filterStatus = null;
                                _filterCategory = null;
                              }),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Color(0xFFEF4444).withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.clear_rounded, color: Color(0xFFEF4444), size: 18),
                                    SizedBox(width: 8),
                                    Text('Clear', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w600, fontSize: 14)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            _buildPremiumIssuesTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsContent() {
    return Center(child: Text('Analytics - Coming Soon', style: TextStyle(fontSize: 24, color: Color(0xFF64748B))));
  }

  Widget _buildMapViewContent() {
    return StreamBuilder<List<Issue>>(
      stream: _firestoreService.getAllIssues(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: Color(0xFF4F46E5), strokeWidth: 3));
        }
        final issues = snapshot.data!.where((i) => i.location != null).toList();
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF4F46E5)],
                ).createShader(bounds),
                child: Text('Issue Heat Map', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1.5)),
              ),
              SizedBox(height: 8),
              Text('${issues.length} issues with location data', style: TextStyle(fontSize: 15, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              SizedBox(height: 48),
              Container(
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: Offset(0, 4)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      Container(
                        color: Color(0xFFF8FAFC),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map_rounded, size: 80, color: Color(0xFF4F46E5).withOpacity(0.3)),
                              SizedBox(height: 24),
                              Text('Interactive Map View', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                              SizedBox(height: 12),
                              Text('Showing ${issues.length} issue locations', style: TextStyle(fontSize: 16, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                      ),
                      ...issues.asMap().entries.map((entry) {
                        final index = entry.key;
                        final issue = entry.value;
                        final left = (index % 5) * 150.0 + 50;
                        final top = (index ~/ 5) * 100.0 + 50;
                        return Positioned(
                          left: left,
                          top: top,
                          child: _buildMapMarker(issue),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  _buildLegendItem('Reported', Color(0xFFF59E0B)),
                  SizedBox(width: 32),
                  _buildLegendItem('In Progress', Color(0xFF8B5CF6)),
                  SizedBox(width: 32),
                  _buildLegendItem('Resolved', Color(0xFF10B981)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMapMarker(Issue issue) {
    Color color;
    switch (issue.status) {
      case 'Reported':
        color = Color(0xFFF59E0B);
        break;
      case 'In Progress':
        color = Color(0xFF8B5CF6);
        break;
      case 'Resolved':
        color = Color(0xFF10B981);
        break;
      default:
        color = Color(0xFF64748B);
    }
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminIssueDetailScreen(issue: issue))),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.5), blurRadius: 12, offset: Offset(0, 4)),
            ],
          ),
          child: Icon(Icons.location_on, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
      ],
    );
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
          _buildMenuItem(Icons.map_rounded, 'Map View'),
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
    return SizedBox.shrink();
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

  Widget _buildModernFilterDropdown({required String hint, String? value, required List<String> items, required IconData icon, required Function(String?) onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF64748B), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: DropdownButton<String>(
              hint: Text(hint, style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w600)),
              value: value,
              isExpanded: true,
              underline: SizedBox(),
              icon: Icon(Icons.expand_more_rounded, color: Color(0xFF64748B), size: 22),
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumIssuesTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.08), blurRadius: 30, offset: Offset(0, 10)),
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: Offset(0, 4)),
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFF4F46E5), strokeWidth: 3),
                      SizedBox(height: 16),
                      Text('Loading issues...', style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Container(
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFFFEF2F2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.error_outline_rounded, size: 48, color: Color(0xFFEF4444)),
                      ),
                      SizedBox(height: 20),
                      Text('Error loading issues', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                      SizedBox(height: 8),
                      Text('${snapshot.error}', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFF8FAFC), Color(0xFFEEF2FF)],
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(Icons.inbox_rounded, size: 64, color: Color(0xFF4F46E5).withOpacity(0.4)),
                      ),
                      SizedBox(height: 24),
                      Text('No issues found', style: TextStyle(fontSize: 22, color: Color(0xFF0F172A), fontWeight: FontWeight.w800)),
                      SizedBox(height: 8),
                      Text('Issues will appear here once reported by citizens', style: TextStyle(fontSize: 15, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
              );
            }

            final issues = snapshot.data!;
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF8FAFC), Color(0xFFEEF2FF)],
                    ),
                    border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text('TICKET', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF4F46E5), fontSize: 12, letterSpacing: 1.2))),
                      Expanded(flex: 4, child: Text('ISSUE DETAILS', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF4F46E5), fontSize: 12, letterSpacing: 1.2))),
                      Expanded(flex: 2, child: Text('CATEGORY', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF4F46E5), fontSize: 12, letterSpacing: 1.2))),
                      Expanded(flex: 2, child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF4F46E5), fontSize: 12, letterSpacing: 1.2))),
                      Expanded(flex: 2, child: Text('REPORTED', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF4F46E5), fontSize: 12, letterSpacing: 1.2))),
                      Expanded(flex: 2, child: Text('ACTION', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF4F46E5), fontSize: 12, letterSpacing: 1.2))),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: issues.length,
                  itemBuilder: (context, index) {
                    final issue = issues[index];
                    return _buildPremiumIssueRow(issue, index);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPremiumIssueRow(Issue issue, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: index.isEven ? Colors.white : Color(0xFFFAFAFA),
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4F46E5).withOpacity(0.1), Color(0xFF6366F1).withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF4F46E5).withOpacity(0.3)),
              ),
              child: Text(issue.ticketId, style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.5)),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(issue.title, style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w700, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: 4),
                Text(issue.description, style: TextStyle(color: Color(0xFF64748B), fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getCategoryColor(issue.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _getCategoryColor(issue.category).withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getCategoryIcon(issue.category), size: 16, color: _getCategoryColor(issue.category)),
                  SizedBox(width: 6),
                  Expanded(child: Text(issue.category, style: TextStyle(color: _getCategoryColor(issue.category), fontSize: 13, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(flex: 2, child: StatusBadge(status: issue.status)),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat('MMM dd, yyyy').format(issue.createdAt), style: TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w600)),
                Text(DateFormat('hh:mm a').format(issue.createdAt), style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminIssueDetailScreen(issue: issue))),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 12, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.settings_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text('Manage', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
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

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'road': return Color(0xFFEF4444);
      case 'garbage': return Color(0xFF10B981);
      case 'water': return Color(0xFF3B82F6);
      case 'electricity': return Color(0xFFF59E0B);
      case 'drainage': return Color(0xFF8B5CF6);
      default: return Color(0xFF64748B);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'road': return Icons.construction_rounded;
      case 'garbage': return Icons.delete_rounded;
      case 'water': return Icons.water_drop_rounded;
      case 'electricity': return Icons.bolt_rounded;
      case 'drainage': return Icons.water_rounded;
      default: return Icons.category_rounded;
    }
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
