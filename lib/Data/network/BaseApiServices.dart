abstract class BaseApiServices {

  Future<dynamic> getApiResponse(String url);
  Future<dynamic> createUserApiResponse(String url,dynamic data);
}