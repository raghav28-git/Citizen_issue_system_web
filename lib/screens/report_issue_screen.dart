import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/issue.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../widgets/sidebar.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _firestoreService = FirestoreService();
  final _storageService = StorageService();
  
  String _selectedCategory = AppConstants.categories[0];
  Uint8List? _imageData;
  String? _imageName;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _imageData = result.files.first.bytes;
        _imageName = result.files.first.name;
      });
    }
  }

  Future<void> _submitIssue() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields')));
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? imageUrl;

    if (_imageData != null && _imageName != null) {
      imageUrl = await _storageService.uploadImage(_imageData!, _imageName!);
    }

    GeoPoint? location;
    if (_latController.text.isNotEmpty && _lngController.text.isNotEmpty) {
      location = GeoPoint(double.parse(_latController.text), double.parse(_lngController.text));
    }

    final issueId = _firestoreService.generateId();
    final issue = Issue(
      id: issueId,
      ticketId: _firestoreService.generateTicketId(),
      title: _titleController.text,
      description: _descriptionController.text,
      category: _selectedCategory,
      location: location,
      status: 'Reported',
      reportedBy: authProvider.currentUser!.uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      imageUrl: imageUrl,
    );

    await _firestoreService.addIssue(issue);
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Issue reported successfully')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Issue'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: const AppSidebar(currentRoute: '/report'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Report a New Issue', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                items: AppConstants.categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title *', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Description *', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _latController,
                      decoration: const InputDecoration(labelText: 'Latitude (optional)', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _lngController,
                      decoration: const InputDecoration(labelText: 'Longitude (optional)', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: Text(_imageName ?? 'Upload Image (optional)'),
              ),
              if (_imageName != null) ...[
                const SizedBox(height: 8),
                Text('Selected: $_imageName', style: const TextStyle(color: Colors.green)),
              ],
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitIssue,
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                      child: const Text('Submit Issue'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
