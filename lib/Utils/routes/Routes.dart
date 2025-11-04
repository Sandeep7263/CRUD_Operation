import 'package:crud_operation/View/Splash_Screen.dart';
import 'package:flutter/material.dart';

import '../../Models/Create_User_Model.dart';
import '../../View/Additional_Info_Screen.dart';
import '../../View/Create_User_Screen.dart';
import '../../View/Home_Screen.dart';
import '../../View/Profile_Screen.dart';
import 'Routes_Name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RouteName.splashscreen:
        return MaterialPageRoute(builder: (_) =>  SplashScreen());
      case RouteName.homescreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case RouteName.userscreen:
        return MaterialPageRoute(builder: (_) => CreateUserScreen());

      case RouteName.additionalinfo:
        if (args is Map && args['user'] is CreateUserModel) {
          return MaterialPageRoute(
            builder: (_) => AdditionalInfoScreen(
              user: args['user'] as CreateUserModel,
            ),
          );
        }
        return _errorRoute('Invalid arguments for AdditionalInfoScreen');

      case RouteName.profilescreen:
        if (args is Map && args['user'] is CreateUserModel) {
          return MaterialPageRoute(
            builder: (_) => ProfileScreen(
              user: args['user'] as CreateUserModel,
            ),
          );
        }
        return _errorRoute('Invalid arguments for ProfileScreen');

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Routing Error')),
        body: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
