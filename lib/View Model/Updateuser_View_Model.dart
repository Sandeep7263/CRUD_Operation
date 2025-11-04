import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class UpdateUserViewModel extends ChangeNotifier {
  Future<void> updateUserApi(int userId, Map<String, dynamic> body) async {
    final url = Uri.parse('http://64.227.136.129/api/v1/admin/user/$userId');
    final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IlJhamFuaSIsInNlY3JldCI6InRlc3QiLCJwYXNzd29yZCI6IlJhamFuaUAwMTEyIiwicm9sZSI6IkVtcGxveWVlIiwiaWQiOjM1LCJ1c2VyVHlwZSI6ImFkbWluIiwicm9sZUlkIjo0LCJ1c2VyX2FjY2VzcyI6InVzZXIiLCJjb21wYW55IjoiS29mZmVlS29kZXMgSW5ub3ZhdGlvbnMgUFZUIExURCIsImlhdCI6MTc1ODE3NDgxMCwiZXhwIjoxNzYwNzY2ODEwLCJhdWQiOiJhZG1pbiIsImlzcyI6ImFkbWluIiwic3ViIjoiYWRtaW4ifQ.7x0ePgJ8r95hNm-2v9nm2AtzV6h5ubZOwLt7phpT_Mw';
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // if needed
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update user: ${response.body}");
    }
  }
}
