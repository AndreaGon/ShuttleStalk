import 'package:flutter/material.dart';
import 'package:shuttle_stalk/view/authentication/login_view.dart';
import 'package:shuttle_stalk/view/authentication/registration_view.dart';

class MainRouter {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/login':
        return MaterialPageRoute(builder: (_)=> Login());
      case '/registration':
        return MaterialPageRoute(builder: (_) => Registration());
      default:
        return MaterialPageRoute(builder: (_)=> Registration());
    }
  }
}