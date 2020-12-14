import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CharityList extends StatelessWidget {
  final bool horizontal;
  final String imgUrl =
      "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/images/110411main_Voyager2_280_yshires.jpg";
  CharityList({this.horizontal = true});
  CharityList.vertical() : horizontal = false;

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: FirebaseFirestore.instance.collection("charity").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();
        return GestureDetector(
            onTap: () {
              print("You touched ID : ");
            },
            child: new Container(
              margin: const EdgeInsets.symmetric(
                vertical: 3.0,
                horizontal: 24.0,
              ),
              child: new ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot charity = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      print("You touched ${charity.id}");
                    },
                    child: charityCard(charity),
                  );
                },
              ),
            ));
      },
    );
  }

  Widget charityCard(DocumentSnapshot charity) {
    final charityContent = new Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        color: Colors.grey[200],
        child: ListTile(
          title: Text(charity["name"]),
          subtitle: Text("Location: ${charity["location"]}"),
        ),
      ),
    );

    final charityCard = new Container(
      child: charityContent,
      height: horizontal ? 70.0 : 15.0,
      margin: horizontal
          ? new EdgeInsets.only(left: 25.0, bottom: 10.0)
          : new EdgeInsets.only(top: 32.0),
      decoration: new BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black87,
              blurRadius: 10.0,
              offset: new Offset(0.0, 5.0),
            )
          ]),
    );

    final charityImage = new Container(
        margin: new EdgeInsets.symmetric(vertical: 10.0),
        alignment:
            horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
        child: new CircleAvatar(
          radius: 25.0,
          backgroundImage: NetworkImage(charity['imgurl']),
        ));

    return new Container(
      margin: const EdgeInsets.symmetric(
        vertical: 3.0,
        horizontal: 24.0,
      ),
      child: new Stack(
        children: <Widget>[
          charityCard,
          charityImage,
        ],
      ),
    );
  }
}
