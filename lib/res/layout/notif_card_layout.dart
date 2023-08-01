import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuttle_stalk/view/notification/notification_details_view.dart';

class NotifCardLayout extends StatelessWidget {
  final String title;
  final String snippet;
  final String date;

  const NotifCardLayout({Key? key, required this.title, required this.snippet, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: ListTile(
              leading: Icon(Icons.notifications_active),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5), //apply padding to all four sides
                    child: Text(this.date, style: TextStyle(fontSize: 13))
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 5), //apply padding to all four sides
                      child: Text(this.title, style: TextStyle(fontSize: 17), overflow: TextOverflow.ellipsis,)
                  ),
                ],
              ),
              subtitle: Text(this.snippet, overflow: TextOverflow.ellipsis),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationDetails(title: this.title),
                  ),
                );
              },
            ),
          )
        ],
      ),

    );
  }
}
