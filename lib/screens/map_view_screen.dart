import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';
import '../models/issue.dart';
import 'package:intl/intl.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  String _selectedStatus = 'All';
  String _selectedCategory = 'All';
  bool _showHeatmap = false;
  Issue? _selectedIssue;
  bool _showDetailPanel = false;

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
        child: Stack(
          children: [
            // Main Map Area
            _buildMapArea(),
            
            // Top Stats Overlay
            Positioned(
              top: 20,
              left: 20,
              right: _showDetailPanel ? 420 : 20,
              child: _buildStatsOverlay(firestoreService, authProvider),
            ),

            // Top Search Bar
            Positioned(
              top: 100,
              left: 20,
              right: _showDetailPanel ? 420 : 20,
              child: _buildSearchBar(),
            ),

            // Left Filter Panel
            Positioned(
              top: 180,
              left: 20,
              child: _buildFilterPanel(),
            ),

            // Bottom Controls
            Positioned(
              bottom: 30,
              right: _showDetailPanel ? 420 : 30,
              child: _buildMapControls(),
            ),

            // Right Detail Panel
            if (_showDetailPanel && _selectedIssue != null)
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: _buildDetailPanel(_selectedIssue!),
              ),

            // Issue Markers (Simulated)
            _buildIssueMarkers(firestoreService, authProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildMapArea() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Placeholder Map Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF3F4F6),
                    Color(0xFFE5E7EB),
                    Color(0xFFD1D5DB),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_rounded, size: 80, color: Color(0xFF9CA3AF)),
                    SizedBox(height: 16),
                    Text(
                      'Interactive Map View',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Google Maps integration coming soon',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Grid overlay for map feel
            CustomPaint(
              size: Size.infinite,
              painter: GridPainter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsOverlay(FirestoreService firestoreService, AuthProvider authProvider) {
    return StreamBuilder<List<Issue>>(
      stream: firestoreService.getIssuesByUser(authProvider.currentUser!.uid),
      builder: (context, snapshot) {
        final issues = snapshot.data ?? [];
        final activeIssues = issues.where((i) => i.status != 'Resolved').length;
        final criticalIssues = issues.where((i) => i.status == 'Reported').length;

        return Row(
          children: [
            _buildStatCard('Total Reports', issues.length.toString(), Icons.location_on_rounded, [Color(0xFF4F46E5), Color(0xFF6366F1)]),
            SizedBox(width: 12),
            _buildStatCard('Active Issues', activeIssues.toString(), Icons.warning_rounded, [Color(0xFFF59E0B), Color(0xFFFBBF24)]),
            SizedBox(width: 12),
            _buildStatCard('Critical Alerts', criticalIssues.toString(), Icons.error_rounded, [Color(0xFFEF4444), Color(0xFFF87171)]),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, List<Color> gradientColors) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(color: gradientColors[0].withOpacity(0.1), blurRadius: 20, offset: Offset(0, 8)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradientColors),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                      Text(title, style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 22),
              SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by location or report ID...',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              Icon(Icons.tune_rounded, color: Color(0xFF64748B), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      width: 280,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.filter_list_rounded, color: Color(0xFF4F46E5), size: 20),
                  SizedBox(width: 8),
                  Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                ],
              ),
              SizedBox(height: 20),
              Text('Status', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['All', 'Reported', 'In Progress', 'Resolved'].map((status) {
                  final isSelected = _selectedStatus == status;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedStatus = status),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: isSelected ? LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]) : null,
                        color: isSelected ? null : Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? Color(0xFF4F46E5) : Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Color(0xFF64748B),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text('Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedCategory, style: TextStyle(fontSize: 14, color: Color(0xFF475569), fontWeight: FontWeight.w500)),
                    Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 20),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Heatmap', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                  Switch(
                    value: _showHeatmap,
                    onChanged: (val) => setState(() => _showHeatmap = val),
                    activeColor: Color(0xFF4F46E5),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedStatus = 'All';
                      _selectedCategory = 'All';
                      _showHeatmap = false;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Reset Filters', style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapControls() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, 8)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.add_rounded, color: Color(0xFF4F46E5)),
                    onPressed: () {},
                  ),
                  Divider(height: 1, color: Color(0xFFE2E8F0)),
                  IconButton(
                    icon: Icon(Icons.remove_rounded, color: Color(0xFF4F46E5)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        _buildControlButton(Icons.my_location_rounded),
        SizedBox(height: 12),
        _buildControlButton(Icons.layers_rounded),
      ],
    );
  }

  Widget _buildControlButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Icon(icon, color: Color(0xFF4F46E5), size: 22),
        ),
      ),
    );
  }

  Widget _buildIssueMarkers(FirestoreService firestoreService, AuthProvider authProvider) {
    return StreamBuilder<List<Issue>>(
      stream: firestoreService.getIssuesByUser(authProvider.currentUser!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox();
        
        final issues = snapshot.data!;
        return Stack(
          children: issues.take(5).toList().asMap().entries.map((entry) {
            final index = entry.key;
            final issue = entry.value;
            return Positioned(
              left: 100.0 + (index * 150),
              top: 200.0 + (index * 80),
              child: _buildMarker(issue),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildMarker(Issue issue) {
    Color markerColor;
    switch (issue.status) {
      case 'Resolved':
        markerColor = Color(0xFF10B981);
        break;
      case 'In Progress':
        markerColor = Color(0xFF4F46E5);
        break;
      case 'Reported':
        markerColor = Color(0xFFF59E0B);
        break;
      default:
        markerColor = Color(0xFFEF4444);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIssue = issue;
          _showDetailPanel = true;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: markerColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(color: markerColor.withOpacity(0.4), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Icon(Icons.location_on, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildDetailPanel(Issue issue) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.85)],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: Offset(-10, 0)),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Issue Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                      onPressed: () => setState(() => _showDetailPanel = false),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                if (issue.imageUrl != null)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(issue.imageUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                Text(issue.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                SizedBox(height: 8),
                Text(issue.ticketId, style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoChip(issue.category, Icons.category_rounded, Color(0xFF4F46E5)),
                    SizedBox(width: 8),
                    _buildStatusChip(issue.status),
                  ],
                ),
                SizedBox(height: 20),
                Text('Description', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                SizedBox(height: 8),
                Text(issue.description, style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.6)),
                SizedBox(height: 20),
                _buildInfoRow('Reported', DateFormat('MMM dd, yyyy').format(issue.createdAt)),
                SizedBox(height: 12),
                _buildInfoRow('Location', issue.location?.toString() ?? 'Not specified'),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.4), blurRadius: 16, offset: Offset(0, 6)),
                    ],
                  ),
                  child: Text(
                    'View Full Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Resolved':
        color = Color(0xFF10B981);
        break;
      case 'In Progress':
        color = Color(0xFF4F46E5);
        break;
      case 'Reported':
        color = Color(0xFFF59E0B);
        break;
      default:
        color = Color(0xFFEF4444);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Text(status, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(fontSize: 14, color: Color(0xFF1E293B), fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFD1D5DB).withOpacity(0.3)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
