import 'package:flutter/material.dart';
import 'package:shuttle_stalk/res/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shuttle_stalk/res/layout/bottom_nav_layout.dart';
import 'package:shuttle_stalk/view/authentication/login_view.dart';
import 'package:shuttle_stalk/view_model/authentication_view_model.dart';

import '../notification/notification_list_view.dart';
class Booking extends StatefulWidget {
  const Booking({ super.key });

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Text("My Bookings"),
      ),
    );
  }

}