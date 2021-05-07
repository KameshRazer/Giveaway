import 'package:flutter/material.dart';
import 'package:GiveLife/Widgets/BestDonationWidget.dart';
import 'package:GiveLife/Widgets/DonationDetailsPage.dart';
import 'package:GiveLife/Animations/ScaleRoute.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class HomeFragment extends StatefulWidget {
  final String userType;
  HomeFragment(this.userType);
  @override
  HomeFragmentState createState() => HomeFragmentState();
}

// class HomeFragmentState extends State<HomeFragment> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             'Home Fragment',
//             style: Theme.of(context).textTheme.headline4,
//           ),
//         ],
//       ),
//     ));
//   }
// }

class HomeFragmentState extends State<HomeFragment> {
  String Category = "";
  String Cur_User_ID = FirebaseAuth.instance.currentUser.uid;
  List<PopularDonationTiles> _Itemdetails = [];
  List<PopularDonationTiles> ItemRequestDetails = [];
  List<PopularDonationTiles> charityDonationDetails = [];

  bool showChairytDonation = false;
  bool isItemLoading = true;
  double lati = 0.0, longi = 0.0;
  Future populateCharityDonationItems() async {
    await Firebase.initializeApp();
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    var s = FirebaseFirestore.instance
        .collection('Donation')
        .where('Type', isEqualTo: 'Private')
        .snapshots();
    s.toList();
    if (this.mounted)
      setState(() {
        charityDonationDetails.clear();
      });
    s.forEach((element) {
      element.docs.forEach((value) {
        var data = value.data();

        if (data.containsKey('Benefactor')) {
          if (data['Benefactor'] == Cur_User_ID && data['Status'] == 'Posted') {
            String id = value.id;
            GeoPoint loc = data['locationpoint'];
            String imageurl = "ic_popular_food_1";
            switch (data['Itemtype']) {
              case 'Clothes':
                imageurl = "ic_popular_food_3";
                break;
              case 'Education':
                imageurl = "ic_popular_food_4";
                break;
              case 'Medicine':
                imageurl = "ic_popular_food_6";
                break;
              case 'Food':
                imageurl = "ic_popular_food_1";
                break;
              default:
                imageurl = "ic_popular_food_5";
                break;
            }
            Geolocator()
                .distanceBetween(position.latitude, position.longitude,
                    loc.latitude, loc.longitude)
                .then((value) {
              charityDonationDetails.add(PopularDonationTiles(
                Id: id,
                name: data['Itemname'],
                imageUrl: imageurl,
                rating: 'Distance',
                numberOfKM: (value / 1000).round().toString() + 'Km',
                quantity: data['Itemquantity'],
                productDescription: data['ItemDescription'],
                productLocation: data['Itemloc'],
                productContact: data['Itemcontact'],
                productHost: data['PostedTime'].toString(),
                mode: 'Public',
              ));
            });
          }
        }
      });
    });
    if (this.mounted)
      setState(() {
        showChairytDonation = true;
      });
  }

