import 'package:cloud_firestore/cloud_firestore.dart';

class BookingVM {
  CollectionReference shuttles = FirebaseFirestore.instance.collection('shuttles');

  Future getShuttleInfo() async {
    QuerySnapshot querySnapshot = await shuttles.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

  Future getShuttleInfoId(String id) async{
    DocumentSnapshot documentSnapshot = await shuttles.doc(id).get();

    return documentSnapshot;
  }
}