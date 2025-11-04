// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import '../Models/Create_User_Model.dart';
//
// class UpdateUserRepository {
//   final String token;
//
//   UpdateUserRepository({required this.token});
//
//   Future<Map<String, dynamic>> updateUser(CreateUserModel user) async {
//     final String url = "http://64.227.136.129/api/v1/admin/user/${user.id}";
//
//     try {
//       final response = await http.put(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(user.toJson()),
//       ).timeout(const Duration(seconds: 10));
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception('Failed to update user: ${response.body}');
//       }
//     } on SocketException {
//       throw Exception('No Internet Connection');
//     }
//   }
// }
