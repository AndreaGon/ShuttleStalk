import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttle_stalk/view_model/realtime/realtime_view_model.dart';

import '../../res/colors.dart';
import '../../view_model/booking/booking_view_model.dart';

import '../../res/env.dart' as ENV;

class RealTimeView extends StatefulWidget {
  String sourceLocation;
  String bookingId;
  String bookingDate;
  String bookingTime;
  String routeId;
  Map<String, dynamic> shuttleData;

  RealTimeView({Key? key, required this.sourceLocation, required this.bookingId, required this.bookingDate, required this.bookingTime, required this.routeId, required this.shuttleData}) : super(key: key);

  @override
  State<RealTimeView> createState() => _RealTimeViewState();
}

class _RealTimeViewState extends State<RealTimeView> {

  Completer<GoogleMapController> _controller = Completer();
  final BookingVM bookingVM = BookingVM();
  final RealTimeVM realTimeVM = RealTimeVM();

  var waypoint;
  var distanceTime;
  int hoursDifference = 0;

  Set<Marker> driverMarker = Set();

  BitmapDescriptor driverIcon = BitmapDescriptor.defaultMarker;
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  GeoPoint driverLocation = GeoPoint(0.0, 0.0);
  LatLng source = LatLng(0.0, 0.0);


  @override
  void initState() {
    initDestinationLocation();
    setCustomMarkerIcon();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: lightblue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: realTimeVM.getRealTimeLocation(widget.routeId, widget.bookingDate, widget.bookingTime),
            builder: (context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData){

                return Center(child: CircularProgressIndicator());
              }

              driverLocation = snapshot.data["shuttleLocation"];

              final latLng = LatLng(driverLocation.latitude, driverLocation.longitude);

              return FutureBuilder(
                  builder: (ctx, snapshot){
                    if(!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    else{
                      source = snapshot.data as LatLng;
                      getPolyline(driverLocation.latitude, driverLocation.longitude, source.latitude, source.longitude);

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
                        Marker(
                          markerId: MarkerId("location"),
                          position: latLng,
                          icon: driverIcon,
                        )

                      },
                      onMapCreated: (mapController) {
                        _controller.complete(mapController);
                      },
                      polylines: Set<Polyline>.of(polylines.values),
                    );
                  },

                  future: initDestinationLocation()
              );
            }
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return FutureBuilder(
                  builder: (ctx, AsyncSnapshot snapshot) {
                    var estimatedTimeArrival;

                    if(distanceTime != null){
                      estimatedTimeArrival = distanceTime["rows"][0]["elements"][0]["duration"];
                    }

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
                                  child: Text("Shuttle Plate No: ${widget.shuttleData["plateNo"]}", style: TextStyle(color: darkblue, fontSize: 20.0, fontWeight: FontWeight.bold)),
                                )
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 25, right: 20),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50.0,
                                  child:
                                  (estimatedTimeArrival == null) ? Text("ETA: No ETA at this time", style: TextStyle(color: darkblue, fontSize: 20.0, fontWeight: FontWeight.bold)): Text("ETA: " + (estimatedTimeArrival["text"]).toString(), style: TextStyle(color: darkblue, fontSize: 20.0, fontWeight: FontWeight.bold)),
                                )
                            ),
                            Padding(
                                padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 30),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50.0,
                                  child: ElevatedButton(
                                    child: Text("Mark Attendance", style: TextStyle(color: darkblue),),
                                    style: ElevatedButton.styleFrom(
                                      primary: skyblue,
                                      elevation: 0,
                                    ),
                                    onPressed: () {

                                      var proximityThreshold = 1000.0;

                                      determinePosition().then((value) => {
                                        distanceCalculation(value.latitude, value.longitude,driverLocation.latitude, driverLocation.longitude).then((result) => {
                                          if(result <= proximityThreshold){
                                            bookingVM.markAttendance(widget.bookingId),
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text("Successfully marked attendance!"),
                                            )),
                                            Navigator.of(context).pop(),
                                          }
                                          else{
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text("Cannot mark attendance as shuttle is not nearby."),
                                            ))
                                          }
                                        })
                                      });

                                    },
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    );
                  },

                  future: getDistanceMatrix()
              );
            },
          )
        ],
      ),
    );
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

  void setCustomMarkerIcon() async{
    await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "lib/res/assets/shuttle.png")
        .then(
          (icon) {
        driverIcon = icon;
      },
    );
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    polylines = {};
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      color: lightblue,
      width: 8,
    );

    polylines[id] = polyline;
    if(mounted){
      setState(() {});
    }
  }

  void getPolyline(sourceLat, sourceLong, destLat, destLong) async {
    List<LatLng> polylineCoordinates = [];
    polylineCoordinates.clear();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      ENV.GOOGLE_API_KEY,
      PointLatLng(sourceLat, sourceLong),
      PointLatLng(destLat, destLong),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  Future getDistanceMatrix() async {
    try {
      //var response = await Dio().get('https://maps.googleapis.com/maps/api/distancematrix/json?origins=${source.latitude},${source.longitude}&destinations=${driverLocation.latitude},${driverLocation.longitude}&key=');
      //return await (response.data["rows"][0]["elements"][0]["duration"]["text"]).toString();
      //distanceTime = response.data;

      distanceTime = null;

      // if(distanceTime["rows"][0]["elements"][0]["status"] == "ZERO_RESULT"){
      //   getDistanceMatrix();
      // }
      // else{
      //   if(mounted){
      //     setState(() {});
      //   }
      // }

      return distanceTime;

      if(mounted){
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  markAttendance() {

  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<double> distanceCalculation(userLat, userLong, driverLat, driverLong) async {
    return await Geolocator.distanceBetween(userLat, userLong, driverLat, driverLong);
  }
}
