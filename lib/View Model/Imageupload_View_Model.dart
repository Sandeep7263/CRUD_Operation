import 'dart:io';
import 'package:flutter/material.dart';
import '../Models/Image_Upload_Model.dart';
import '../Repository/Image_Upload_Repository.dart';

class ImageUploadViewModel with ChangeNotifier {
  final ImageUploadRepository _repository = ImageUploadRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ImageUploadModel? _uploadResponse;
  ImageUploadModel? get uploadResponse => _uploadResponse;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> uploadImage({
    required File file,
    required String entityId,
    required String entityType,
  }) async {
    setLoading(true);
    try {
      final response = await _repository.uploadImage(
        file: file,
        entityId: entityId,
        entityType: entityType,
      );
      _uploadResponse = response;
      debugPrint("✅ Upload success: ${response.message}");
    } catch (e, s) {
      debugPrint("❌ Upload failed: $e");
      debugPrintStack(stackTrace: s);
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
