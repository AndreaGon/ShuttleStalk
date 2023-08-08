import 'package:flutter/material.dart';

import '../res/layout/bottom_nav_layout.dart';
import 'booking/booking_view.dart';
import 'home/home_view.dart';
import 'notification/notification_list_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int selectedIndex = 0;
  List page = [
    Home(),
    Booking(),
    NotificationList()
  ];

  //Functions

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: page[selectedIndex],
      bottomNavigationBar: BottomNavLayout(selectedIndex: selectedIndex, onClicked: onClicked),
    );
  }
}
