import 'package:Giveaway/Fragments/HomeFragment/CharityList.dart';
import 'package:flutter/material.dart';

class HomeFragment extends StatefulWidget {
  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> {
  @override
  Widget build(BuildContext context) {
    return new Row(
      children: [
        Expanded(
          child: new Container(
            color: Colors.white30,
            child: CharityList(),
          ),
        ),
      ],
    );
  }
}
