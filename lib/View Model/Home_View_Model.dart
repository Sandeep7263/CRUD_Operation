import 'package:flutter/cupertino.dart';
import '../Data/response/Api_Response.dart';
import '../Models/Userfetch_Model.dart';
import '../Repository/Home_Repository.dart';
import '../Data/response/status.dart';

class HomeViewModel with ChangeNotifier {
  final _myRepo = HomeRepository();

  ApiResponse<List<UserFetchModel>> userList = ApiResponse.loading();

  // Full list of users
  List<UserFetchModel> allUsers = [];

  // Filtered list based on search
  List<UserFetchModel> filteredList = [];

  setUserList(ApiResponse<List<UserFetchModel>> response) {
    userList = response;
    if (response.status == Status.Completed) {
      allUsers = response.data ?? [];
      filteredList = allUsers;
    }
    notifyListeners();
  }

  Future<void> fetchUserApi() async {
    setUserList(ApiResponse.loading());
    _myRepo.fetchUserApi().then((value) {
      setUserList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setUserList(ApiResponse.error(error.toString()));
    });
  }

  // Method to filter users by username
  void filterUsers(String keyword) {
    if (keyword.isEmpty) {
      filteredList = allUsers;
    } else {
      filteredList = allUsers
          .where((user) =>
          user.username.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
