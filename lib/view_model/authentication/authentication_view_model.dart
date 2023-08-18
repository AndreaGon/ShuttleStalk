import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shuttle_stalk/view/authentication/login_view.dart';
import 'package:shuttle_stalk/view/booking/booking_view.dart';
import 'package:shuttle_stalk/view/main_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationVM {

  CollectionReference students = FirebaseFirestore.instance.collection('students');

  Future<void> registerUser(BuildContext context, String fullname, String program, String ic_number, String month, String year, String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      students.add({
        'fullname': fullname,
        'program': program,
        'ic_number': ic_number,
        'graduation_month': month,
        'graduation_year': year,
        'email': email,
        'userAuthId': credential.user?.uid,
        'is_banned': false
      })
          .then((value) => {
        students.doc(value.id).update({
          "id": value.id
        })
      })
          .catchError((error) => print("Failed to add book: $error"));


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Successfully registered user!"),
      ));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginUser(BuildContext context, String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Logged IN!"),
      ));

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MainView(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("User doesn't exist! Please register yourself."),
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Wrong password!"),
        ));
      }
    }
  }

  Future getCurrentUser(String userAuthId) async{
    return await students.where('userAuthId', isEqualTo: userAuthId)
        .get();
  }
}