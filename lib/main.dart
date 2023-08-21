import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuttle_stalk/services/local_notifications_service.dart';
import 'package:shuttle_stalk/view/authentication/login_view.dart';
import 'package:shuttle_stalk/view/authentication/registration_view.dart';
import 'package:shuttle_stalk/res/colors.dart';
import 'package:shuttle_stalk/utils/router.dart';

import 'firebase_options.dart';
import 'package:rxdart/rxdart.dart';

// TODO: Add stream controller
final _messageStreamController = BehaviorSubject<RemoteMessage>();

// TODO: Define the background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.title}');
  print('Message notification: ${message.notification?.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission();

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  String? token = await messaging.getToken();

  if (kDebugMode) {
    print('Registration Token=$token');
  }

  // TODO: Set up foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Handling a foreground message: ${message.messageId}');
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');

    _messageStreamController.sink.add(message);

    LocalNotificationService.display(message);
  });
  // TODO: Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.subscribeToTopic("announcements");

  runApp(ShuttleStalk());
}

class ShuttleStalk extends StatefulWidget {

  @override
  State<ShuttleStalk> createState() => _ShuttleStalkState();
}

class _ShuttleStalkState extends State<ShuttleStalk> {
  @override
  void initState() {
    super.initState();
    // Initialise  localnotification
    LocalNotificationService.initialize();
  }

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