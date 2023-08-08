import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class BookingDropdownLayout extends StatefulWidget {
  List<String> items = [];
  BookingDropdownLayout({Key? key, required this.items}) : super(key: key);

  @override
  State<BookingDropdownLayout> createState() => _BookingDropdownLayoutState();
}

class _BookingDropdownLayoutState extends State<BookingDropdownLayout> {
  String dropdownValue = "";

  @override
  void initState() {
    dropdownValue = widget.items.first;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5),
          boxShadow: <BoxShadow>[
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.10), //shadow for button
            blurRadius: 5) //blur radius of shadow
      ]),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            elevation: 16,
            style: const TextStyle(color: darkblue),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                print("NEW VALUE: " + dropdownValue);
                dropdownValue = value!;
              });
            },
            items: widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      )
    );
  }
}
