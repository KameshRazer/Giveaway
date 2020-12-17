import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Giveaway/components/separator.dart';
import 'package:Giveaway/Fragments/HomeFragment/charityDescription.dart';
import 'package:Giveaway/Fragments/HomeFragment/textStyle.dart';

class CharityList extends StatelessWidget {
  final DocumentSnapshot charity;
  final bool horizontal;

  CharityList(this.charity, {this.horizontal = true});

  CharityList.vertical(this.charity) : horizontal = false;

  @override
  Widget build(BuildContext context) {
    final planetThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: horizontal ? 9.0 : 43.0),
      alignment:
          horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: new Hero(
          tag: "charity-hero-${charity.id}",
          child: new CircleAvatar(
            radius: horizontal ? 25.0 : 43.0,
            backgroundColor: Colors.black,
            backgroundImage: NetworkImage(charity['imgurl']),
          )),
    );

    // Widget _planetValue({String value}) {
    //   return new Container(
    //     child: new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
    //       // new Image.asset(image, height: 12.0),
    //       new Container(width: 8.0),
    //       new Text("11", style: Style.smallTextStyle),
    //     ]),
    //   );
    // }

    final planetCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(
          horizontal ? 42.0 : 10.0, horizontal ? 8.0 : 42.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment:
            horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          new Container(height: 3.0),
          new Text(charity['name'], style: Style.titleTextStyle),
          new Container(height: 4.0),
          new Text(charity['location'], style: Style.commonTextStyle),
        ],
      ),
    );

    final planetCard = new Container(
      child: planetCardContent,
      height: horizontal ? 69.0 : 134.0,
      margin: horizontal
          ? new EdgeInsets.only(left: 25.0)
          : new EdgeInsets.only(top: 92.0),
      decoration: new BoxDecoration(
        color: new Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 30.0,
            offset: new Offset(0.0, 5.0),
          ),
        ],
      ),
    );

    return new GestureDetector(
        onTap: horizontal
            ? () => Navigator.of(context).push(
                  new PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new DetailPage(charity),
                    transitionsBuilder: (context, animation, secondaryAnimation,
                            child) =>
                        new FadeTransition(opacity: animation, child: child),
                  ),
                )
            : null,
        child: new Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
          child: new Stack(
            children: <Widget>[
              planetCard,
              planetThumbnail,
            ],
          ),
        ));
  }
}
