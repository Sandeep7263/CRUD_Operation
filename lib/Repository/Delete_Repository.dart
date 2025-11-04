import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> deleteApiResponse(String url) async {
  // Define headers
  final headers = {
    "Content-Type": "application/json",
    "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IlJhamFuaSIsInNlY3JldCI6InRlc3QiLCJwYXNzd29yZCI6IlJhamFuaUAwMTEyIiwicm9sZSI6IkVtcGxveWVlIiwiaWQiOjM1LCJ1c2VyVHlwZSI6ImFkbWluIiwicm9sZUlkIjo0LCJ1c2VyX2FjY2VzcyI6InVzZXIiLCJjb21wYW55IjoiS29mZmVlS29kZXMgSW5ub3ZhdGlvbnMgUFZUIExURCIsImlhdCI6MTc1ODE3NDgxMCwiZXhwIjoxNzYwNzY2ODEwLCJhdWQiOiJhZG1pbiIsImlzcyI6ImFkbWluIiwic3ViIjoiYWRtaW4ifQ.7x0ePgJ8r95hNm-2v9nm2AtzV6h5ubZOwLt7phpT_Mw", // Uncomment if your API needs auth
  };

  final response = await http.delete(Uri.parse(url), headers: headers);

  if (response.statusCode == 200 || response.statusCode == 204) {
    return {"status": "success", "message": "User deleted successfully"};
  } else {
    throw Exception("Failed to delete user: ${response.body}");
  }
}
