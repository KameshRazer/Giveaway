import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'BottomView.dart';
// import 'package:GiveLife/Components/Notification.dart';

class BestDonationWidget extends StatefulWidget {
  final String userType;
  BestDonationWidget(this.userType);
  @override
  _BestDonationWidgetState createState() => _BestDonationWidgetState();
}

class _BestDonationWidgetState extends State<BestDonationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  (widget.userType == 'Public')
                      ? "Your Donation's"
                      : "Your Request",
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3a3a3b),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: BestDonationList(widget.userType),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class BestDonationTiles extends StatefulWidget {
  String name;
  String imageUrl = "assets/images/topmenu/ic_elec.png";
  double rating;
  String donateId;
  String status;
  String slug;
  String userType;
  BestDonationTiles(this.name, this.imageUrl, this.rating, this.donateId,
      this.status, this.slug, this.userType);

  @override
  BestDonationTilesState createState() => BestDonationTilesState();
}

class BestDonationTilesState extends State<BestDonationTiles> {
  // String name;
  // String imageUrl;
  // double rating;
  // String donateId;
  // String status;
  // String slug;

  String Alertmsg1 = "Lets Wait for Some time";

  Future<void> _showMyDialog(BuildContext context, String docid, String text1,
      String text2, String text3) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text1),
                Text(text2),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: RaisedButton(
                color: Colors.green,
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            if (text3 != "Ok")
              Center(
                child: text3 != "Repost"
                    ? RaisedButton(
                        color: Colors.green,
                        child: Text(text3),
                        onPressed: () {
                          DocumentReference ds = FirebaseFirestore.instance
                              .collection('Donation')
                              .doc(docid);
                          ds.update({"Status": "Accepted"});
                          if (this.mounted)
                            setState(() {
                              widget.status = "Accepted";
                            });
                          Navigator.of(context).pop();
                        },
                      )
                    : Center(
                        child: Row(
                          children: <Widget>[
                            RaisedButton(
                                color: Colors.green,
                                child: Text("Repost"),
                                onPressed: () {
                                  DocumentReference ds = FirebaseFirestore
                                      .instance
                                      .collection('Donation')
                                      .doc(docid);
                                  ds.update({"Status": "Posted"});
                                  if (this.mounted)
                                    setState(() {
                                      widget.status = "Posted";
                                    });
                                  Navigator.of(context).pop();
                                }),
                            SizedBox(
                              width: 10,
                            ),
                            RaisedButton(
                                color: Colors.green,
                                child: Text("Delivered"),
                                onPressed: () {
                                  DocumentReference ds = FirebaseFirestore
                                      .instance
                                      .collection('Donation')
                                      .doc(docid);
                                  ds.update({"Status": "Delivered"});
                                  if (this.mounted)
                                    setState(() {
                                      widget.status = "Delivered";
                                    });
                                  Navigator.of(context).pop();
                                })
                          ],
                        ),
                      ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                width: deviceSize.width * 0.75,
                child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => DetailsPage("hello ", "he")),
                      // );
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return Container(
                              height: 900,
                              child: DetailsPage(
                                  widget.userType, widget.donateId));
                        },
                      );
                    },
                    child: Row(children: [
                      Container(
                          // color: Colors.green,
                          height: 75.0,
                          width: 75.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              color: Color(0xFFFFE3DF)),
                          child: Center(
                              child: Image.asset(widget.imageUrl,
                                  height: 50.0, width: 50.0))),
                      SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.name,
                              style: GoogleFonts.notoSans(
                                  fontSize: 14.0, fontWeight: FontWeight.w400)),
                          Row(
                            children: <Widget>[
                              Text(
                                'Status',
                                style: GoogleFonts.lato(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    textStyle:
                                        TextStyle(color: Color(0xFFF68D7F))),
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                widget.status,
                                style: GoogleFonts.lato(
                                    fontSize: 14.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                    textStyle: TextStyle(
                                        color: Colors.grey.withOpacity(0.4))),
                              )
                            ],
                          )
                        ],
                      )
                    ]))),
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                if (widget.status == "Posted") {
                  _showMyDialog(
                      context,
                      widget.donateId,
                      (widget.userType == 'Public')
                          ? "Your Donation Has not been Requested Yet!!"
                          : "Your Request Has not been Accepted Yet!!",
                      'Lets Wait for Some Time',
                      'Ok');
                } else if (widget.status == "Requested") {
                  _showMyDialog(
                      context,
                      widget.donateId,
                      (widget.userType == 'Public')
                          ? 'Your Donation Has been Requested!!'
                          : 'Your Request Has been Accepted!!',
                      'Would you like to approve this Request?',
                      'Accept');
                } else {
                  _showMyDialog(
                      context,
                      widget.donateId,
                      (widget.userType == 'Public')
                          ? 'Item Delivered Successfully??'
                          : 'Item Received Successfully??',
                      '',
                      'Repost');
                }
              },
              child:
                  Center(child: Icon(Icons.track_changes, color: Colors.white)),
              backgroundColor: Color(0xFFFE7D6A),
            )
          ],
        ));
  }
}

class BestDonationList extends StatefulWidget {
  String userType;
  BestDonationList(this.userType);
  @override
  _BestDonationListState createState() => _BestDonationListState();
}

class _BestDonationListState extends State<BestDonationList> {
  List<BestDonationTiles> Items = [];
  Readrequests() {
    String id = FirebaseAuth.instance.currentUser.uid;
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(id);
    docRef.get().then((doc) {
      if (doc.exists && doc.data().containsKey('DonationCart')) {
        var elt = doc.data();
        elt['DonationCart'].forEach((elt) {
          // print(elt);
          DocumentReference ds =
              FirebaseFirestore.instance.collection('Donation').doc(elt);
          ds.get().then((value) {
            if (value.exists) {
              String donationid = value.id;
              var elt = value.data();
              if (this.mounted)
                setState(() {
                  if (elt['Status'] != 'Delivered') {
                    Items.add(BestDonationTiles(
                        elt['Itemname'],
                        "assets/images/topmenu/ic_elec.png",
                        4.9,
                        donationid,
                        elt['Status'],
                        "",
                        widget.userType));
                  }
                });
            }
          }).catchError(
              (err) => {print("error-best donation 289${err.message}")});
        });
      } else {
        // doc.data() will be undefined in this case
        print("No such document!");
      }
    }).catchError((error) {
      print("BesDonationWidget 301: Error");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Readrequests();
    if (this.mounted)
      setState(() {
        Items.sort((a, b) => b.status.compareTo(a.status));
      });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Items.length,
      itemBuilder: (context, index) => _builder(index),
    );
  }

  _builder(int index) {
    BestDonationTiles _card = Items[index];
    return _card;
  }
}
