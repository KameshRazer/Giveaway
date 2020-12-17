import 'package:Giveaway/Fragments/HomeFragment/CharityList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Giveaway/components/separator.dart';
import 'package:Giveaway/Fragments/HomeFragment/textStyle.dart';

class DetailPage extends StatelessWidget {
  final DocumentSnapshot charity;
  final backImgURL =
      "https://cdn.givingcompass.org/wp-content/uploads/2017/12/19171044/How-The-Tax-Bill-Rewrite-Could-Impact-Charitable-Giving.jpg";
  DetailPage(this.charity);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        constraints: new BoxConstraints.expand(),
        color: new Color(0xFF736AB7),
        child: new Stack(
          children: <Widget>[
            getBackground(),
            getGradient(),
            getContent(),
            getToolbar(context),
            getButton(context),
          ],
        ),
      ),
    );
  }

  Container getBackground() {
    return new Container(
      child: new Image.network(
        backImgURL,
        fit: BoxFit.cover,
        height: 300.0,
      ),
      constraints: new BoxConstraints.expand(height: 295.0),
    );
  }

  Container getGradient() {
    return new Container(
      margin: new EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[new Color(0x00736AB7), new Color(0xFF736AB7)],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Container getContent() {
    final _overviewTitle = "Overview".toUpperCase();
    return new Container(
      child: new ListView(
        padding: new EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
          new CharityList(
            charity,
            horizontal: false,
          ),
          new Container(
            padding: new EdgeInsets.symmetric(horizontal: 32.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  _overviewTitle,
                  style: Style.headerTextStyle,
                ),
                new Separator(),
                new Text(charity['description'], style: Style.commonTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: new BackButton(color: Colors.white),
    );
  }

  Container getButton(BuildContext context) {
    return new Container(
      child: new Align(
        alignment: Alignment.bottomCenter,
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/donateForm');
          },
          child: const Text('Donate Now', style: TextStyle(fontSize: 20)),
          color: Colors.white,
          textColor: Colors.black,
          elevation: 5,
        ),
      ),
    );
  }
}
