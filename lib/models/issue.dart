import 'package:cloud_firestore/cloud_firestore.dart';

class Issue {
  final String id;
  final String ticketId;
  final String title;
  final String description;
  final String category;
  final GeoPoint? location;
  final String status;
  final String reportedBy;
  final String? assignedTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;

  Issue({
    required this.id,
    required this.ticketId,
    required this.title,
    required this.description,
    required this.category,
    this.location,
    required this.status,
    required this.reportedBy,
    this.assignedTo,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'status': status,
      'reportedBy': reportedBy,
      'assignedTo': assignedTo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory Issue.fromMap(String id, Map<String, dynamic> map) {
    GeoPoint? location;
    try {
      if (map['location'] is GeoPoint) {
        location = map['location'];
      }
    } catch (e) {
      location = null;
    }

    return Issue(
      id: id,
      ticketId: map['ticketId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'Other',
      location: location,
      status: map['status'] ?? 'Reported',
      reportedBy: map['reportedBy'] ?? '',
      assignedTo: map['assignedTo'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : DateTime.now(),
      imageUrl: map['imageUrl'],
    );
  }
}
