import 'package:flutter/material.dart';
import 'package:GiveLife/Fragments/CharityFragment/CharityDetailPage.dart';
import 'package:GiveLife/Components/text_style.dart';
import 'Charity.dart';

class CharityList extends StatelessWidget {
  final Charity charity;
  final bool horizontal;

  CharityList(this.charity, {this.horizontal = true});

  CharityList.vertical(this.charity) : horizontal = false;

  @override
  Widget build(BuildContext context) {
    final planetThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: horizontal ? 13.0 : 30.0),
      alignment:
          horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: new Hero(
        tag: "charity-hero-${charity.id}",
        child: new CircleAvatar(
          radius: horizontal ? 22.0 : 43.0,
          backgroundColor: Colors.black,
          backgroundImage: NetworkImage(charity.picture),
        ),
      ),
    );

    final planetCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(
          horizontal ? 36.0 : 16.0, horizontal ? 6.0 : 50.0, 16.0, 10.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment:
            horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(charity.name, style: Style.titleTextStyle),
          new Container(height: 10.0),
          new Text(charity.location, style: Style.commonTextStyle),
        ],
      ),
    );

    final planetCard = new Container(
      child: planetCardContent,
      height: horizontal ? 70.0 : 134.0,
      margin: horizontal
          ? new EdgeInsets.only(left: 23.0)
          : new EdgeInsets.only(top: 72.0),
      decoration: new BoxDecoration(
        color: new Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
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
