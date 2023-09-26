import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/locations.dart';

class RealTimeVM {
  CollectionReference routes = FirebaseFirestore.instance.collection('routes');
  CollectionReference locationRef = FirebaseFirestore.instance.collection('locations');

  Future isLocationRefExisting(String routeId, String date, String time) async{
    try {
      // Perform a "where" query with multiple conditions and limit to one document
      QuerySnapshot querySnapshot = await locationRef
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
    QuerySnapshot querySnapshot = await locationRef
        .where('routeId', isEqualTo: routeId) // Replace with your field and value
        .where('date', isEqualTo: date)
        .where('time', isEqualTo: time)
        .limit(1) // Limit the result to one document
        .get();

    return querySnapshot;
  }

  Stream getRealTimeLocation(String routeId, String date, String time){
    Stream<QuerySnapshot> querySnapshot = locationRef
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

  Future<void> addLocation(Locations locations) async {
    var uuid = Uuid();
    var uuidV4 = uuid.v4();
    var waypoint;

    LatLng sourceLocation = LatLng(0.0, 0.0);
    String validJson = (locations.bookingLocations).replaceAllMapped(
      RegExp(r'(\w+):'), // Match unquoted keys
          (Match match) => '"${match.group(1)}":', // Add double quotes to keys
    );

    waypoint = await json.decode('${validJson}');
    sourceLocation = LatLng(waypoint["latitude"], waypoint["longitude"]);

    GeoPoint sourceGeopoint = GeoPoint(sourceLocation.latitude, sourceLocation.longitude);

    locationRef.doc(uuidV4).set({
      "id": uuidV4,
      "routeName": locations.routeName,
      "routeId": locations.routeId,
      "time": locations.time,
      "date": locations.date,
      "shuttleLocation": null,
      "driverId": locations.driverId,
      "is_journey_started": locations.isJourneyStarted,
      "is_journey_finished": false,
      "pickupDropoff": locations.pickupDropoff,
      "booking_locations": [sourceGeopoint]
    });
  }

  Future<void> updateLocationList(String id, Locations locations) async {
    var waypoint;

    LatLng sourceLocation = LatLng(0.0, 0.0);
    String validJson = (locations.bookingLocations).replaceAllMapped(
      RegExp(r'(\w+):'), // Match unquoted keys
          (Match match) => '"${match.group(1)}":', // Add double quotes to keys
    );

    waypoint = await json.decode('${validJson}');
    sourceLocation = LatLng(waypoint["latitude"], waypoint["longitude"]);

    GeoPoint sourceGeopoint = GeoPoint(sourceLocation.latitude, sourceLocation.longitude);

    locationRef.doc(id).update({
      "booking_locations": FieldValue.arrayUnion([sourceGeopoint])
    });
  }
}