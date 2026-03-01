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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Status updated')));
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comment added')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue Management'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(widget.issue.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                StatusBadge(status: widget.issue.status),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Ticket ID', widget.issue.ticketId),
            _buildInfoRow('Category', widget.issue.category),
            _buildInfoRow('Reported On', DateFormat('MMM dd, yyyy hh:mm a').format(widget.issue.createdAt)),
            const SizedBox(height: 24),
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.issue.description),
            if (widget.issue.imageUrl != null) ...[
              const SizedBox(height: 24),
              const Text('Image', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Image.network(widget.issue.imageUrl!, height: 300, fit: BoxFit.cover),
            ],
            const SizedBox(height: 32),
            const Text('Update Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: AppConstants.statuses.map((status) {
                return ElevatedButton(
                  onPressed: widget.issue.status != status ? () => _updateStatus(status) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.getStatusColor(status),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(status),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Text('Add Comment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Enter comment',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addComment,
                  child: const Text('Add Comment'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            StreamBuilder<List<IssueUpdate>>(
              stream: _firestoreService.getIssueUpdates(widget.issue.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final updates = snapshot.data!;
                if (updates.isEmpty) return const Text('No updates yet');

                return Column(
                  children: updates.map((update) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          update.type == 'status_change' ? Icons.update : Icons.comment,
                          color: Colors.blue,
                        ),
                        title: Text(update.message),
                        subtitle: Text(DateFormat('MMM dd, yyyy hh:mm a').format(update.timestamp)),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
