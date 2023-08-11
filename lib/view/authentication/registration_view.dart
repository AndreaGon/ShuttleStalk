
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:intl/intl.dart';
import 'package:shuttle_stalk/res/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shuttle_stalk/view/authentication/login_view.dart';
import 'package:shuttle_stalk/view_model/authentication_view_model.dart';

class Registration extends StatefulWidget {
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final formKey = GlobalKey<FormState>();

  final username = TextEditingController();

  final email = TextEditingController();

  final password = TextEditingController();

  String graduation_month = "Graduation Month and Year";

  String graduation_year = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkblue,
        appBar: null,
        body: Container(
            margin: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Register an Account",
                      style: TextStyle(height: 5, fontSize: 25, color: white)
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: TextFormField(
                        obscureText: false,
                        controller: username,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Full Name',
                            filled: true,
                            fillColor: white
                        )
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                        obscureText: false,
                        controller: username,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Program (e.g. BCSCUN)',
                            filled: true,
                            fillColor: white
                        )
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: ElevatedButton(
                          child: Text(graduation_month + " " + graduation_year, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),textAlign: TextAlign.left,),
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            primary: white,
                            elevation: 0,
                          ),
                          onPressed: () {
                            showMonthPicker(context, onSelected: (month, year) {
                              if (kDebugMode) {
                                print('Selected month: $month, year: $year');
                              }

                              setState(() {
                                this.graduation_month = DateFormat('MMMM').format(DateTime(0, month));
                                this.graduation_year = DateFormat('yyyy').format(DateTime(year));
                              });
                            },
                            firstEnabledMonth: 3,
                            lastEnabledMonth: 10,
                            firstYear: 2000,
                            lastYear: 3000,
                            selectButtonText: 'OK',
                            cancelButtonText: 'Cancel',
                            highlightColor: darkblue,
                            textColor: Colors.black,
                            contentBackgroundColor: Colors.white,
                            dialogBackgroundColor: Colors.grey[200]);
                          },
                        ),
                      )
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      obscureText: false,
                      controller: email,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Student Email',
                          filled: true,
                          fillColor: white
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: password,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          filled: true,
                          fillColor: white
                      ),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: lightblue,
                        minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                          Authentication().registerUser(context, username.text.trim(), email.text.trim(), password.text.trim());
                        }
                      },
                      child: const Text("Register")
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: const Text("- Already have an account? -",
                        style: TextStyle(fontSize: 15, color: white)
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: lightblue,
                        minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      },
                      child: const Text("Login")
                  )
                ],
              )
            )
        )
    );
  }
}