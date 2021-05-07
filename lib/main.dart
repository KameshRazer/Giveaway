import 'package:GiveLife/home.dart';
import 'package:GiveLife/signup.dart';
import 'package:flutter/material.dart';
import 'signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var deviceSize = MediaQuery.of(context).size;
    // ScreenUtil.init(
    //     BoxConstraints(
    //         maxWidth: deviceSize.width, maxHeight: deviceSize.height),
    //     designSize: Size(deviceSize.width, deviceSize.height),
    //     allowFontScaling: true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signin': (BuildContext context) => new SignInScreen(),
        '/signup': (BuildContext context) => new SignupPage(),
        '/home': (BuildContext context) => new HomeScreen(),
        // '/donateForm': (BuildContext context) =>
        //     new DonateFormFragment('Public'),
      },
      home: new SignInScreen(),
    );
  }
}
