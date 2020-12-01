import 'package:flutter/material.dart';

class HomeFragment extends StatefulWidget {
  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(30.0),
      child: Text(
        "Home Page",
        style: TextStyle(
          color: Colors.green,
        ),
      ),
    ));
  }
}
