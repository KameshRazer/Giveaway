import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:GiveLife/Fragments/HomeFragment/HomeFragment.dart';
import 'package:GiveLife/Fragments/CharityFragment/CharityFragment.dart';
import 'package:GiveLife/Fragments/ProfileFragment/ProfileFragment.dart';
import 'package:GiveLife/Fragments/DonateFormFragment/DonateFormFragment.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;
  String type = "Public";
  GlobalKey _bottomNavigationKey = GlobalKey();
  Widget showFragment;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  FirebaseMessaging FCM = FirebaseMessaging();
  bool progressController = true;

  Future getType() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        progressController = false;
        type = value.data()['type'];
        showFragment = new HomeFragment(type);
      });
    });
  }

  saveDeviceToken() async {
    String fcmToken = await FCM.getToken();
    if (fcmToken != null)
      users.doc(currentUser.uid).update({'fcmToken': fcmToken});
  }

  @override
  void initState() {
    super.initState();
    getType();

    saveDeviceToken();
    FCM.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // final snackbar = SnackBar(
        //   content: Text(message['notification']['title']),
        //   action: SnackBarAction(
        //     label: 'Go',
        //     onPressed: () => null,
        //   ),
        // );

        // Scaffold.of(context).showSnackBar(snackbar);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.amber,
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.amber,
                child: Text('Okk'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return progressController
        ? Scaffold(
            body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Text(
                  'Loading',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ))
        : Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              key: _bottomNavigationKey,
              index: 0,
              height: 50.0,
              items: <Widget>[
                Icon(Icons.home, size: 30),
                if (type != 'Private') Icon(Icons.blur_circular, size: 25),
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
    if (index > 0 && type == 'Private') {
      index++;
    }
    switch (index) {
      case 0:
        return new HomeFragment(type);
        break;
      case 1:
        return new CharityFragment();
        break;
      case 2:
        return new DonateFormFragment(type: type);
        break;
      case 3:
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
