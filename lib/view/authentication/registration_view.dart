import 'package:flutter/material.dart';
import 'package:shuttle_stalk/res/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shuttle_stalk/view/authentication/login_view.dart';
import 'package:shuttle_stalk/view_model/authentication_view_model.dart';
class Registration extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkblue,
        appBar: null,
        body: new Container(
            margin: new EdgeInsets.all(15.0),
            child: new Form(
              key: formKey,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Text("Register an Account",
                      style: TextStyle(height: 5, fontSize: 25, color: white)
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: new TextFormField(
                        obscureText: false,
                        controller: username,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            filled: true, //<-- SEE HERE
                            fillColor: white
                        )
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: new TextFormField(
                      obscureText: false,
                      controller: email,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          filled: true,
                          fillColor: white
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: new TextFormField(
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
                  new ElevatedButton(
                      child: new Text("Register"),
                      style: ElevatedButton.styleFrom(
                        primary: lightblue,
                        minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                          Authentication().registerUser(context, username.text.trim(), email.text.trim(), password.text.trim());
                        }
                      }
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: new Text("- Already have an account? -",
                        style: TextStyle(fontSize: 15, color: white)
                    ),
                  ),
                  new ElevatedButton(
                      child: new Text("Login"),
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
                      }
                  )
                ],
              )
            )
        )
    );
  }
}