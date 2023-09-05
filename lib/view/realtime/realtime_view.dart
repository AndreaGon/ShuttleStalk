import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../res/colors.dart';
import '../../view_model/booking/booking_view_model.dart';

class RealTimeView extends StatefulWidget {
  String sourceLocation;
  String bookingId;
  String bookingDate;
  String bookingTime;

  RealTimeView({Key? key, required this.sourceLocation, required this.bookingId, required this.bookingDate, required this.bookingTime}) : super(key: key);

  @override
  State<RealTimeView> createState() => _RealTimeViewState();
}

class _RealTimeViewState extends State<RealTimeView> {

  Completer<GoogleMapController> _controller = Completer();
  final BookingVM bookingVM = BookingVM();

  var waypoint;
  int hoursDifference = 0;
  @override
  void initState() {
    super.initState();
    initDestinationLocation();
  }

  Future<LatLng> initDestinationLocation() async {
    LatLng destination = LatLng(0.0, 0.0);
    String validJson = (widget.sourceLocation).replaceAllMapped(
      RegExp(r'(\w+):'), // Match unquoted keys
          (Match match) => '"${match.group(1)}":', // Add double quotes to keys
    );

    waypoint = await json.decode('${validJson}');
    destination = LatLng(waypoint["latitude"], waypoint["longitude"]);

    return destination;
  }

  calculateTimeBetweenBooking(){
    DateTime dateTimeNow = DateTime.now();
    DateTime bookingDateTime = DateTime.parse("${widget.bookingDate} ${widget.bookingTime}:00");

    //hoursDifference = bookingDateTime.difference(dateTimeNow).inHours;
    hoursDifference = bookingDateTime.difference(dateTimeNow).inHours;
    print("DATETIME: " + hoursDifference.toString());
  }


  @override
  Widget build(BuildContext context) {
    calculateTimeBetweenBooking();
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: lightblue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add navigation logic here, e.g., to pop the current screen
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
              builder: (ctx, snapshot){
                var source;
                print("LOCATION" + snapshot.data.toString());
                if(!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                else{
                  source = snapshot.data;
                }
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: source,
                    zoom: 13.5,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId("destination"),
                      position: source,
                    ),

                  },
                  onMapCreated: (mapController) {
                    _controller.complete(mapController);
                  },
                );
              },

              future: initDestinationLocation()
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
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
                      // border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),

                    ),
                    child: Scrollbar(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 25, right: 20, top: 50),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50.0,
                                child: Text("Shuttle Plate No here ", style: TextStyle(color: darkblue, fontSize: 20.0, fontWeight: FontWeight.bold)),
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 25, right: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50.0,
                                child: Text("ETA here ", style: TextStyle(color: darkblue, fontSize: 20.0, fontWeight: FontWeight.bold)),
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 30),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50.0,
                                child: ElevatedButton(
                                  child: Text("Cancel Booking", style: TextStyle(color: white),),
                                  style: ElevatedButton.styleFrom(
                                    primary: red,
                                    elevation: 0,
                                  ),
                                  onPressed: () {
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
                                                bookingVM.deleteBooking(widget.bookingId).then((value) => {
                                                  Navigator.of(context).pop(),
                                                })
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
                    ),
              );
            },
          )
        ],
      ),
    );
  }
}
