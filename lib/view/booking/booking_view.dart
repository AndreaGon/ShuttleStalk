import 'package:flutter/material.dart';
import 'package:shuttle_stalk/res/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shuttle_stalk/res/layout/booking_dropdown_layout.dart';
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

    List<String> list = <String>['One', 'Two', 'Three', 'Four'];
    String dropdownValue = list.first;

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 75,
          automaticallyImplyLeading: false,
          title: Center(child: Text("Book a Shuttle",style: TextStyle(color:Colors.white,fontSize:20, fontWeight: FontWeight.bold))),
          backgroundColor: lightblue
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 25, right: 20, top: 30), //apply padding to all four sides
              child: Text("I want to book...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
          ),

          Padding(
              padding: EdgeInsets.only(bottom: 30, left: 25, right: 20, top: 10), //apply padding to all four sides
              child: BookingDropdownLayout(items: list)
          ),

          Padding(
              padding: EdgeInsets.only(bottom: 5, left: 25, right: 20), //apply padding to all four sides
              child: Text("For...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
          ),

          Padding(
              padding: EdgeInsets.only(bottom: 30, left: 25, right: 20, top: 5), //apply padding to all four sides
              child: BookingDropdownLayout(items: list)
          ),

          Padding(
              padding: EdgeInsets.only(bottom: 5, left: 25, right: 20), //apply padding to all four sides
              child: Text("On this time...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
          ),

          Padding(
              padding: EdgeInsets.only(bottom: 30, left: 25, right: 20, top: 10), //apply padding to all four sides
              child: BookingDropdownLayout(items: list)
          ),

          Padding(
              padding: EdgeInsets.only(bottom: 5, left: 25, right: 20), //apply padding to all four sides
              child: Text("At location...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
          ),

          Padding(
              padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 10), //apply padding to all four sides
              child: BookingDropdownLayout(items: list)
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 30),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              child: ElevatedButton(
                child: Text("Confirm Booking"),
                style: ElevatedButton.styleFrom(
                  primary: lightblue,
                  elevation: 0,
                ),
                onPressed: () {},
              ),
            )
          )
        ],
      )
    );
  }

}