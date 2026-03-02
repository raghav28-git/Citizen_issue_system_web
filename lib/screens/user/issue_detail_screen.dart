import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/issue.dart';
import '../../services/firestore_service.dart';
import '../../widgets/status_badge.dart';

class IssueDetailScreen extends StatelessWidget {
  final Issue issue;

  const IssueDetailScreen({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Issue Details', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w700, fontSize: 20)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Color(0xFFE2E8F0)),
                                  ),
                                  child: Text(issue.ticketId, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF4F46E5))),
                                ),
                                SizedBox(width: 12),
                                StatusBadge(status: issue.status),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(issue.title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.5)),
                            SizedBox(height: 24),
                            Text('Description', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
                            SizedBox(height: 12),
                            Text(issue.description, style: TextStyle(fontSize: 16, color: Color(0xFF475569), height: 1.6)),
                            if (issue.imageUrl != null) ...[
                              SizedBox(height: 32),
                              Text('Attached Image', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
                              SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  issue.imageUrl!,
                                  width: double.infinity,
                                  height: 400,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Issue Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                            SizedBox(height: 20),
                            _buildInfoItem(Icons.category_rounded, 'Category', issue.category, Color(0xFF8B5CF6)),
                            SizedBox(height: 16),
                            _buildInfoItem(Icons.calendar_today_rounded, 'Reported', DateFormat('MMM dd, yyyy').format(issue.createdAt), Color(0xFF4F46E5)),
                            SizedBox(height: 16),
                            _buildInfoItem(Icons.update_rounded, 'Last Update', DateFormat('MMM dd, yyyy').format(issue.updatedAt), Color(0xFF10B981)),
                            if (issue.location != null) ...[
                              SizedBox(height: 16),
                              _buildInfoItem(Icons.location_on_rounded, 'Location', '${issue.location!.latitude.toStringAsFixed(4)}, ${issue.location!.longitude.toStringAsFixed(4)}', Color(0xFFEF4444)),
                            ],
                          ],
                        ),
                      ),
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

  Widget _buildInfoItem(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
              SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 14, color: Color(0xFF0F172A), fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
