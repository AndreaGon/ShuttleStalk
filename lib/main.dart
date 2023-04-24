import 'package:flutter/material.dart';
import 'package:shuttle_stalk/view/authentication/login_view.dart';
import 'package:shuttle_stalk/view/authentication/registration_view.dart';
import 'package:shuttle_stalk/res/colors.dart';
import 'package:shuttle_stalk/utils/router.dart';

void main() => runApp(ShuttleStalk());

class ShuttleStalk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shuttle Stalk',
      onGenerateRoute: MainRouter.generateRoute,
      theme: ThemeData(
        primaryColor: lightblue
      ),
      initialRoute: '/login'
    );
  }

}