import 'package:crud_operation/View%20Model/Createuser_View_Model.dart';
import 'package:crud_operation/View%20Model/Home_View_Model.dart';
import 'package:crud_operation/View%20Model/Imageupload_View_Model.dart';
import 'package:crud_operation/View%20Model/Updateuser_View_Model.dart' hide UpdateUserRepository;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Repository/Update_User_Repository.dart';
import 'Utils/routes/Routes.dart';
import 'Utils/routes/Routes_Name.dart';
import 'View Model/Delete_View_Model.dart';
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=> HomeViewModel()),
      ChangeNotifierProvider(create: (_)=> CreateuserViewModel()),
      // ChangeNotifierProvider(create: (_)=> UpdateUserRepository()),
      ChangeNotifierProvider(create: (_)=> DeleteUserViewModel()),
      ChangeNotifierProvider(create: (_)=> ImageUploadViewModel()),

      
    ],


    child: MaterialApp(
title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,

      ),

      initialRoute: RouteName.splashscreen,
      onGenerateRoute: Routes.generateRoute,
      navigatorObservers: [routeObserver],
    ),
    );
  }
}

