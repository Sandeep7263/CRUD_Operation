import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/http.dart' as client;
import '../response/App_Excaptions.dart';
import 'BaseApiServices.dart';

class NetworkApiServices extends BaseApiServices {
  NetworkApiServices();

  final String token ='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IlJhamFuaSIsInNlY3JldCI6InRlc3QiLCJwYXNzd29yZCI6IlJhamFuaUAwMTEyIiwicm9sZSI6IkVtcGxveWVlIiwiaWQiOjM1LCJ1c2VyVHlwZSI6ImFkbWluIiwicm9sZUlkIjo0LCJ1c2VyX2FjY2VzcyI6InVzZXIiLCJjb21wYW55IjoiS29mZmVlS29kZXMgSW5ub3ZhdGlvbnMgUFZUIExURCIsImlhdCI6MTc1ODE3NDgxMCwiZXhwIjoxNzYwNzY2ODEwLCJhdWQiOiJhZG1pbiIsImlzcyI6ImFkbWluIiwic3ViIjoiYWRtaW4ifQ.7x0ePgJ8r95hNm-2v9nm2AtzV6h5ubZOwLt7phpT_Mw';

  @override
  Future getApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future createUserApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      Response response = await http
          .post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> uploadImageApiResponse(String url, Map<String, dynamic> data, File file) async {
    dynamic responseJson;
    try {
      // Multipart formData
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });
      request.fields['entity_id'] = data['entity_id'].toString();
      request.fields['entity_type'] = data['entity_type'];
      request.files.add(await http.MultipartFile.fromPath('path', file.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }




  Future<dynamic> deleteApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http
          .delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      )
          .timeout(const Duration(seconds: 10));

      // If server returns 200 or 204, consider it success
      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body.isNotEmpty) {
          responseJson = jsonDecode(response.body);
        } else {
          responseJson = {"status": "success", "message": "Deleted successfully"};
        }
      } else {
        responseJson = returnResponse(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }


  Future updateApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await http
          .put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future putApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await http
          .put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }


  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      case 400:
        throw BadRequestException(response.body.toString());

      case 401:
        throw UnauthorizeException("Unauthorized Request: ${response.body}");

      case 500:
      case 404:
        throw FetchDataException(
            'Server Error: ${response.statusCode} ${response.body}');

      default:
        throw FetchDataException(
            'Error occurred while communicating with server: ${response.statusCode}');
    }
  }
}
