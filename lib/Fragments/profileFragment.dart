import 'package:flutter/material.dart';

class ProfileFragment extends StatefulWidget {
  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(30.0),
      child: Text(
        "Profile Page",
        style: TextStyle(
          color: Colors.green,
        ),
      ),
    ));
  }
}
