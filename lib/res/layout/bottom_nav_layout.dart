import 'package:flutter/material.dart';

class BottomNavLayout extends StatelessWidget {
  final selectedIndex;
  ValueChanged<int> onClicked;

  BottomNavLayout({Key? key,this.selectedIndex, required this.onClicked}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airport_shuttle_rounded),
            label: 'Book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile'
          ),
        ],
        currentIndex: selectedIndex, //New
        onTap: onClicked
    );
  }
}
