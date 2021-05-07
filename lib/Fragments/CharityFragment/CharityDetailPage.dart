import 'package:GiveLife/Fragments/CharityFragment/CharityList.dart';
import 'package:GiveLife/Fragments/DonateFormFragment/DonateFormFragment.dart';
import 'package:flutter/material.dart';
import 'Charity.dart';
import 'CharityList.dart';
import 'package:GiveLife/Components/separator.dart';
import 'package:GiveLife/Components/text_style.dart';

class DetailPage extends StatelessWidget {
  final Charity charity;

  DetailPage(this.charity);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        constraints: new BoxConstraints.expand(),
        color: new Color(0xFF736AB7),
        child: new Stack(
          children: <Widget>[
            _getBackground(),
            _getGradient(),
            _getContent(),
            _getToolbar(context),
            _getButton(context)
          ],
        ),
      ),
    );
  }

  Container _getBackground() {
    return new Container(
      child: new Image.network(
        charity.picture,
        fit: BoxFit.cover,
        height: 300.0,
      ),
      constraints: new BoxConstraints.expand(height: 295.0),
    );
  }

  Container _getGradient() {
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

  Container _getContent() {
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
                new Text(charity.description, style: Style.commonTextStyle),
                new SizedBox(
                  height: 15,
                ),
                new Text("ADDRESS", style: Style.headerTextStyle),
                new Separator(),
                new Text(
                  charity.address,
                  style: Style.commonTextStyle,
                ),
                new SizedBox(
                  height: 15,
                ),
                new Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      charity.phoneNo,
                      style: Style.commonTextStyle,
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: new BackButton(color: Colors.white),
    );
  }

  Container _getButton(BuildContext context) {
    return new Container(
      child: new Align(
        alignment: Alignment.bottomCenter,
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DonateFormFragment(
                        type: "Private",
                        charityId: charity.id,
                      )),
            );
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
