import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shuttle_stalk/view/authentication/login_view.dart';
import 'package:shuttle_stalk/view/authentication/registration_view.dart';
import 'package:shuttle_stalk/res/colors.dart';
import 'package:shuttle_stalk/utils/router.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ShuttleStalk());
}

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