import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuttle_stalk/models/bookings.dart';
import 'package:shuttle_stalk/models/locations.dart';
import 'package:shuttle_stalk/res/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shuttle_stalk/view/booking/layout/booking_dropdown_layout.dart';
import 'package:shuttle_stalk/res/layout/bottom_nav_layout.dart';
import 'package:shuttle_stalk/view/authentication/login_view.dart';
import 'package:shuttle_stalk/view_model/authentication/authentication_view_model.dart';
import 'package:shuttle_stalk/view_model/realtime/realtime_view_model.dart';

import '../../view_model/booking/booking_view_model.dart';
import '../notification/notification_list_view.dart';
class Booking extends StatefulWidget {
  const Booking({ super.key });

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {

  final BookingVM bookingVM = BookingVM();
  final RealTimeVM realtimeVM = RealTimeVM();
  final AuthenticationVM authVM = AuthenticationVM();

  DateTime dateToday = DateTime.now();

  bool isFirstPartVisible = true;
  bool isSecondPartVisible = false;
  bool isThirdPartVisible = false;
  List<Map<dynamic, dynamic>> listOfTime = [];
  List<Map<dynamic, dynamic>> listOfDays = [];
  List<Map<dynamic, dynamic>> listOfLocation = [];
  var shuttleData = {};

  Bookings currentBooking = Bookings(
      routeName: "",
      pickupDropoff: "",
      time: "",
      date: "",
      route: "",
      studentId: "",
      routeId: "",
      studentName: '',
      studentMatriculation: ''
  );

  Locations location = Locations(routeId: "", time: "", date: "", shuttleLocation: "", shuttlePlateNo: '', isJourneyStarted: false, driverId: '', routeName: '', pickupDropoff: '', bookingLocations: '');

  @override
  Widget build(BuildContext context) {

    listOfDays = [
      {"display": "- Select day -", "value": ""},
      {"display": "Tomorrow", "value": DateFormat("yyyy-MM-dd").format((dateToday.add(const Duration(days: 1))))},
      {"display": "2 days after", "value": DateFormat("yyyy-MM-dd").format((dateToday.add(const Duration(days: 2))))},
      {"display": "3 days after", "value": DateFormat("yyyy-MM-dd").format((dateToday.add(const Duration(days: 3))))},
    ];
    print(listOfDays);

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 75,
          automaticallyImplyLeading: false,
          title: Center(child: Text("Book a Shuttle",style: TextStyle(color:Colors.white,fontSize:20, fontWeight: FontWeight.bold))),
          backgroundColor: lightblue
      ),
      body: FutureBuilder(
        future: bookingVM.getRouteInfo(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Map<String, dynamic>> listOfShuttleNames = [{"display": "- Select a route -", "value": ""}];

          var pickupDropoff = [{"display": "- Select pickup or dropoff -", "value": ""},{"display": "Pickup", "value": "pickup"},{"display": "Dropoff", "value": "dropoff"}];

          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          else{
            for(int i = 0; i < snapshot.data.length; i++){
              listOfShuttleNames.add({"display": snapshot.data[i]["routeName"], "value": snapshot.data[i]["id"]});
            }
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: isFirstPartVisible,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 25, right: 20, top: 30), //apply padding to all four sides
                        child: Text("I want to book...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
                    ),

                    Padding(
                        padding: EdgeInsets.only(bottom: 30, left: 25, right: 20, top: 10), //apply padding to all four sides
                        child: BookingDropdownLayout(items: listOfShuttleNames, onItemSelected: (value) async => {
                          if(value != ""){
                            await bookingVM.getRouteInfoId(value).then((value) => {
                              shuttleData = value.data(),
                              currentBooking.routeName = shuttleData["routeName"]

                            }),
                            currentBooking.routeId = value

                          }
                          else{
                            currentBooking.routeName = "",
                            currentBooking.routeId = "",
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please select a route"),
                            ))
                          },
                        },)
                    ),

                    Padding(
                        padding: EdgeInsets.only(bottom: 5, left: 25, right: 20), //apply padding to all four sides
                        child: Text("For...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
                    ),

                    Padding(
                        padding: EdgeInsets.only(left: 25, right: 20, top: 5), //apply padding to all four sides
                        child: BookingDropdownLayout(items: pickupDropoff, onItemSelected: (value)=> {
                          setState(() {
                            listOfTime = [{"display": "- Select departure time -", "value": ""}];
                            listOfLocation = [{"display": "- Select location -", "value": ""}];

                            if(value == "pickup"){
                              for(int i = 0; i < shuttleData["pickupTime"].length; i++){
                                print(shuttleData);
                                var currentPickupTime = shuttleData["pickupTime"][i];
                                listOfTime.add({"display": currentPickupTime, "value": currentPickupTime});
                              }
                            }
                            else{
                              for(int i = 0; i < shuttleData["dropoffTime"].length; i++){
                                var currentDropoffTime = shuttleData["dropoffTime"][i];
                                listOfTime.add({"display": currentDropoffTime, "value": currentDropoffTime});
                              }
                            }

                            for(int i = 0; i < shuttleData["route"].length; i++){
                              listOfLocation.add({
                                "display":shuttleData["route"][i]["display"],
                                "value": {
                                  "longitude": shuttleData["route"][i]["value"]["longitude"],
                                  "latitude": shuttleData["route"][i]["value"]["latitude"]
                                }.toString()
                              });
                            }

                            currentBooking.pickupDropoff = value;

                          })
                        },)
                    )
                  ]
                )
              ),

              Visibility(
                  visible: isSecondPartVisible,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 25, right: 20, top: 30), //apply padding to all four sides
                          child: Text("On this time...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
                      ),

                      Padding(
                          padding: EdgeInsets.only(bottom: 30, left: 25, right: 20, top: 10), //apply padding to all four sides
                          child: BookingDropdownLayout(items: listOfTime, onItemSelected: (value)=>{
                            setState((){
                              currentBooking.time = value;
                            })
                          },)
                      ),

                      Padding(
                          padding: EdgeInsets.only(bottom: 5, left: 25, right: 20), //apply padding to all four sides
                          child: Text("At this day...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
                      ),

                      Padding(
                          padding: EdgeInsets.only(bottom: 30, left: 25, right: 20, top: 10), //apply padding to all four sides
                          child: BookingDropdownLayout(items: listOfDays, onItemSelected: (value)=>{
                            setState((){
                              currentBooking.date = value;
                            })
                          },)
                      ),

                      Padding(
                          padding: EdgeInsets.only(bottom: 5, left: 25, right: 20), //apply padding to all four sides
                          child: Text("At location...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
                      ),

                      Padding(
                          padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 10), //apply padding to all four sides
                          child: BookingDropdownLayout(items: listOfLocation, onItemSelected: (value)=>{
                            setState((){
                              currentBooking.route = value;
                            })
                          },)
                      ),
                    ],
                  )
              ),

              Visibility(
                  visible: isThirdPartVisible,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 25, right: 20, top: 30), //apply padding to all four sides
                            child: Text("You're all set! View your booking summary:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
                        ),

                        Padding(
                            padding: EdgeInsets.only(left: 25, right: 20, top: 30), //apply padding to all four sides
                            child: Container(
                              height: 200,
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 15.0, left: 15.0),
                                    child: Row(
                                      children: [
                                        Text("Route Name: ", style: TextStyle(color: darkblue, fontSize: 15.0, fontWeight: FontWeight.bold)),
                                        Text(currentBooking.routeName, style: TextStyle(color: darkblue, fontSize: 15.0))
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(top: 15.0, left: 15.0),
                                    child: Row(
                                      children: [
                                        Text("Pickup or Dropoff: ", style: TextStyle(color: darkblue, fontSize: 15.0, fontWeight: FontWeight.bold)),
                                        Text(currentBooking.pickupDropoff, style: TextStyle(color: darkblue, fontSize: 15.0))
                                      ],
                                    )
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(top: 15.0, left: 15.0),
                                    child: Row(
                                      children: [
                                        Text("Departure from campus: ", style: TextStyle(color: darkblue, fontSize: 15.0, fontWeight: FontWeight.bold)),
                                        Text(currentBooking.time, style: TextStyle(color: darkblue, fontSize: 15.0))
                                      ],
                                    )
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(top: 15.0, left: 15.0),
                                    child: Row(
                                      children: [
                                        Text("When: ", style: TextStyle(color: darkblue, fontSize: 15.0, fontWeight: FontWeight.bold)),
                                        Text(currentBooking.date, style: TextStyle(color: darkblue, fontSize: 15.0))
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            )
                        ),

                        Padding(
                            padding: EdgeInsets.only(left: 25, right: 20, top: 30), //apply padding to all four sides
                            child: Container(
                              height: 180,
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 20.0, left: 15.0),
                                    child: Text("IMPORTANT (PLEASE READ): ", style: TextStyle(color: darkblue, fontSize: 15.0, fontWeight: FontWeight.bold)),
                                  ),

                                  Padding(
                                      padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                                      child: Text("You may cancel your booking 2 hours before the stated departure time. Failing to mark your shuttle attendance for 3 times may result in a ban from using the shuttle", style: TextStyle(color: darkblue, fontSize: 15.0))
                                  ),
                                ],
                              ),
                            )
                        ),

                      ]
                  )
              ),
              //********BUTTONS***********

              Visibility(
                visible: isFirstPartVisible,
                child: Padding(
                      padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: ElevatedButton(
                          child: Text("Next", style: TextStyle(color: darkblue),),
                          style: ElevatedButton.styleFrom(
                            primary: skyblue,
                            elevation: 0,
                          ),
                          onPressed: () {

                            if(currentBooking.routeName == "" || currentBooking.pickupDropoff == ""){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please select a route and method"),
                              ));
                            }
                            else{
                              setState(() {
                                isFirstPartVisible = false;
                                isSecondPartVisible = true;
                              });
                            }
                          },
                        ),
                      )
                  )
              ),
              Visibility(
                  visible: isSecondPartVisible,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: ElevatedButton(
                          child: Text("Confirm Booking", style: TextStyle(color: darkblue),),
                          style: ElevatedButton.styleFrom(
                            primary: skyblue,
                            elevation: 0,
                          ),
                          onPressed: () {
                            var studentInfo;
                            var shuttleId;
                            var shuttleInfo;
                            var routeData;
                            var locationData;
                            authVM.getCurrentUser(FirebaseAuth.instance.currentUser!.uid).then((value) async => {
                              studentInfo = value.docs.map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>).toList(),
                              if(studentInfo[0]["no_show"] >= 3){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("You are currently banned from booking. Please see the AFM office"),
                                )),
                              }
                              else{
                                currentBooking.studentId = studentInfo[0]["id"],
                                currentBooking.studentName = studentInfo[0]["fullname"],
                                currentBooking.studentMatriculation = studentInfo[0]["matriculation"],
                                if(currentBooking.time == "" || currentBooking.route == "" || currentBooking.date == ""){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Please fill up all the forms"),
                                  ))
                                }
                                else{
                                  location.pickupDropoff = currentBooking.pickupDropoff,
                                  location.routeName = currentBooking.routeName,
                                  location.routeId = currentBooking.routeId,
                                  location.time = currentBooking.time,
                                  location.date = currentBooking.date,
                                  location.shuttleLocation = "",
                                  location.shuttlePlateNo = "",
                                  location.isJourneyStarted = false,

                                  bookingVM.getRouteInfoId(currentBooking.routeId).then((route) => {
                                    routeData = route.data(),
                                    shuttleId = routeData["shuttleId"],
                                    bookingVM.getShuttleFromRoute(shuttleId).then((shuttle) => {
                                      shuttleInfo = shuttle.data(),
                                      bookingVM.getNumberOfBooking(currentBooking.routeId, currentBooking.date, currentBooking.time).then((bookingNumber) => {
                                        if(bookingNumber < shuttleInfo["seats"]){
                                          setState(() {
                                            location.driverId = routeData["driverId"];
                                            location.shuttlePlateNo = shuttleInfo["plateNo"];
                                            location.bookingLocations = currentBooking.route;
                                            isFirstPartVisible = false;
                                            isSecondPartVisible = false;
                                            isThirdPartVisible = true;
                                            bookingVM.addBooking(currentBooking).then((value) => {
                                              realtimeVM.isLocationRefExisting(location.routeId, location.date, location.time).then((locationDoc) => {
                                                if(locationDoc == null){
                                                  realtimeVM.addLocation(location).then((value)=> {
                                                  })
                                                }
                                                else{
                                                  locationData = locationDoc.docs.first.data(),
                                                  realtimeVM.updateLocationList(locationData["id"], location).then((value) => {})
                                                },
                                              }),
                                            });
                                          })

                                        }
                                        else{
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text("Booking for this date or time is full. Please book a different slot."),
                                          ))
                                        }
                                      }),
                                    })
                                  }),
                                }
                              },

                            });
                          },
                        ),
                      )
                  )
              ),
              Visibility(
                visible: isSecondPartVisible,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      child: ElevatedButton(
                        child: Text("Back", style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          elevation: 0,
                        ),
                        onPressed: () {
                          setState(() {
                            isFirstPartVisible = true;
                            isSecondPartVisible = false;
                          });
                        },
                      ),
                    )
                )
              )
            ],
          );
        },

      )
    );
  }

}