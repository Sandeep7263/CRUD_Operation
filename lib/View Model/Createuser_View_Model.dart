import 'package:flutter/material.dart';
import '../Models/Create_User_Model.dart';
import '../Repository/User_Create_Repository.dart';

class CreateuserViewModel with ChangeNotifier {
  final UserCreateRepository _repository = UserCreateRepository();

  // 🔹 Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 🔹 API response
  Map<String, dynamic>? _response;
  Map<String, dynamic>? get response => _response;

  // 🔹 Set loading and notify listeners
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// 🔹 Create user API
  /// Updates `_response` after completion
  Future<void> createUser(CreateUserModel user) async {
    setLoading(true);
    try {
      // Call repository to create user
      final Map<String, dynamic> result = await _repository.createUser(user);
      _response = result;
    } catch (e) {
      _response = {
        "success": false,
        "message": e.toString(),
      };
    } finally {
      setLoading(false);
      notifyListeners(); // notify after loading complete
    }
  }

  /// 🔹 Clear previous response
  void clearResponse() {
    _response = null;
    notifyListeners();
  }
}
