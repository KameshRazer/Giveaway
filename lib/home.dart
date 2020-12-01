import 'package:flutter/material.dart';
import 'Fragments/donateFormFragment.dart';
import 'Fragments/homeFragment.dart';
import 'Fragments/profileFragment.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  Widget showFragment = new HomeFragment();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.add, size: 25),
            Icon(Icons.perm_identity, size: 20),
          ],
          color: Colors.green,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (int tappedindex) {
            setState(() {
              showFragment = fragmentChooser(tappedindex);
            });
          },
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: showFragment,
          ),
        ));
  }

//Return Fragment for Home Screen
  Widget fragmentChooser(int index) {
    switch (index) {
      case 0:
        return new HomeFragment();
        break;
      case 1:
        return new DonateFormFragment();
        break;
      case 2:
        return new ProfileFragment();
        break;
      default:
        return new Container(
          child: new Center(
            child: new Text(
              'No Page found',
              style: new TextStyle(fontSize: 30),
            ),
          ),
        );
    }
  }
}
