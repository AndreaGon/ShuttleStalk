import 'package:flutter/material.dart';
import 'package:shuttle_stalk/res/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shuttle_stalk/view/booking/layout/booking_dropdown_layout.dart';
import 'package:shuttle_stalk/res/layout/bottom_nav_layout.dart';
import 'package:shuttle_stalk/view/authentication/login_view.dart';
import 'package:shuttle_stalk/view_model/authentication/authentication_view_model.dart';

import '../../view_model/booking/booking_view_model.dart';
import '../notification/notification_list_view.dart';
class Booking extends StatefulWidget {
  const Booking({ super.key });

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {

  final BookingVM bookingVM = BookingVM();

  bool isVisible = false;
  var listOfTime = [];
  var listOfLocation = [];
  var shuttleData = {};

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 75,
          automaticallyImplyLeading: false,
          title: Center(child: Text("Book a Shuttle",style: TextStyle(color:Colors.white,fontSize:20, fontWeight: FontWeight.bold))),
          backgroundColor: lightblue
      ),
      body: FutureBuilder(
        future: bookingVM.getShuttleInfo(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Map<String, dynamic>> listOfShuttleNames = [];

          var pickupDropoff = [{"display": "Pickup", "value": "pickup"},{"display": "Dropoff", "value": "dropoff"}];

          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          else{
            for(int i = 0; i < snapshot.data.length; i++){
              listOfShuttleNames.add({"display": snapshot.data[i]["routeName"], "value": snapshot.data[i]["id"]});
              // listOfTime.add(snapshot.data[i]["pickupTime"].toString());
              // listOfLocation.add(snapshot.data[i]["route"].toString());
            }

            print("CONTENT: " + listOfShuttleNames.toString());
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 25, right: 20, top: 30), //apply padding to all four sides
                  child: Text("I want to book...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
              ),

              Padding(
                  padding: EdgeInsets.only(bottom: 30, left: 25, right: 20, top: 10), //apply padding to all four sides
                  child: BookingDropdownLayout(items: listOfShuttleNames, onItemSelected: (value) async => {
                    await bookingVM.getShuttleInfoId(value).then((value) => {
                      shuttleData = value.data()
                    })
                  },)
              ),

              Padding(
                  padding: EdgeInsets.only(bottom: 5, left: 25, right: 20), //apply padding to all four sides
                  child: Text("For...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
              ),

              Padding(
                  padding: EdgeInsets.only(bottom: 30, left: 25, right: 20, top: 5), //apply padding to all four sides
                  child: BookingDropdownLayout(items: pickupDropoff, onItemSelected: (value)=> {
                    setState(() {
                      isVisible = true;

                      print(value);
                    })
                  },)
              ),

              Visibility(
                  visible: isVisible,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 5, left: 25, right: 20), //apply padding to all four sides
                          child: Text("On this time...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
                      ),

                      Padding(
                          padding: EdgeInsets.only(bottom: 30, left: 25, right: 20, top: 10), //apply padding to all four sides
                          child: BookingDropdownLayout(items: pickupDropoff, onItemSelected: (value)=>{

                          },)
                      ),

                      Padding(
                          padding: EdgeInsets.only(bottom: 5, left: 25, right: 20), //apply padding to all four sides
                          child: Text("At location...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
                      ),

                      Padding(
                          padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 10), //apply padding to all four sides
                          child: BookingDropdownLayout(items: pickupDropoff, onItemSelected: (value)=>{

                          },)
                      ),
                    ],
                  )
              ),

              Padding(
                  padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 30),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: ElevatedButton(
                      child: Text("Confirm Booking", style: TextStyle(color: darkblue),),
                      style: ElevatedButton.styleFrom(
                        primary: skyblue,
                        elevation: 0,
                      ),
                      onPressed: () {},
                    ),
                  )
              )
            ],
          );
        },

      )
    );
  }

}