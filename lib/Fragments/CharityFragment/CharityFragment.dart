import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:GiveLife/Fragments/CharityFragment/CharityList.dart';
import 'Charity.dart';

class CharityFragment extends StatefulWidget {
  @override
  CharityFragmentState createState() => CharityFragmentState();
}

// class CharityFragmentState extends State<CharityFragment> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             'Charity Fragment',
//             style: Theme.of(context).textTheme.headline4,
//           ),
//         ],
//       ),
//     ));
//   }
// }
class CharityFragmentState extends State<CharityFragment> {
  var charityMainList = new List<Charity>();
  var charityDisplayList = new List<Charity>();
  bool progressController = true;
  bool isSearchFinished = false;
  String charityType = "All";

  Future getList() async {
    await FirebaseFirestore.instance.collection('charity').get().then((value) {
      value.docs.forEach((doc) {
        charityMainList.add(Charity(
            id: doc.id,
            name: doc['name'],
            location: doc['location'],
            address: doc['address'],
            phoneNo: doc['phone'],
            image: doc['imgurl'],
            description: doc['description'],
            picture: doc['imgurl'],
            tag: doc['tag']));
      });
      // setState(() {
      progressController = false;
      searchDataInList("");
      // });
      // searchDataInList("");
    });
  }

  void searchDataInList(String value) {
    charityDisplayList.clear();
    for (Charity charity in charityMainList) {
      if (charity.location.toLowerCase().contains(value.toLowerCase())) {
        charityDisplayList.add(charity);
      }
    }
    if (this.mounted)
      setState(() {
        if (charityDisplayList.isEmpty) {
          isSearchFinished = false;
        } else {
          isSearchFinished = true;
        }
      });
  }

  void searchCategory(String type) {
    charityDisplayList.clear();
    for (Charity charity in charityMainList) {
      if (charity.tag.contains(type)) {
        charityDisplayList.add(charity);
      }
    }
    if (this.mounted)
      setState(() {
        if (charityDisplayList.isEmpty) {
          isSearchFinished = false;
        } else {
          isSearchFinished = true;
        }
      });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchText = new TextEditingController();
    var screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          'Charity',
          style: TextStyle(
            // fontSize: 25.ssp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                isSearchFinished = false;
              });
              searchCategory(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("All"),
                  value: "All",
                ),
                PopupMenuItem(
                  child: Text("Child Home"),
                  value: "Child Home",
                ),
                PopupMenuItem(
                  child: Text("OldAge Home"),
                  value: "OldAge Home",
                ),
                PopupMenuItem(
                  child: Text("Physically Challenged"),
                  value: "Physically Challenged",
                ),
              ];
            },
          )
        ],
        backgroundColor: Colors.green,
      ),
      body: new Column(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
            child: TextField(
              controller: searchText,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(
                    width: 0,
                    color: Color(0xFFfb3132),
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                suffixIcon: GestureDetector(
                  onTap: () {
                    // print(searchText.text);
                    searchDataInList(searchText.text);
                  },
                  child: Icon(
                    Icons.search,
                    color: Color(0xFFfb3132),
                  ),
                ),
                fillColor: Color(0xFFFAFAFA),
                prefixIcon: Icon(
                  Icons.sort,
                  color: Color(0xFFfb3132),
                ),
                hintStyle:
                    new TextStyle(color: Color(0xFFd0cece), fontSize: 18),
                hintText: "Enter city name . . .",
              ),
            ),
          ),
          progressController
              ? CircularProgressIndicator()
              : new Expanded(
                  child: new Container(
                    color: Colors.white,
                    child: new CustomScrollView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        new SliverPadding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenSize.height * 0.01),
                          sliver: new SliverList(
                            delegate: new SliverChildBuilderDelegate(
                              (context, index) => new CharityList(
                                  isSearchFinished
                                      ? charityDisplayList[index]
                                      : charityMainList[index]),
                              childCount: isSearchFinished
                                  ? charityDisplayList.length
                                  : charityMainList.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
