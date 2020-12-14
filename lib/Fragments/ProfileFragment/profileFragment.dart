import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:Giveaway/components/constants.dart';
import 'package:Giveaway/Fragments/ProfileFragment/Profile_list_item.dart';
import 'package:Giveaway/widgets/TimelineWidget.dart';

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
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);

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
            height: kSpacingUnit.w * 10,
            width: kSpacingUnit.w * 10,
            margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: kSpacingUnit.w * 5,
                  backgroundImage: NetworkImage(strImageURL),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: kSpacingUnit.w * 2.5,
                    width: kSpacingUnit.w * 2.5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      heightFactor: kSpacingUnit.w * 1.5,
                      widthFactor: kSpacingUnit.w * 1.5,
                      child: Icon(
                        LineAwesomeIcons.pen,
                        color: kDarkPrimaryColor,
                        size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Text(
            name,
            style: kTitleTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 0.5),
          Text(
            email,
            style: kCaptionTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 2),
        ],
      ),
    );
    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: kSpacingUnit.w * 3),
        profileInfo,
        SizedBox(width: kSpacingUnit.w * 3),
      ],
    );

    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                SizedBox(height: kSpacingUnit.w * 5),
                header,
                Expanded(
                  child: ListView(
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
                        icon: LineAwesomeIcons.question_circle,
                        text: 'Help & Support',
                      ),
                      GestureDetector(
                        onTap: () {},
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
