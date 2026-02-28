import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'CityCare';
  
  static const List<String> categories = [
    'Road',
    'Garbage',
    'Water',
    'Electricity',
    'Drainage',
    'Other',
  ];

  static const List<String> statuses = [
    'Reported',
    'In Progress',
    'Resolved',
    'Rejected',
  ];

  static Color getStatusColor(String status) {
    switch (status) {
      case 'Reported':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Resolved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
