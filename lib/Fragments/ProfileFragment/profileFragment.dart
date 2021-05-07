import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:GiveLife/components/constants.dart';
import 'package:GiveLife/Fragments/ProfileFragment/Profile_list_item.dart';
import 'package:GiveLife/widgets/TimelineWidget.dart';

class Profile1 extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile1> {
  final firestoreInstance = FirebaseFirestore.instance;
  User cur_user;
  String email = "";
  String name = "Hai";
  String strImageURL =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8TeQ5iojLROQXom0AApSQbIamNDJRFDYgjw&usqp=CAU';

  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    // ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);
    var deviceSize = MediaQuery.of(context).size;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: deviceSize.width, maxHeight: deviceSize.height),
        designSize: Size(deviceSize.width, deviceSize.height),
        allowFontScaling: true);

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(currentUser.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError)
            return new Center(
              child: new Text("Something wrong"),
            );
          if (snapshot.connectionState == ConnectionState.waiting)
            return new Center(
              child: new CircularProgressIndicator(),
            );
          Map<String, dynamic> data = snapshot.data.data();
          return profileBuilder(data["Name"], data["Email"]);
        });
  }

  Widget profileBuilder(String name, String email) {
    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: 0.3.sw,
            width: 0.3.sw,
            margin: EdgeInsets.only(top: 0.010.sh),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 60.r,
                  backgroundImage: NetworkImage(strImageURL),
                ),
                Align(
                  alignment: Alignment.bottomRight / 1.37,
                  child: Container(
                    height: 0.07.sw,
                    width: 0.07.sw,
                    // color: Colors.green,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      heightFactor: 0.2.sh,
                      widthFactor: 0.2.sw,
                      child: Icon(
                        LineAwesomeIcons.pen,
                        color: kDarkPrimaryColor,
                        size: 18.ssp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0.02.sh),
          Text(
            name,
            style: kTitleTextStyle,
          ),
          SizedBox(height: 0.01.sh),
          Text(
            email,
            style: kCaptionTextStyle,
          ),
          SizedBox(height: 0.02.sh),
        ],
      ),
    );
    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 0.08.sw),
        profileInfo,
        SizedBox(width: 0.08.sw),
      ],
    );

    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'My Profile',
                style: TextStyle(
                  // fontSize: 25.ssp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.green,
            ),
            body: Column(
              children: <Widget>[
                SizedBox(height: 0.08.sh),
                header,
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ProfileListItem(
                        icon: LineAwesomeIcons.user_shield,
                        text: 'Change Password',
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimelinePage(
                                    title: 'Your GiveAway History')),
                          );
                        },
                        child: ProfileListItem(
                          icon: LineAwesomeIcons.history,
                          text: 'GiveAway History',
                        ),
                      ),
                      ProfileListItem(
                        // key: ,
                        icon: LineAwesomeIcons.question_circle,
                        text: 'Help & Support',
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushReplacementNamed('/signin');
                        },
                        child: ProfileListItem(
                          icon: LineAwesomeIcons.alternate_sign_out,
                          text: 'Logout',
                          hasNavigation: false,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: kLightTheme,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.of(context),
            home: Profile1(),
          );
        },
      ),
    );
  }
}
