

import 'dart:io';

import '../Data/network/NetworkApiServices.dart';
import '../Models/Image_Upload_Model.dart';
import '../Res/App_Url.dart';

class ImageUploadRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  /// Upload image API
  Future<ImageUploadModel> uploadImage({
    required File file,
    required String entityId,
    required String entityType,
  }) async {
    try {
      // Multipart data ke liye NetworkApiServices me uploadImageApiResponse method bana sakte ho
      final data = {
        'path': file.path, // ya MultipartFile jo bhi NetworkApiServices me handle ho
        'entity_id': entityId,
        'entity_type': entityType,
      };

      final response = await _apiServices.uploadImageApiResponse(
        AppUrl.uploadImageEndpoint,
        data,
        file,
      );

      return ImageUploadModel.fromJson(response);
    } catch (e) {
      throw Exception("Image upload failed: $e");
    }
  }
}
