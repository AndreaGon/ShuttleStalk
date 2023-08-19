import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuttle_stalk/view/authentication/login_view.dart';
import 'package:shuttle_stalk/view_model/authentication/authentication_view_model.dart';

import '../../res/colors.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  AuthenticationVM authVM = AuthenticationVM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 75,
          automaticallyImplyLeading: false,
          title: Center(child: Text("Profile",style: TextStyle(color:Colors.white,fontSize:20, fontWeight: FontWeight.bold))),
          backgroundColor: lightblue
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 25, right: 20, top: 30), //apply padding to all four sides
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: ElevatedButton(
                  child: Text("Logout", style: TextStyle(color: darkblue),),
                  style: ElevatedButton.styleFrom(
                    primary: skyblue,
                    elevation: 0,
                  ),
                  onPressed: () {
                    authVM.signOut().then((value) => {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Logged out successfully!"),
                      )),
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      )
                    });
                  },
                ),
              ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 25, right: 20, top: 30), //apply padding to all four sides
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              child: ElevatedButton(
                child: Text("Deactivate Account", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  elevation: 0,
                ),
                onPressed: () {
                  var studentInfo;
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text("This will permanently deactivate your account. Only use this when you have graduated!"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => {
                            authVM.getCurrentUser(FirebaseAuth.instance.currentUser!.uid).then((value) => {
                              studentInfo = value.docs.map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>).toList(),
                              authVM.deactivateAccount(studentInfo[0]["id"]).then((value) => {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                )
                              })
                            })
                          },
                          child: const Text("Yes, I'm sure"),
                        ),
                      ],
                    ),
                  );

                },
              ),
            ),
          ),
        ],
      )
    );
  }
}