  Future populateitems() async {
    await Firebase.initializeApp();
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var s = FirebaseFirestore.instance
        .collection('Donation')
        // .where("Type", isEqualTo: "Public")
        .snapshots();
    s.toList();
    if (this.mounted)
      setState(() {
        _Itemdetails.clear();
        ItemRequestDetails.clear();
      });
    s.forEach((element) {
      element.docs.forEach((element) {
        String id = element.id;
        var elt = element.data();
        GeoPoint loc = elt['locationpoint'];
        String imageurl = "ic_popular_food_1";
        switch (elt['Itemtype']) {
          case 'Clothes':
            imageurl = "ic_popular_food_3";
            break;
          case 'Education':
            imageurl = "ic_popular_food_4";
            break;
          case 'Medicine':
            imageurl = "ic_popular_food_6";
            break;
          case 'Food':
            imageurl = "ic_popular_food_1";
            break;
          default:
            imageurl = "ic_popular_food_5";
            break;
        }
        // print("$Category --> ${elt['Itemtype']}");
        if (Category == "") {
          Geolocator()
              .distanceBetween(position.latitude, position.longitude,
                  loc.latitude, loc.longitude)
              .then((value) => {
                    if ((value / 1000).round() < 25 &&
                        elt['Benefactor'] == null &&
                        elt['Donor'] != Cur_User_ID)
                      {
                        if (this.mounted)
                          setState(() {
                            if (elt['Type'] == 'Public')
                              _Itemdetails.add(PopularDonationTiles(
                                Id: id,
                                name: elt['Itemname'],
                                imageUrl: imageurl,
                                rating: 'Distance',
                                numberOfKM:
                                    (value / 1000).round().toString() + 'Km',
                                quantity: elt['Itemquantity'],
                                productDescription: elt['ItemDescription'],
                                productLocation: elt['Itemloc'],
                                productContact: elt['Itemcontact'],
                                productHost: elt['PostedTime'].toString(),
                                mode: 'Public',
                              ));
                            else
                              ItemRequestDetails.add(PopularDonationTiles(
                                Id: id,
                                name: elt['Itemname'],
                                imageUrl: imageurl,
                                rating: 'Distance',
                                numberOfKM:
                                    (value / 1000).round().toString() + 'Km',
                                quantity: elt['Itemquantity'],
                                productDescription: elt['ItemDescription'],
                                productLocation: elt['Itemloc'],
                                productContact: elt['Itemcontact'],
                                productHost: elt['PostedTime'].toString(),
                                mode: 'Private',
                              ));
                          })
                      }
                  })
              .catchError((onError) => {print("1 ->" + onError.toString())});
        } else if (Category == elt['Itemtype']) {
          Geolocator()
              .distanceBetween(position.latitude, position.longitude,
                  loc.latitude, loc.longitude)
              .then((value) {
            var cur_time = DateTime.now();
            // print(elt['PostedTime']);
            // print(cur_time);
            // print("ee");
            var dDay = DateTime.parse(elt['PostedTime']);
            Duration difference = cur_time.difference(dDay);
            if ((value / 1000).round() < 25 &&
                elt['Benefactor'] == null &&
                elt['Donor'] != Cur_User_ID) {
              if (this.mounted)
                setState(() {
                  if (elt['Itemtype'] == 'Food' &&
                      difference.inHours < int.parse(elt['Expire'])) {
                    if (elt['Type'] == 'Public')
                      _Itemdetails.add(PopularDonationTiles(
                        Id: id,
                        name: elt['Itemname'],
                        imageUrl: imageurl,
                        rating: 'Distance',
                        numberOfKM: (value / 1000).round().toString() + 'Km',
                        quantity: elt['Itemquantity'],
                        productDescription: elt['ItemDescription'],
                        productLocation: elt['Itemloc'],
                        productContact: elt['Itemcontact'],
                        productHost:
                            DateFormat('kk:mm:ss \n EEE d MMM').format(dDay),
                        mode: 'Public',
                      ));
                    else
                      ItemRequestDetails.add(PopularDonationTiles(
                        Id: id,
                        name: elt['Itemname'],
                        imageUrl: imageurl,
                        rating: 'Distance',
                        numberOfKM: (value / 1000).round().toString() + 'Km',
                        quantity: elt['Itemquantity'],
                        productDescription: elt['ItemDescription'],
                        productLocation: elt['Itemloc'],
                        productContact: elt['Itemcontact'],
                        productHost:
                            DateFormat('kk:mm:ss \n EEE d MMM').format(dDay),
                        mode: 'Private',
                      ));
                  } else if (elt['Itemtype'] != 'Food') {
                    if (elt['Type'] == 'Public')
                      _Itemdetails.add(PopularDonationTiles(
                        Id: id,
                        name: elt['Itemname'],
                        imageUrl: imageurl,
                        rating: 'Distance',
                        numberOfKM: (value / 1000).round().toString() + 'Km',
                        quantity: elt['Itemquantity'],
                        productDescription: elt['ItemDescription'],
                        productLocation: elt['Itemloc'],
                        productContact: elt['Itemcontact'],
                        productHost:
                            DateFormat('kk:mm:ss \n EEE d MMM').format(dDay),
                        mode: 'Public',
                      ));
                    else
                      ItemRequestDetails.add(PopularDonationTiles(
                        Id: id,
                        name: elt['Itemname'],
                        imageUrl: imageurl,
                        rating: 'Distance',
                        numberOfKM: (value / 1000).round().toString() + 'Km',
                        quantity: elt['Itemquantity'],
                        productDescription: elt['ItemDescription'],
                        productLocation: elt['Itemloc'],
                        productContact: elt['Itemcontact'],
                        productHost:
                            DateFormat('kk:mm:ss \n EEE d MMM').format(dDay),
                        mode: 'Private',
                      ));
                  }
                });
            }
          }).catchError((onError) =>
                  {print("210 HomeFragment ->" + onError.toString())});
        }
      });
    });
    if (this.mounted)
      setState(() {
        isItemLoading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    Category = "";
    populateitems();
    if (widget.userType == 'Private') populateCharityDonationItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        //backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
        title: Text(
          "What you need?",
          style: TextStyle(
              color: Color(0xFF3a3737),
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        brightness: Brightness.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // SearchWidget(),
            Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.only(left: 19.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (this.mounted)
                          setState(() {
                            Category = "Food";

                            populateitems();
                          });
                      },
                      child: TopMenuTiles(
                          name: "Food", imageUrl: "ic_burger", slug: ""),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (this.mounted)
                          setState(() {
                            Category = "Clothes";

                            populateitems();
                          });
                      },
                      child: TopMenuTiles(
                          name: "Clothes", imageUrl: "ic_clothes", slug: ""),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (this.mounted)
                          setState(() {
                            Category = "Education";

                            populateitems();
                          });
                      },
                      child: TopMenuTiles(
                          name: "Education", imageUrl: "ic_books", slug: ""),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (this.mounted)
                          setState(() {
                            Category = "Electronics";

                            populateitems();
                          });
                      },
                      child: TopMenuTiles(
                          name: "Electronics", imageUrl: "ic_elec", slug: ""),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (this.mounted)
                          setState(() {
                            Category = "Others";

                            populateitems();
                          });
                      },
                      child: TopMenuTiles(
                          name: "Others", imageUrl: "ic_others", slug: ""),
                    ),
                  ],
                ),
              ),
            ), //TopMenus
            if (widget.userType != 'Private')
              Container(
                height: 265,
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    PopularDonationTitle(myTitle: "Help Us"),
                    if (ItemRequestDetails.length == 0)
                      Center(
                          heightFactor: 10,
                          child: (isItemLoading)
                              ? SizedBox(
                                  child: CircularProgressIndicator(),
                                  width: 20,
                                  height: 20,
                                )
                              : Text("Request's not found"))
                    else
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ItemRequestDetails.length,
                          itemBuilder: (context, index) =>
                              _builder(ItemRequestDetails[index]),
                        ),
                      )
                  ],
                ),
              ),

            //PopularDonationsWidget(searchCategory: Category),

            Container(
              height: 265,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  PopularDonationTitle(
                    myTitle: "Donation's near you",
                  ),
                  if (_Itemdetails.length == 0)
                    Center(
                        heightFactor: 10,
                        child: (isItemLoading)
                            ? SizedBox(
                                child: CircularProgressIndicator(),
                                width: 20,
                                height: 20,
                              )
                            : Text("Donation's not found"))
                  else
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _Itemdetails.length,
                        itemBuilder: (context, index) =>
                            _builder(_Itemdetails[index]),
                      ),
                    )
                ],
              ),
            ),

            if (widget.userType == 'Private')
              Container(
                height: 265,
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    PopularDonationTitle(myTitle: "Donation For You"),
                    if (charityDonationDetails.length == 0)
                      Center(
                          heightFactor: 10,
                          child: (!showChairytDonation)
                              ? SizedBox(
                                  child: CircularProgressIndicator(),
                                  width: 20,
                                  height: 20,
                                )
                              : Text("Donation's not found"))
                    else
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: charityDonationDetails.length,
                          itemBuilder: (context, index) =>
                              _builder(charityDonationDetails[index]),
                        ),
                      )
                  ],
                ),
              ),
            BestDonationWidget(widget.userType),
          ],
        ),
      ),
    );
  }

  _builder(var data) {
    PopularDonationTiles _card = data;
    return _card;
  }
}

