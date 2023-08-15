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

  bool isTimeLocationVisible = false;
  bool isPickupDropoffVisible = false;
  List<Map<dynamic, dynamic>> listOfTime = [];
  List<Map<dynamic, dynamic>> listOfLocation = [];
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
          List<Map<String, dynamic>> listOfShuttleNames = [{"display": "- Select a value -", "value": "null"}];

          var pickupDropoff = [{"display": "- Select a value -", "value": "null"},{"display": "Pickup", "value": "pickup"},{"display": "Dropoff", "value": "dropoff"}];

          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          else{
            for(int i = 0; i < snapshot.data.length; i++){
              listOfShuttleNames.add({"display": snapshot.data[i]["routeName"], "value": snapshot.data[i]["id"]});
            }
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
                  child: BookingDropdownLayout(items: listOfShuttleNames, onItemSelected: (value) => {
                    setState(() {

                      if(value != "null"){
                        bookingVM.getShuttleInfoId(value).then((value) => {
                          shuttleData = value.data()
                        });

                        isPickupDropoffVisible = true;
                      }
                      else{
                        isPickupDropoffVisible = false;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Please select a route"),
                        ));
                      }


                    })
                  },)
              ),

              Visibility(
                visible: isPickupDropoffVisible,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 5, left: 25, right: 20), //apply padding to all four sides
                        child: Text("For...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
                    ),

                    Padding(
                        padding: EdgeInsets.only(bottom: 30, left: 25, right: 20, top: 5), //apply padding to all four sides
                        child: BookingDropdownLayout(items: pickupDropoff, onItemSelected: (value)=> {
                          setState(() {
                            isTimeLocationVisible = false;
                            listOfTime = [];
                            listOfLocation = [];
                            if(value == "pickup"){
                              for(int i = 0; i < shuttleData["pickupTime"].length; i++){
                                listOfTime.add(shuttleData["pickupTime"][i]);
                              }
                            }
                            else{
                              for(int i = 0; i < shuttleData["dropoffTime"].length; i++){
                                listOfTime.add(shuttleData["dropoffTime"][i]);
                              }
                            }

                            for(int i = 0; i < shuttleData["route"].length; i++){
                              listOfLocation.add({
                                "display":shuttleData["route"][i]["display"],
                                "value": {
                                  "longitude": shuttleData["route"][i]["value"]["longitude"],
                                  "latitude": shuttleData["route"][i]["value"]["latitude"]
                                }.toString()
                              });
                            }

                            print(listOfTime);
                            isTimeLocationVisible = true;
                          })
                        },)
                    )
                  ]
                )
              ),

              Visibility(
                  visible: isTimeLocationVisible,
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
                          child: BookingDropdownLayout(items: listOfTime, onItemSelected: (value)=>{

                          },)
                      ),

                      Padding(
                          padding: EdgeInsets.only(bottom: 5, left: 25, right: 20), //apply padding to all four sides
                          child: Text("At location...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkblue))
                      ),

                      Padding(
                          padding: EdgeInsets.only(bottom: 5, left: 25, right: 20, top: 10), //apply padding to all four sides
                          child: BookingDropdownLayout(items: listOfLocation, onItemSelected: (value)=>{

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