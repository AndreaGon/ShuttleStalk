import 'package:flutter/material.dart';
import 'package:shuttle_stalk/view/authentication/login_view.dart';
import 'package:shuttle_stalk/view/authentication/registration_view.dart';
import 'package:shuttle_stalk/view/booking/booking_view.dart';
import 'package:shuttle_stalk/view/notification/notification_list_view.dart';

class MainRouter {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/login':
        return MaterialPageRoute(builder: (_)=> Login());
      case '/registration':
        return MaterialPageRoute(builder: (_) => Registration());
      case '/my-bookings':
        return MaterialPageRoute(builder: (_) => Booking());
      case '/notification-list':
        return MaterialPageRoute(builder: (_) => NotificationList());
      default:
        return MaterialPageRoute(builder: (_)=> Registration());
    }
  }
}