class TopMenuTiles extends StatelessWidget {
  String name;
  String imageUrl;
  String slug;

  TopMenuTiles(
      {Key key,
      @required this.name,
      @required this.imageUrl,
      @required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            decoration: new BoxDecoration(boxShadow: [
              new BoxShadow(
                color: Color(0xFFfae3e2),
                blurRadius: 25.0,
                offset: Offset(0.0, 0.75),
              ),
            ]),
            child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(3.0),
                  ),
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  child: Center(
                      child: Image.asset(
                    'assets/images/topmenu/' + imageUrl + ".png",
                    width: 24,
                    height: 24,
                  )),
                )),
          ),
          Text(name,
              style: TextStyle(
                  color: Color(0xFF6e6e71),
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

class PopularDonationTiles extends StatelessWidget {
  String Id;
  String name;
  String imageUrl;
  String rating;
  String numberOfKM;
  String quantity;
  String productDescription;
  String productLocation;
  String productContact;
  String productHost;
  String mode;

  PopularDonationTiles(
      {Key key,
      @required this.Id,
      @required this.name,
      @required this.imageUrl,
      @required this.rating,
      @required this.numberOfKM,
      @required this.quantity,
      @required this.productDescription,
      @required this.productLocation,
      @required this.productContact,
      @required this.productHost,
      @required this.mode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            ScaleRoute(
                page: DonationDetailsPage(
              productId: Id,
              productContact: productContact,
              productDescription: productDescription,
              productLocation: productLocation,
              distance: numberOfKM,
              imageUrl: imageUrl,
              productName: name,
              productQuantity: quantity,
              productHost: productHost,
              mode: mode,
            )));
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            decoration: BoxDecoration(boxShadow: [
              /* BoxShadow(
                color: Color(0xFFfae3e2),
                blurRadius: 15.0,
                offset: Offset(0, 0.75),
              ),*/
            ]),
            child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Container(
                  width: 170,
                  height: 210,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.topRight,
                              width: double.infinity,
                              padding: EdgeInsets.only(right: 5, top: 5),
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white70,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFfae3e2),
                                        blurRadius: 25.0,
                                        offset: Offset(0.0, 0.75),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Center(
                                child: Image.asset(
                              'assets/images/popular_foods/' +
                                  imageUrl +
                                  ".png",
                              width: 130,
                              height: 140,
                            )),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 5, top: 5),
                            child: Text(name,
                                style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(right: 5),
                            child: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white70,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFfae3e2),
                                      blurRadius: 25.0,
                                      offset: Offset(0.0, 0.75),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 5, top: 5),
                                child: Text(rating,
                                    style: TextStyle(
                                        color: Color(0xFF6e6e71),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400)),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 5, top: 5),
                                child: Text("($numberOfKM)",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 5, top: 5, right: 5),
                            child: Text(quantity,
                                style: TextStyle(
                                    color: Colors.lightGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          )
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class PopularDonationTitle extends StatelessWidget {
  String myTitle;
  PopularDonationTitle({Key key, @required this.myTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            myTitle,
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF3a3a3b),
                fontWeight: FontWeight.w600),
          ),
          // Text(
          //   "",
          //   style: TextStyle(
          //       fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w100),
          // )
        ],
      ),
    );
  }
}
