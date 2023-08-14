import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuttle_stalk/res/colors.dart';
import 'package:shuttle_stalk/view/notification/layout/notif_card_layout.dart';
import 'package:shuttle_stalk/view_model/notification/notification_view_model.dart';

class NotificationList extends StatefulWidget {
  static final routeName = "/notification-list";

  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {

  final NotificationVM notifVM = NotificationVM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 75,
          automaticallyImplyLeading: false,
          title: Center(child: Text("Notifications",style: TextStyle(color:Colors.white,fontSize:20, fontWeight: FontWeight.bold))),
          backgroundColor: lightblue
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StreamBuilder(
              stream: notifVM.getAllAnnouncements(),
              builder: (context, AsyncSnapshot snapshot){
                if(!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return Expanded(child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount:  snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      //map data into book model
                      Map<String, dynamic> notifModel = snapshot.data
                          ?.docs[index].data();

                      var date = DateTime.fromMillisecondsSinceEpoch(notifModel["timestamp"]);
                      String formattedDate = DateFormat('dd MMMM, yyy').format(date);

                      return NotifCardLayout(title: notifModel["title"],
                          snippet: notifModel["content"],
                          date: formattedDate);
                    })
                );
              }
          )
          //Expanded(child: NotifCardLayout(title: "This is a notification", snippet: "This is a sample snippet with a very long description", date: "date"))
        ],
      )
    );
  }
}
