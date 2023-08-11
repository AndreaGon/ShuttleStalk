import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuttle_stalk/res/colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        backgroundColor: lightblue,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                crossAxisAlignment : CrossAxisAlignment.start,
                children : [
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 70.0, left: 40.0),
                          child: Container(
                            child: Text("Welcome,", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 10.0),
                          child: Container(
                            child: Text("Andrea!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
                          )
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40.0, left: 60.0),
                    child: Icon(
                      Icons.emoji_transportation,
                      color: Colors.white,
                      size: 120.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  )
                ]
            ),
            // Padding(
            //     padding: EdgeInsets.only(top: 10.0, left: 30.0),
            //     child: Container(
            //       child: Text("Andrea!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
            //     )
            // ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: Container(
                        height: 530,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(70),
                              topRight: Radius.circular(70),
                            )
                        ),
                        child: Text("")
                    )//Your widget here,
                ),
              ),
            ),
          ],
        )
    );
  }
}
