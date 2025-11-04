
import '../Data/network/NetworkApiServices.dart';

import '../Models/Create_User_Model.dart';
import '../res/app_url.dart';

class UserCreateRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<Map<String, dynamic>> createUser(CreateUserModel user) async {
    try {
      final response = await _apiServices.createUserApiResponse(
        AppUrl.createPostEndpoint,
        user.toJson(),
      );
      return {"success": true, "message": "User created successfully"};
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
