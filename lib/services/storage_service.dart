import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(Uint8List imageData, String fileName) async {
    try {
      final ref = _storage.ref().child('issue_images/$fileName');
      await ref.putData(imageData);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}
