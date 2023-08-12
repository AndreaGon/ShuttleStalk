import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuttle_stalk/res/colors.dart';

import '../../res/layout/booking_card_layout.dart';

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
            Container(
              child: Row(
                  crossAxisAlignment : CrossAxisAlignment.start,
                  children : [
                    Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 80.0, left: 40.0),
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
                      padding: EdgeInsets.only(top: 50.0, left: 60.0),
                      child: Icon(
                        Icons.emoji_transportation,
                        color: Colors.white,
                        size: 120.0,
                        semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    )
                  ]
              ),
            ),
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
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            )
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 50.0, left: 40.0, right: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: Text("My Shuttle Booking", style: TextStyle(color: darkblue, fontWeight: FontWeight.bold, fontSize: 20.0),)
                              ),
                              Expanded(
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return BookingCardLayout();
                                    }
                                ),
                              )
                            ],
                          ),
                        )
                    )//Your widget here,
                ),
              ),
            ),
          ],
        )
    );
  }
}
