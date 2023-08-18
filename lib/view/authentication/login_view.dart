import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shuttle_stalk/res/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shuttle_stalk/view/authentication/registration_view.dart';
import 'package:shuttle_stalk/view_model/authentication/authentication_view_model.dart';
class Login extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  AuthenticationVM authVM = AuthenticationVM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkblue,
      appBar: null,
      body: Container(
          margin: new EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Login to Shuttle Stalk",
                  style: TextStyle(height: 5, fontSize: 25, color: white)
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: TextFormField(
                    obscureText: false,
                    controller: email,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        filled: true, //<-- SEE HERE
                        fillColor: white
                    )
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: TextFormField(
                  obscureText: true,
                  controller: password,
                  decoration: InputDecoration(
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
                      var studentInfo;
                      authVM.getCurrentUserWithEmail(email.text.trim()).then((value) => {
                        studentInfo = value.docs.map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>).toList(),
                        if(studentInfo.length == 0){
                          authVM.loginUser(context, email.text.trim(), password.text.trim())
                        }
                        else{
                          if(studentInfo[0]["is_active_account"]){
                            authVM.loginUser(context, email.text.trim(), password.text.trim())
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Your account is deactivated. Please see the AFM office"),
                            ))
                          }
                        }
                      });
                    }
                  },
                  child: const Text("Login")
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: const Text("- or -",
                    style: TextStyle(fontSize: 15, color: white)
                ),
              ),
              ElevatedButton(
                  child: const Text("Register"),
                  style: ElevatedButton.styleFrom(
                    primary: lightblue,
                    minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Registration(),
                      ),
                    );
                  }
              )
            ],
          )
        )
      )
    );
  }
}