import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuttle_stalk/res/colors.dart';

import '../../res/layout/booking_card_layout.dart';
import '../../view_model/authentication/authentication_view_model.dart';
import '../../view_model/booking/booking_view_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthenticationVM authVM = AuthenticationVM();
  BookingVM bookingVM = BookingVM();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        backgroundColor: lightblue,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                  crossAxisAlignment : CrossAxisAlignment.start,
                  children : [
                    Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 100.0, left: 40.0),
                            child: Container(
                              child: Text("Hey there!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
                            )
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50.0, left: 60.0),
                      child: Icon(
                        Icons.emoji_transportation,
                        color: Colors.white,
                        size: 120.0,
                      ),
                    )
                  ]
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: Container(
                        height: 530,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            )
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 50.0, left: 40.0, right: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: Text("My Shuttle Booking", style: TextStyle(color: darkblue, fontWeight: FontWeight.bold, fontSize: 20.0),)
                              ),

                              FutureBuilder(
                                future: authVM.getCurrentUser(FirebaseAuth.instance.currentUser!.uid),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if(!snapshot.hasData) {
                                    return Center(child: CircularProgressIndicator());
                                  }

                                  var currentUser;
                                  currentUser = snapshot.data?.docs.map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>).toList();
                                  return StreamBuilder(
                                      stream: bookingVM.getAllBookingsStudentId(currentUser[0]["id"]),
                                      builder: (context, AsyncSnapshot snapshot){
                                        if(!snapshot.hasData) {
                                          return Center(child: CircularProgressIndicator());
                                        }

                                        if(snapshot.data.docs.length == 0){
                                          return Padding(
                                            padding: EdgeInsets.only(top: 20.0),
                                            child:  Container(
                                              height: 50,
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 7,
                                                    offset: Offset(0, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                  padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                                                  child: Text("No Bookings Yet!", style: TextStyle(color: darkblue, fontSize: 15.0))
                                              ),
                                            ),
                                          );
                                        }
                                        return Expanded(child: ListView.builder(
                                            padding: const EdgeInsets.all(8),
                                            itemCount:  snapshot.data?.docs.length,
                                            itemBuilder: (context, index) {
                                              var bookingInfo;
                                              DateTime dateToday = DateTime.now();
                                              String formattedDate = DateFormat("yyyy-MM-dd").format(dateToday);

                                              bookingInfo = snapshot.data?.docs.map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>).toList();
                                              return BookingCardLayout(
                                                routeName: bookingInfo[index]["routeName"],
                                                bookingTime: bookingInfo[index]["time"],
                                                pickupDropoff: bookingInfo[index]["pickupDropoff"].toUpperCase(),
                                                sourceLocation: bookingInfo[index]["route"],
                                                bookingId: bookingInfo[index]["id"],
                                                bookingDate: bookingInfo[index]["date"],
                                                routeId: bookingInfo[index]["routeId"],
                                              );
                                            })
                                        );
                                      }
                                  );
                                }
                              )
                            ],
                          ),
                        )
                    )//Your widget here,
                ),
              ),
            ),
          ],
        )
    );
  }
}
