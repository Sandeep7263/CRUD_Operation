import 'package:flutter/material.dart';
import '../Data/network/NetworkApiServices.dart';

class DeleteUserViewModel with ChangeNotifier {
  final NetworkApiServices _apiServices = NetworkApiServices();

  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>> deleteUser(int userId) async {
    setLoading(true);
    try {
      final url = 'http://64.227.136.129/api/v1/admin/user/$userId';
      final response = await _apiServices.deleteApiResponse(url);
      setLoading(false);
      return Map<String, dynamic>.from(response);
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }
}
