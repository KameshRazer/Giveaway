import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Doodle {
  final String name;
  final String time;
  final String content;
  final String status;
  final String doodle;
  final Color iconBackground;
  final Icon icon;
  Doodle(
      {this.name,
      this.time,
      this.content,
      this.status,
      this.doodle,
      this.icon,
      this.iconBackground});
}

class TimelinePage extends StatefulWidget {
  TimelinePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final PageController pageController =
      PageController(initialPage: 1, keepPage: true);
  int pageIx = 1;

  List<Doodle> doodles = [];
  populatehistory() async {
    String id = FirebaseAuth.instance.currentUser.uid;

    var s = await FirebaseFirestore.instance.collection('Donation').snapshots();
    s.toList();
    s.forEach((element) {
      element.docs.forEach((element) {
        var elt = element.data();
        String imageurl = "assets/images/topmenu/ic_burger.png";
        switch (elt['Itemtype']) {
          case 'Clothes':
            imageurl = "assets/images/topmenu/ic_clothes.png";
            break;
          case 'Education':
            imageurl = "assets/images/topmenu/ic_books.png";
            break;
          case 'Medicine':
            imageurl = "assets/images/topmenu/ic_others.png";
            break;
          case 'Food':
            imageurl = "assets/images/topmenu/ic_burger.png";
            break;
          default:
            imageurl = "assets/images/topmenu/ic_others.png";
            break;
        }
        if (elt['Donor'] == id) {
          setState(() {
            doodles.add(Doodle(
                name: elt['Itemcontact'],
                time: elt['Itemloc'],
                content: elt['Itemname'],
                status: elt['Status'],
                doodle: imageurl,
                icon: Icon(
                  Icons.blur_circular,
                  color: Colors.white,
                ),
                iconBackground: Colors.indigo));
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    populatehistory();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      timelineModel(TimelinePosition.Center),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.green,
        ),
        body: PageView(
          onPageChanged: (i) => setState(() => pageIx = i),
          controller: pageController,
          children: pages,
        ));
  }

  timelineModel(TimelinePosition position) => Timeline.builder(
      itemBuilder: centerTimelineBuilder,
      itemCount: doodles.length,
      physics: position == TimelinePosition.Left
          ? ClampingScrollPhysics()
          : BouncingScrollPhysics(),
      position: position);

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final doodle = doodles[i];
    final textTheme = Theme.of(context).textTheme;
    return TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  doodle.doodle,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text("Item: " + doodle.content,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 15)),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  "    Contact:" + doodle.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  "Loc: " + doodle.time,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  "Status: " + doodle.status,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        position:
            i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
        isFirst: i == 0,
        isLast: i == doodles.length,
        iconBackground: doodle.iconBackground,
        icon: doodle.icon);
  }
}
