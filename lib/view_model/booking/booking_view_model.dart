import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shuttle_stalk/models/bookings.dart';
import 'package:uuid/uuid.dart';

class BookingVM {
  CollectionReference routes = FirebaseFirestore.instance.collection('routes');
  CollectionReference shuttles = FirebaseFirestore.instance.collection('shuttles');
  CollectionReference bookingRef = FirebaseFirestore.instance.collection('bookings');

  Future getRouteInfo() async {
    QuerySnapshot querySnapshot = await routes.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

  Future getRouteInfoId(String id) async{
    DocumentSnapshot documentSnapshot = await routes.doc(id).get();

    return documentSnapshot;
  }

  Future getShuttleFromRoute(String shuttleId) async{
    DocumentSnapshot documentSnapshot = await shuttles.doc(shuttleId).get();

    return documentSnapshot;
  }


  Stream getAllBookingsStudentId(String studentId){
    DateTime dateToday = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-dd").format(dateToday);
    Stream<QuerySnapshot> querySnapshot=  bookingRef
        .where('studentId', isEqualTo: studentId)
        .where('attendance_marked', isEqualTo: false)
        .where('is_invalid', isEqualTo: false)
        .orderBy('date')
        .where('date', isGreaterThanOrEqualTo: formattedDate)
        .snapshots();
    return querySnapshot;
  }

  Future<void> deleteBooking(String id) async {
    bookingRef.doc(id).delete();
  }

  Future<void> addBooking(Bookings bookings) async {
    var uuid = Uuid();
    var uuidV4 = uuid.v4();
    var waypoint;

    LatLng sourceLocation = LatLng(0.0, 0.0);
    String validJson = (bookings.route).replaceAllMapped(
      RegExp(r'(\w+):'), // Match unquoted keys
          (Match match) => '"${match.group(1)}":', // Add double quotes to keys
    );

    waypoint = await json.decode('${validJson}');
    sourceLocation = LatLng(waypoint["latitude"], waypoint["longitude"]);

    GeoPoint sourceGeopoint = GeoPoint(sourceLocation.latitude, sourceLocation.longitude);

    bookingRef.doc(uuidV4).set({
      "id": uuidV4,
      "routeName": bookings.routeName,
      "pickupDropoff": bookings.pickupDropoff,
      "time": bookings.time,
      "date": bookings.date,
      "route": sourceGeopoint,
      "studentId": bookings.studentId,
      "routeId": bookings.routeId,
      "attendance_marked": false,
      "is_invalid": false,
      "studentName": bookings.studentName,
      "studentMatriculation": bookings.studentMatriculation
    });
  }

  Future<void> markAttendance(String bookingId) async {
    bookingRef.doc(bookingId).update({
      "attendance_marked": true
    });
  }

  Future<int> getNumberOfBooking(String routeId, String date, String time) async{
    QuerySnapshot querySnapshotBooking = await bookingRef
        .where('routeId', isEqualTo: routeId)
        .where('date', isEqualTo: date)
        .where('time', isEqualTo: time)
        .get();
    
    return querySnapshotBooking.size;
  }

}