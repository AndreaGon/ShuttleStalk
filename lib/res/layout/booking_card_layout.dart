import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuttle_stalk/res/colors.dart';
import 'package:shuttle_stalk/view/realtime/realtime_view.dart';

import '../../view_model/realtime/realtime_view_model.dart';

class BookingCardLayout extends StatelessWidget {
  final String routeName;
  final String pickupDropoff;
  final String departureTime;
  final String sourceLocation;
  final String bookingId;
  final String bookingDate;
  final String routeId;


  const BookingCardLayout({Key? key, required this.routeName, required this.departureTime, required this.pickupDropoff, required this.sourceLocation, required this.bookingId, required this.bookingDate, required this.routeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RealTimeVM realTimeVM = RealTimeVM();

    return Padding(
      padding: EdgeInsets.only(bottom: 25.0),
      child:  Container(
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
              child: Text("Route " + routeName + " (" + pickupDropoff + ")", style: TextStyle(color: darkblue, fontSize: 15.0, fontWeight: FontWeight.bold)),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 15.0),
              child: Text("Booking date: " + bookingDate, style: TextStyle(color: darkblue)),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 15.0),
              child: Text("Departure time from campus: " + departureTime, style: TextStyle(color: darkblue)),
            ),

            Padding(
                padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: ElevatedButton(
                    child: Text("More Information", style: TextStyle(color: darkblue),),
                    style: ElevatedButton.styleFrom(
                      primary: skyblue,
                      elevation: 0,
                    ),
                    onPressed: () {
                      var isJourneyStarted;
                      realTimeVM.getRealTimeLocationFuture(routeId, bookingDate, departureTime).then((value) => {
                        isJourneyStarted = value.docs.first.data()["isJourneyStarted"],
                        if(isJourneyStarted){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RealTimeView(sourceLocation: sourceLocation, bookingId: bookingId, bookingDate: bookingDate, bookingTime: departureTime, routeId: routeId),
                            ),
                          )
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Driver has not started the journey yet!"),
                          ))
                        }

                      });
                    },
                  ),
                )
            )
          ],
        ),
      )
    );
  }
}
