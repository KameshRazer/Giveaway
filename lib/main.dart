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
      },
      home: new SignInScreen(),
    );
  }
}
