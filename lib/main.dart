import 'package:Giveaway/Fragments/DonateFormFragment/donateFormFragment.dart';
import 'package:Giveaway/home.dart';
import 'package:Giveaway/signup.dart';
import 'package:flutter/material.dart';
import 'signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signin': (BuildContext context) => new SignInScreen(),
        '/signup': (BuildContext context) => new SignupPage(),
        '/home': (BuildContext context) => new HomeScreen(),
        '/donateForm': (BuildContext context) =>
            new DonateFormFragment('Private'),
      },
      home: new SignInScreen(),
    );
  }
}
