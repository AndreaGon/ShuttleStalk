import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuttle_stalk/res/colors.dart';

class BookingCardLayout extends StatelessWidget {
  const BookingCardLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 25.0),
      child:  Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 15.0),
              child: Text("Route Sg. Ara (Pickup)", style: TextStyle(color: darkblue, fontSize: 15.0, fontWeight: FontWeight.bold)),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 15.0),
              child: Text("Departure time from campus: 9:00AM", style: TextStyle(color: darkblue)),
            ),

            Padding(
                padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: ElevatedButton(
                    child: Text("More Information", style: TextStyle(color: darkblue),),
                    style: ElevatedButton.styleFrom(
                      primary: skyblue,
                      elevation: 0,
                    ),
                    onPressed: () {},
                  ),
                )
            )
          ],
        ),
      )
    );
  }
}
