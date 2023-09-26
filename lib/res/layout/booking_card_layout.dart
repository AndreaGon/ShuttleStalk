import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuttle_stalk/res/colors.dart';
import 'package:shuttle_stalk/view/realtime/realtime_view.dart';

import '../../view_model/booking/booking_view_model.dart';
import '../../view_model/realtime/realtime_view_model.dart';

class BookingCardLayout extends StatelessWidget {
  final String routeName;
  final String pickupDropoff;
  final String bookingTime;
  final GeoPoint sourceLocation;
  final String bookingId;
  final String bookingDate;
  final String routeId;


  BookingCardLayout({Key? key, required this.routeName, required this.bookingTime, required this.pickupDropoff, required this.sourceLocation, required this.bookingId, required this.bookingDate, required this.routeId}) : super(key: key);


  int hoursDifference = 0;

  @override
  Widget build(BuildContext context) {
    final RealTimeVM realTimeVM = RealTimeVM();
    final BookingVM bookingVM = BookingVM();

    return Padding(
      padding: EdgeInsets.only(bottom: 25.0),
      child:  Container(
        height: 270,
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
              child: Text(routeName + " (" + pickupDropoff + ")", style: TextStyle(color: darkblue, fontSize: 15.0, fontWeight: FontWeight.bold)),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 15.0),
              child: Text("Booking date: " + bookingDate, style: TextStyle(color: darkblue)),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 15.0),
              child: Text("Departure time from campus: " + bookingTime, style: TextStyle(color: darkblue)),
            ),

            Padding(
                padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: ElevatedButton(
                    child: Text("View in Real Time", style: TextStyle(color: darkblue),),
                    style: ElevatedButton.styleFrom(
                      primary: skyblue,
                      elevation: 0,
                    ),
                    onPressed: () {
                      var isJourneyStarted;
                      var shuttleId;
                      var shuttleData;
                      var locationData;
                      realTimeVM.getRealTimeLocationFuture(routeId, bookingDate, bookingTime).then((value) => {
                        locationData = value.docs.first.data()["booking_locations"],
                        isJourneyStarted = value.docs.first.data()["is_journey_started"],
                        bookingVM.getRouteInfoId(routeId).then((value) => {
                          shuttleId = value.data()["shuttleId"],
                            bookingVM.getShuttleFromRoute(shuttleId).then((value) => {
                              shuttleData = value.data(),
                              if(isJourneyStarted){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RealTimeView(allSourceLocation: locationData, sourceLocation: sourceLocation, bookingId: bookingId, bookingDate: bookingDate, bookingTime: bookingTime, routeId: routeId, shuttleData: shuttleData),
                                  ),
                                )
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Driver has not started the journey yet!"),
                                ))
                              }
                            })
                        })


                      });
                    },
                  ),
                )
            ),

            Padding(
                padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: ElevatedButton(
                    child: Text("Cancel Booking", style: TextStyle(color: white)),
                    style: ElevatedButton.styleFrom(
                      primary: red,
                      elevation: 0,
                    ),
                    onPressed: () {
                      calculateTimeBetweenBooking();
                      if(hoursDifference > 2){
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Are you sure?'),
                            content: const Text("This will cancel your shuttle booking. There will be no penalty for the cancellation"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => {
                                  Navigator.of(context).pop(),
                                  bookingVM.deleteBooking(bookingId).then((value) => {})
                                },
                                child: const Text("Yes, I'm sure"),
                              ),
                            ],
                          ),
                        );
                      }
                      else{
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Notice'),
                            content: const Text("Cancellation can only be done 2 hours before your booking!"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Okay'),
                                child: const Text('Okay'),
                              )
                            ],
                          ),
                        );
                      }
                    },
                  ),
                )
            )
          ],
        ),
      )
    );
  }

  calculateTimeBetweenBooking(){
    DateTime dateTimeNow = DateTime.now();
    DateTime bookingDateTime = DateTime.parse("${bookingDate} ${bookingTime}:00");

    hoursDifference = bookingDateTime.difference(dateTimeNow).inHours;
  }
}
