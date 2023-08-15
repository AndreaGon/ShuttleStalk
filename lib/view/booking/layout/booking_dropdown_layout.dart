import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../res/colors.dart';

class BookingDropdownLayout extends StatefulWidget {
  List<Map<dynamic, dynamic>> items;
  Function(String) onItemSelected;

  BookingDropdownLayout({Key? key, required this.items, required this.onItemSelected}) : super(key: key);

  @override
  State<BookingDropdownLayout> createState() => _BookingDropdownLayoutState();
}

class _BookingDropdownLayoutState extends State<BookingDropdownLayout> {
  String dropdownValue = "";

  @override
  void initState() {
    dropdownValue = (widget.items.first["value"].toString());
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
          child: DropdownButton(
            isExpanded: true,
            value: dropdownValue,
            elevation: 16,
            style: const TextStyle(color: darkblue),
            onChanged: (value) {

              setState(() {
                dropdownValue = value!.toString();
                widget.onItemSelected(dropdownValue);
              });
            },
            items: widget.items.map((value) {
              return DropdownMenuItem(
                value: value['value'],
                child: Text(value["display"]),
              );
            }).toList(),
          ),
        ),
      )
    );
  }
}
