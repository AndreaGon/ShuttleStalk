
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationVM {

  Stream getAllAnnouncements(){
    Stream<QuerySnapshot> querySnapshot=  FirebaseFirestore.instance.collection('announcements').orderBy('timestamp', descending: true).snapshots();
    return querySnapshot;
  }
}