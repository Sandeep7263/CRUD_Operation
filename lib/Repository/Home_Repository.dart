import 'package:crud_operation/Data/network/BaseApiServices.dart';
import 'package:crud_operation/Data/network/NetworkApiServices.dart';
import 'package:crud_operation/Models/Userfetch_Model.dart';
import 'package:crud_operation/Res/App_Url.dart';

class HomeRepository {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<List<UserFetchModel>> fetchUserApi() async {
    try {
      dynamic response = await _apiServices.getApiResponse(AppUrl.userFetchEndpoint);

      // response['data']['data'] is the list of users
      List<UserFetchModel> users = (response['data']['data'] as List)
          .map((e) => UserFetchModel.fromJson(e))
          .toList();

      return users;
    } catch (e) {
      throw e;
    }
  }


}
