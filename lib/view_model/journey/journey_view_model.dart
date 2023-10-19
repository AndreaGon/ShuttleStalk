import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/journeys.dart';

class JourneyVM {
  CollectionReference routes = FirebaseFirestore.instance.collection('routes');
  CollectionReference journeyRef = FirebaseFirestore.instance.collection('journeys');

  Future isLocationRefExisting(String routeId, String date, String time) async{
    try {
      // Perform a "where" query with multiple conditions and limit to one document
      QuerySnapshot querySnapshot = await journeyRef
          .where('routeId', isEqualTo: routeId) // Replace with your field and value
          .where('date', isEqualTo: date)
          .where('time', isEqualTo: time)
          .limit(1) // Limit the result to one document
          .get();

      // Check if there are any matching documents
      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve and process the single document
        //QueryDocumentSnapshot document = querySnapshot.docs.first;
        return querySnapshot;
      } else {
        return null;
      }
    } catch (e) {
      print('Error querying Firestore: $e');
      return false;
    }
  }

  Future getRealTimeLocationFuture(String routeId, String date, String time) async{
    QuerySnapshot querySnapshot = await journeyRef
        .where('routeId', isEqualTo: routeId) // Replace with your field and value
        .where('date', isEqualTo: date)
        .where('time', isEqualTo: time)
        .limit(1) // Limit the result to one document
        .get();

    return querySnapshot;
  }

  Stream getRealTimeLocation(String routeId, String date, String time){
    Stream<QuerySnapshot> querySnapshot = journeyRef
        .where('routeId', isEqualTo: routeId) // Replace with your field and value
        .where('date', isEqualTo: date)
        .where('time', isEqualTo: time)
        .limit(1)
        .snapshots();
    
    return querySnapshot.map(
      (QuerySnapshot snapshot) {
          // Convert each document in the query snapshot to a Map
          List<Map<String, dynamic>> documents = [];
          for (QueryDocumentSnapshot doc in snapshot.docs) {
            documents.add(doc.data() as Map<String, dynamic>);
          }

          return documents[0];
        },
      );
  }

  Future<void> addLocation(Journeys journeys) async {
    var uuid = Uuid();
    var uuidV4 = uuid.v4();
    var waypoint;

    LatLng sourceLocation = LatLng(0.0, 0.0);
    String validJson = (journeys.bookingLocations).replaceAllMapped(
      RegExp(r'(\w+):'), // Match unquoted keys
          (Match match) => '"${match.group(1)}":', // Add double quotes to keys
    );

    waypoint = await json.decode('${validJson}');
    sourceLocation = LatLng(waypoint["latitude"], waypoint["longitude"]);

    GeoPoint sourceGeopoint = GeoPoint(sourceLocation.latitude, sourceLocation.longitude);

    journeyRef.doc(uuidV4).set({
      "id": uuidV4,
      "routeName": journeys.routeName,
      "routeId": journeys.routeId,
      "time": journeys.time,
      "date": journeys.date,
      "shuttleLocation": null,
      "driverId": journeys.driverId,
      "is_journey_started": journeys.isJourneyStarted,
      "is_journey_finished": false,
      "pickupDropoff": journeys.pickupDropoff,
      "booking_locations": [sourceGeopoint]
    });
  }

  Future<void> updateLocationList(String id, Journeys journeys) async {
    var waypoint;

    LatLng sourceLocation = LatLng(0.0, 0.0);
    String validJson = (journeys.bookingLocations).replaceAllMapped(
      RegExp(r'(\w+):'), // Match unquoted keys
          (Match match) => '"${match.group(1)}":', // Add double quotes to keys
    );

    waypoint = await json.decode('${validJson}');
    sourceLocation = LatLng(waypoint["latitude"], waypoint["longitude"]);

    GeoPoint sourceGeopoint = GeoPoint(sourceLocation.latitude, sourceLocation.longitude);

    journeyRef.doc(id).update({
      "booking_locations": FieldValue.arrayUnion([sourceGeopoint])
    });
  }
}