import 'package:flutter/material.dart';

class DonateFormFragment extends StatefulWidget {
  @override
  DonateFragmentState createState() => DonateFragmentState();
}

class DonateFragmentState extends State<DonateFormFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(30.0),
      child: Text(
        "Donate Form Page",
        style: TextStyle(
          color: Colors.green,
        ),
      ),
    ));
  }
}
