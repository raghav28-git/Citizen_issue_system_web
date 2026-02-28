class IssueUpdate {
  final String id;
  final String issueId;
  final String message;
  final String updatedBy;
  final DateTime timestamp;
  final String type;

  IssueUpdate({
    required this.id,
    required this.issueId,
    required this.message,
    required this.updatedBy,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'issueId': issueId,
      'message': message,
      'updatedBy': updatedBy,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
    };
  }

  factory IssueUpdate.fromMap(String id, Map<String, dynamic> map) {
    return IssueUpdate(
      id: id,
      issueId: map['issueId'],
      message: map['message'],
      updatedBy: map['updatedBy'],
      timestamp: DateTime.parse(map['timestamp']),
      type: map['type'],
    );
  }
}
