import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationDetails extends StatelessWidget {
  final String title;

  const NotificationDetails({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Text(this.title),
      ),
    );
  }
}
