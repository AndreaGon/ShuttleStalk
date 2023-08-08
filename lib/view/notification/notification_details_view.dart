import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuttle_stalk/res/colors.dart';

class NotificationDetails extends StatelessWidget {
  final String title;
  final String content;
  final String datetime;

  const NotificationDetails({Key? key, required this.title, required this.content, required this.datetime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: lightblue,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 10, top: 30, left: 25), //apply padding to all four sides
                child: Text(this.datetime, style: TextStyle(fontSize: 13, color: Colors.black54))
            ),

            Padding(
                padding: EdgeInsets.only(bottom: 5, left: 25, right: 20), //apply padding to all four sides
                child: Text(this.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            ),

            Padding(
                padding: EdgeInsets.only(bottom: 5, top: 20, left: 25, right: 20), //apply padding to all four sides
                child: Text(this.content, style: TextStyle(fontSize: 15))
            ),
          ],
        )
    );
  }
}
