import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationList extends StatefulWidget {
  static final routeName = "/notification-list";

  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 40, left: 20),
            padding: EdgeInsets.all(8.0),
            child: Text("Notifications",style: TextStyle(color:Colors.black,fontSize:30, fontWeight: FontWeight.bold),),
          ),
        ],
      )
    );
  }
}
