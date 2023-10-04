import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuttle_stalk/view/authentication/login_view.dart';
import 'package:shuttle_stalk/view/booking/booking_view.dart';
import 'package:shuttle_stalk/view/main_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AuthenticationVM {

  CollectionReference students = FirebaseFirestore.instance.collection('students');

  Future<void> registerUser(BuildContext context, String fullname, String program, String ic_number, String month, String year, String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var uuid = Uuid();
      var uuidV4 = uuid.v4();

      students.doc().set({
        'id': uuidV4,
        'fullname': fullname,
        'program': program,
        'ic_number': ic_number,
        'graduation_month': month,
        'graduation_year': year,
        'email': email,
        'userAuthId': credential.user?.uid,
        'no_show': 0,
        'is_active_account': true
      }).then((value) => {}).catchError((error) => print("Failed to add book: $error"));


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Successfully registered user!"),
      ));
      Navigator.of(context).pushReplacement(
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
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Logged IN!"),
      ));

      await saveUserLoginState(userCredential.user!);

      Navigator.of(context).pushReplacement(
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

  Future<bool> isLoggedIn(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId != null) {
      return true;
    }
    return false;
  }


  Future getCurrentUser(String userAuthId) async{
    return await students.where('userAuthId', isEqualTo: userAuthId)
        .get();
  }

  Future getCurrentUserWithEmail(String email) async{
    return await students.where('email', isEqualTo: email)
        .get();
  }

  Future deactivateAccount(String id) async{
    return await students.doc(id).update({
      "is_active_account": false
    });
  }

  Future<void> saveUserLoginState(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', user.uid);
  }

  Future signOut() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await FirebaseAuth.instance.signOut();
  }
}