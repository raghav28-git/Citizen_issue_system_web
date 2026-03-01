import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/issue.dart';
import '../models/issue_update.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  Future<void> addIssue(Issue issue) async {
    await _db.collection('issues').doc(issue.id).set(issue.toMap());
  }

  String generateTicketId() {
    return 'TKT${DateTime.now().millisecondsSinceEpoch}';
  }

  String generateId() {
    return _uuid.v4();
  }

  Stream<List<Issue>> getIssuesByUser(String uid) {
    return _db
        .collection('issues')
        .where('reportedBy', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
          final docs = snapshot.docs;
          docs.sort((a, b) {
            final aDate = DateTime.parse(a.data()['createdAt']);
            final bDate = DateTime.parse(b.data()['createdAt']);
            return bDate.compareTo(aDate);
          });
          return docs.map((doc) => Issue.fromMap(doc.id, doc.data())).toList();
        });
  }

  Stream<List<Issue>> getAllIssues() {
    return _db.collection('issues').snapshots().map((snapshot) {
      final issues = snapshot.docs.map((doc) => Issue.fromMap(doc.id, doc.data())).toList();
      issues.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return issues;
    });
  }

  Stream<List<Issue>> getIssuesByStatus(String status) {
    return _db.collection('issues').where('status', isEqualTo: status).snapshots().map((snapshot) {
      final issues = snapshot.docs.map((doc) => Issue.fromMap(doc.id, doc.data())).toList();
      issues.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return issues;
    });
  }

  Stream<List<Issue>> getIssuesByCategory(String category) {
    return _db.collection('issues').where('category', isEqualTo: category).snapshots().map((snapshot) {
      final issues = snapshot.docs.map((doc) => Issue.fromMap(doc.id, doc.data())).toList();
      issues.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return issues;
    });
  }

  Future<void> updateIssueStatus(String id, String status, String updatedBy, String message) async {
    await _db.collection('issues').doc(id).update({
      'status': status,
      'updatedAt': DateTime.now().toIso8601String(),
    });
    await addIssueUpdate(IssueUpdate(
      id: generateId(),
      issueId: id,
      message: message,
      updatedBy: updatedBy,
      timestamp: DateTime.now(),
      type: 'status_change',
    ));
  }

  Future<void> assignIssue(String id, String assignedTo, String updatedBy) async {
    await _db.collection('issues').doc(id).update({
      'assignedTo': assignedTo,
      'updatedAt': DateTime.now().toIso8601String(),
    });
    await addIssueUpdate(IssueUpdate(
      id: generateId(),
      issueId: id,
      message: 'Issue assigned to field officer',
      updatedBy: updatedBy,
      timestamp: DateTime.now(),
      type: 'assignment',
    ));
  }

  Future<void> addComment(String issueId, String comment, String updatedBy) async {
    await addIssueUpdate(IssueUpdate(
      id: generateId(),
      issueId: issueId,
      message: comment,
      updatedBy: updatedBy,
      timestamp: DateTime.now(),
      type: 'comment',
    ));
  }

  Future<void> addIssueUpdate(IssueUpdate update) async {
    await _db.collection('issue_updates').doc(update.id).set(update.toMap());
  }

  Stream<List<IssueUpdate>> getIssueUpdates(String issueId) {
    return _db
        .collection('issue_updates')
        .where('issueId', isEqualTo: issueId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => IssueUpdate.fromMap(doc.id, doc.data())).toList());
  }

  Future<Map<String, int>> getIssueCounts() async {
    final snapshot = await _db.collection('issues').get();
    final issues = snapshot.docs.map((doc) => Issue.fromMap(doc.id, doc.data())).toList();
    return {
      'total': issues.length,
      'reported': issues.where((i) => i.status == 'Reported').length,
      'inProgress': issues.where((i) => i.status == 'In Progress').length,
      'resolved': issues.where((i) => i.status == 'Resolved').length,
    };
  }

  Future<void> deleteIssue(String id) async {
    await _db.collection('issues').doc(id).delete();
  }
}
