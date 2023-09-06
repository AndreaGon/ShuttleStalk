import 'package:cloud_firestore/cloud_firestore.dart';
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
    Stream<QuerySnapshot> querySnapshot=  bookingRef.where('studentId', isEqualTo: studentId).snapshots();
    return querySnapshot;
  }

  Future<void> deleteBooking(String id) async {
    bookingRef.doc(id).delete();
  }

  Future<void> addBooking(Bookings bookings) async {
    var uuid = Uuid();
    var uuidV4 = uuid.v4();
    bookingRef.doc(uuidV4).set({
      "id": uuidV4,
      "routeName": bookings.routeName,
      "pickupDropoff": bookings.pickupDropoff,
      "time": bookings.time,
      "date": bookings.date,
      "route": bookings.route,
      "studentId": bookings.studentId,
      "routeId": bookings.routeId
    });
  }
}