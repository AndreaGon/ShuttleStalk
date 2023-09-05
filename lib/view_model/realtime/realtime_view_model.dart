import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/locations.dart';

class RealTimeVM {
  CollectionReference routes = FirebaseFirestore.instance.collection('routes');
  CollectionReference locationRef = FirebaseFirestore.instance.collection('locations');

  Future<bool> isLocationRefExisting(String routeId, String date, String time) async{
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
        QueryDocumentSnapshot document = querySnapshot.docs.first;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error querying Firestore: $e');
      return false;
    }
  }

  Future<void> addLocation(Locations locations) async {
    locationRef.add({
      "routeId": locations.routeId,
      "time": locations.time,
      "date": locations.date,
      "shuttleLocation": locations.shuttleLocation
    });
  }
}