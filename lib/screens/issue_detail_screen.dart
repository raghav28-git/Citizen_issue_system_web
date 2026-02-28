import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/issue.dart';
import '../models/issue_update.dart';
import '../services/firestore_service.dart';
import '../widgets/status_badge.dart';

class IssueDetailScreen extends StatelessWidget {
  final Issue issue;

  const IssueDetailScreen({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue Details'),
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
                Expanded(child: Text(issue.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                StatusBadge(status: issue.status),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Ticket ID', issue.ticketId),
            _buildInfoRow('Category', issue.category),
            _buildInfoRow('Reported On', DateFormat('MMM dd, yyyy hh:mm a').format(issue.createdAt)),
            _buildInfoRow('Last Updated', DateFormat('MMM dd, yyyy hh:mm a').format(issue.updatedAt)),
            const SizedBox(height: 24),
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(issue.description),
            if (issue.imageUrl != null) ...[
              const SizedBox(height: 24),
              const Text('Image', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Image.network(issue.imageUrl!, height: 300, fit: BoxFit.cover),
            ],
            if (issue.location != null) ...[
              const SizedBox(height: 24),
              const Text('Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Lat: ${issue.location!.latitude}, Lng: ${issue.location!.longitude}'),
            ],
            const SizedBox(height: 32),
            const Text('Status Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            StreamBuilder<List<IssueUpdate>>(
              stream: firestoreService.getIssueUpdates(issue.id),
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
