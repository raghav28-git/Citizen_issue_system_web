import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/issue.dart';
import '../services/firestore_service.dart';
import '../widgets/sidebar.dart';
import '../widgets/status_badge.dart';
import '../utils/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: const AppSidebar(currentRoute: '/dashboard'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, int>>(
              future: _firestoreService.getIssueCounts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final counts = snapshot.data!;
                return Row(
                  children: [
                    _buildStatCard('Total Issues', counts['total']!, Colors.blue),
                    const SizedBox(width: 16),
                    _buildStatCard('Reported', counts['reported']!, Colors.orange),
                    const SizedBox(width: 16),
                    _buildStatCard('In Progress', counts['inProgress']!, Colors.blue),
                    const SizedBox(width: 16),
                    _buildStatCard('Resolved', counts['resolved']!, Colors.green),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('All Issues', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    DropdownButton<String>(
                      hint: const Text('Filter by Status'),
                      value: _filterStatus,
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Statuses')),
                        ...AppConstants.statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))),
                      ],
                      onChanged: (val) => setState(() => _filterStatus = val),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      hint: const Text('Filter by Category'),
                      value: _filterCategory,
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Categories')),
                        ...AppConstants.categories.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                      ],
                      onChanged: (val) => setState(() => _filterCategory = val),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<Issue>>(
              stream: _filterStatus != null
                  ? _firestoreService.getIssuesByStatus(_filterStatus!)
                  : _filterCategory != null
                      ? _firestoreService.getIssuesByCategory(_filterCategory!)
                      : _firestoreService.getAllIssues(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final issues = snapshot.data!;
                if (issues.isEmpty) return const Text('No issues found');

                return DataTable(
                  columns: const [
                    DataColumn(label: Text('Ticket ID')),
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Date')),
                  ],
                  rows: issues.map((issue) {
                    return DataRow(
                      cells: [
                        DataCell(Text(issue.ticketId)),
                        DataCell(Text(issue.title)),
                        DataCell(Text(issue.category)),
                        DataCell(StatusBadge(status: issue.status)),
                        DataCell(Text(DateFormat('MMM dd, yyyy').format(issue.createdAt))),
                      ],
                      onSelectChanged: (_) => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AdminIssueDetailScreen(issue: issue)),
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

  Widget _buildStatCard(String title, int count, Color color) {
    return Expanded(
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(count.toString(), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
