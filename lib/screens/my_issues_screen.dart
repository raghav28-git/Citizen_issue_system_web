import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/issue.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';
import '../widgets/sidebar.dart';
import '../widgets/status_badge.dart';
import 'issue_detail_screen.dart';

class MyIssuesScreen extends StatelessWidget {
  const MyIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Issues'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: const AppSidebar(currentRoute: '/my-issues'),
      body: StreamBuilder<List<Issue>>(
        stream: firestoreService.getIssuesByUser(authProvider.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No issues reported yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/report'),
                    child: const Text('Report Your First Issue'),
                  ),
                ],
              ),
            );
          }

          final issues = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: issues.length,
            itemBuilder: (context, index) {
              final issue = issues[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(issue.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('Category: ${issue.category}'),
                      Text('Ticket: ${issue.ticketId}'),
                      Text('Date: ${DateFormat('MMM dd, yyyy').format(issue.createdAt)}'),
                    ],
                  ),
                  trailing: StatusBadge(status: issue.status),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => IssueDetailScreen(issue: issue)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
