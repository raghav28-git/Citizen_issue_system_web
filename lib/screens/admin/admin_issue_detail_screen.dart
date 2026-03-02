import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/issue.dart';
import '../../models/issue_update.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../widgets/status_badge.dart';
import '../../utils/constants.dart';

class AdminIssueDetailScreen extends StatefulWidget {
  final Issue issue;

  const AdminIssueDetailScreen({super.key, required this.issue});

  @override
  State<AdminIssueDetailScreen> createState() => _AdminIssueDetailScreenState();
}

class _AdminIssueDetailScreenState extends State<AdminIssueDetailScreen> {
  final _commentController = TextEditingController();
  final _firestoreService = FirestoreService();

  Future<void> _updateStatus(String newStatus) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await _firestoreService.updateIssueStatus(
      widget.issue.id,
      newStatus,
      authProvider.currentUser!.uid,
      'Status changed to $newStatus',
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text('Status updated to $newStatus', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await _firestoreService.addComment(
      widget.issue.id,
      _commentController.text,
      authProvider.currentUser!.uid,
    );
    _commentController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.comment_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text('Comment added successfully', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          backgroundColor: Color(0xFF4F46E5),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Issue Management', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w800, fontSize: 20)),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.confirmation_number_rounded, size: 18),
                SizedBox(width: 8),
                Text(widget.issue.ticketId, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIssueHeader(),
                  SizedBox(height: 24),
                  _buildIssueDetails(),
                  SizedBox(height: 24),
                  _buildStatusUpdateSection(),
                  SizedBox(height: 24),
                  _buildCommentSection(),
                ],
              ),
            ),
            SizedBox(width: 32),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildQuickInfo(),
                  SizedBox(height: 24),
                  _buildTimeline(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueHeader() {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 30, offset: Offset(0, 15)),
        ],
      ),
      child: Column(
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
                child: Icon(Icons.report_problem_rounded, color: Colors.white, size: 28),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.issue.title,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
                ),
              ),
              StatusBadge(status: widget.issue.status),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Text(
              widget.issue.description,
              style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.95), height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueDetails() {
    return Container(
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_rounded, color: Color(0xFF4F46E5), size: 24),
              SizedBox(width: 12),
              Text('Issue Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
            ],
          ),
          SizedBox(height: 24),
          _buildDetailRow(Icons.category_rounded, 'Category', widget.issue.category, Color(0xFF8B5CF6)),
          SizedBox(height: 16),
          _buildDetailRow(Icons.calendar_today_rounded, 'Reported On', DateFormat('MMM dd, yyyy hh:mm a').format(widget.issue.createdAt), Color(0xFF3B82F6)),
          if (widget.issue.location != null) ...[
            SizedBox(height: 16),
            _buildDetailRow(Icons.location_on_rounded, 'Location', '${widget.issue.location!.latitude}, ${widget.issue.location!.longitude}', Color(0xFFEF4444)),
          ],
          if (widget.issue.imageUrl != null) ...[
            SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.issue.imageUrl!,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 15, color: Color(0xFF0F172A), fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusUpdateSection() {
    return Container(
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.sync_rounded, color: Colors.white, size: 20),
              ),
              SizedBox(width: 12),
              Text('Update Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
            ],
          ),
          SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppConstants.statuses.map((status) {
              final isActive = widget.issue.status == status;
              return MouseRegion(
                cursor: isActive ? SystemMouseCursors.basic : SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: isActive ? null : () => _updateStatus(status),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: isActive ? LinearGradient(colors: [_getStatusColor(status), _getStatusColor(status).withOpacity(0.8)]) : null,
                      color: isActive ? null : _getStatusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _getStatusColor(status).withOpacity(isActive ? 0 : 0.3), width: 2),
                      boxShadow: isActive ? [
                        BoxShadow(color: _getStatusColor(status).withOpacity(0.4), blurRadius: 16, offset: Offset(0, 6)),
                      ] : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getStatusIcon(status), color: isActive ? Colors.white : _getStatusColor(status), size: 20),
                        SizedBox(width: 10),
                        Text(
                          status,
                          style: TextStyle(
                            color: isActive ? Colors.white : _getStatusColor(status),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        if (isActive) ...[
                          SizedBox(width: 8),
                          Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    return Container(
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.comment_rounded, color: Color(0xFF10B981), size: 20),
              ),
              SizedBox(width: 12),
              Text('Add Comment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            controller: _commentController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter your comment or update...',
              hintStyle: TextStyle(color: Color(0xFF94A3B8)),
              filled: true,
              fillColor: Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(0xFF4F46E5), width: 2),
              ),
            ),
          ),
          SizedBox(height: 16),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _addComment,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Color(0xFF10B981).withOpacity(0.3), blurRadius: 16, offset: Offset(0, 6)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Text('Post Comment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfo() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEEF2FF), Color(0xFFF8FAFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.analytics_rounded, color: Color(0xFF4F46E5), size: 48),
          SizedBox(height: 16),
          Text('Quick Info', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
          SizedBox(height: 20),
          _buildQuickInfoItem('Ticket ID', widget.issue.ticketId, Icons.confirmation_number_rounded),
          Divider(height: 24),
          _buildQuickInfoItem('Category', widget.issue.category, Icons.category_rounded),
          Divider(height: 24),
          _buildQuickInfoItem('Status', widget.issue.status, Icons.flag_rounded),
        ],
      ),
    );
  }

  Widget _buildQuickInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF64748B), size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 14, color: Color(0xFF0F172A), fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline_rounded, color: Color(0xFF4F46E5), size: 24),
              SizedBox(width: 12),
              Text('Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
            ],
          ),
          SizedBox(height: 20),
          StreamBuilder<List<IssueUpdate>>(
            stream: _firestoreService.getIssueUpdates(widget.issue.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(color: Color(0xFF4F46E5), strokeWidth: 3));
              }
              final updates = snapshot.data!;
              if (updates.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Icon(Icons.history_rounded, size: 48, color: Color(0xFFCBD5E1)),
                      SizedBox(height: 12),
                      Text('No updates yet', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                    ],
                  ),
                );
              }

              return Column(
                children: updates.asMap().entries.map((entry) {
                  final index = entry.key;
                  final update = entry.value;
                  final isLast = index == updates.length - 1;
                  return _buildTimelineItem(update, isLast);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(IssueUpdate update, bool isLast) {
    final color = update.type == 'status_change' ? Color(0xFF4F46E5) : Color(0xFF10B981);
    final icon = update.type == 'status_change' ? Icons.sync_rounded : Icons.comment_rounded;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: Color(0xFFE2E8F0),
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(update.message, style: TextStyle(fontSize: 14, color: Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Text(
                  DateFormat('MMM dd, hh:mm a').format(update.timestamp),
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Reported': return Color(0xFFF59E0B);
      case 'In Progress': return Color(0xFF8B5CF6);
      case 'Resolved': return Color(0xFF10B981);
      case 'Rejected': return Color(0xFFEF4444);
      default: return Color(0xFF64748B);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Reported': return Icons.schedule_rounded;
      case 'In Progress': return Icons.sync_rounded;
      case 'Resolved': return Icons.check_circle_rounded;
      case 'Rejected': return Icons.cancel_rounded;
      default: return Icons.flag_rounded;
    }
  }
}
