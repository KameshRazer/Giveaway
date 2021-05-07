import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatefulWidget {
  final String type;
  final String productId;

  DetailsPage(this.type, this.productId);
  // const DetailsPage({Key key, String type, String productId}) : super(key: key);
  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  String currTime;
  TextEditingController _tasknamecont,
      _taskquantity,
      _taskunit,
      _taskloc,
      _taskcontact,
      _taskDesc,
      _taskExpire;
  double lati = 0.0, longi = 0.0;
  GeoPoint posi;
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'View'),
    Tab(text: 'Edit'),
  ];

  TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _mytasktype = 0;
  String taskval;
  String currentAddress = "address";
  Position currentPosition;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Map<String, dynamic> donationData;
  Map<String, dynamic> displayDonationData;
  Map<String, dynamic> benefactorDetails;
  var showdata = false;
  var showBenefactor = false;
  void _handleTaskType(int value) {
    if (this.mounted)
      setState(() {
        _mytasktype = value;
        switch (value) {
          case 1:
            taskval = "Food";
            break;
          case 2:
            taskval = "Clothes";
            break;
          case 3:
            taskval = "Education";
            break;
          case 4:
            taskval = "Others";
            break;
        }
      });
  }

  Future getDonationDetails() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection("Donation")
        .doc(widget.productId)
        .get()
        .then((value) {
      if (value.exists) {
        var data = value.data();
        if (this.mounted)
          setState(() {
            displayDonationData = value.data();
            showdata = true;
          });
        _tasknamecont.text = data['Itemname'];
        _taskDesc.text = data['ItemDescription'];
        _taskquantity.text = data['Itemquantity'];
        _taskunit.text =
            (data.containsKey('Itemunit')) ? data['Itemunit'] : '0';
        _taskloc.text = data['Itemloc'];
        _taskcontact.text = data['Itemcontact'];
        _taskExpire.text = (data.containsKey('Expire')) ? data['Expire'] : '0';
        taskval = data['Itemtype'];
        if (data.containsKey('Benefactor')) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(data['Benefactor'])
              .get()
              .then((value) {
            if (this.mounted)
              setState(() {
                // print(value.data());
                benefactorDetails = value.data();
                // print(benefactorDetails);
                showBenefactor = true;
              });
          });
        }

        if (this.mounted)
          setState(() {
            switch (data['Itemtype']) {
              case "Food":
                _mytasktype = 1;
                break;
              case "Clothes":
                _mytasktype = 2;
                break;
              case "Education":
                _mytasktype = 3;
                break;
              case "Others":
                _mytasktype = 4;
                break;
            }
          });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: myTabs.length);
    _tasknamecont = new TextEditingController();
    _taskquantity = new TextEditingController();
    _taskunit = new TextEditingController();
    _taskloc = new TextEditingController();
    _taskcontact = new TextEditingController();
    _taskDesc = new TextEditingController();
    _taskExpire = new TextEditingController();
    currTime = DateTime.now().toString();
    // currTime = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    getCurrentLocation();
    getDonationDetails();
  }

  getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      if (this.mounted)
        setState(() {
          currentPosition = position;
        });
      getAddressFromLatLng();
    });
  }

  getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = p[0];

      if (this.mounted)
        setState(() {
          currentAddress =
              "${place.locality},${place.subAdministrativeArea}, ${place.country}, ${place.postalCode},";
          _taskloc = new TextEditingController(text: currentAddress);
          posi = GeoPoint(p[0].position.latitude, p[0].position.longitude);
        });
    } catch (e) {
      print(e);
    }
  }

  clearTextField() {
    _tasknamecont.clear();
    _taskquantity.clear();
    _taskunit.clear();
    _taskloc.clear();
    _taskcontact.clear();
    _taskDesc.clear();
    _taskExpire.clear();
    if (this.mounted)
      setState(() {
        _mytasktype = 0;
      });
  }

  updateData() async {
    await Firebase.initializeApp();
    // print('task value $taskval');
    donationData = {
      'Itemname': _tasknamecont.text,
      'ItemDescription': _taskDesc.text,
      'Itemquantity': _taskquantity.text,
      'Itemunit': _taskunit.text,
      'Itemloc': _taskloc.text,
      'Itemcontact': _taskcontact.text,
      'Expire': _taskExpire.text,
      'Itemtype': taskval
    };
    FirebaseFirestore.instance
        .collection('Donation')
        .doc(widget.productId)
        .update(donationData);
  }

  deleteCurrentItem() async {
    await Firebase.initializeApp();
    String currenUserId = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection('Donation')
        .doc(widget.productId)
        .delete();
  }

  _makePhoneCall(String url) async {
    try {
      await launch("tel:$url");
    } catch (e) {
      print(e);
    }
    // if (await canLaunch("tel:$url")) {
    //   await launch(url);
    // } else {
    //   print("unable to call $url");
    //   // throw 'Could not launch $url';
    // }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: deviceSize.width, maxHeight: deviceSize.height),
        designSize: Size(deviceSize.width, deviceSize.height),
        allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor: Colors.green,
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          final String label = tab.text.toLowerCase();
          return (label == "view")
              ? SingleChildScrollView(
                  padding:
                      EdgeInsets.only(left: 25, top: 20, right: 15, bottom: 15),
                  child: Container(
                    // scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        if (showBenefactor)
                          new Container(
                            child: Column(
                              children: [
                                new Container(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Request Details",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 18.ssp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                new Container(
                                  width: deviceSize.width,
                                  height: 30,
                                  margin: EdgeInsets.only(left: 25),
                                  child: new Row(
                                    children: [
                                      new Container(
                                        width: deviceSize.width * 0.25,
                                        height: 30,
                                        // color: Colors.lightBlue,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Name",
                                            style: TextStyle(fontSize: 15.ssp),
                                          ),
                                        ),
                                      ),
                                      new Container(
                                          width: deviceSize.width * 0.5,
                                          height: 30,
                                          // color: Colors.pink,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              benefactorDetails['Name'],
                                              style:
                                                  TextStyle(fontSize: 15.ssp),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                new Container(
                                  width: deviceSize.width,
                                  height: 30,
                                  margin: EdgeInsets.only(left: 25),
                                  child: new Row(
                                    children: [
                                      new Container(
                                        width: deviceSize.width * 0.25,
                                        height: 30,
                                        // color: Colors.lightBlue,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Phone No",
                                            style: TextStyle(fontSize: 15.ssp),
                                          ),
                                        ),
                                      ),
                                      new GestureDetector(
                                        onTap: () {
                                          _makePhoneCall(
                                              benefactorDetails['Contact']);
                                        },
                                        child: new Container(
                                            width: deviceSize.width * 0.5,
                                            height: 30,
                                            // color: Colors.pink,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                benefactorDetails['Contact'],
                                                style:
                                                    TextStyle(fontSize: 15.ssp),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        new SizedBox(height: 20),
                        new Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Donation Details",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontSize: 18.ssp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        new Container(
                          width: deviceSize.width,
                          height: 40,
                          margin: EdgeInsets.only(left: 25),
                          child: new Row(
                            children: [
                              new Container(
                                width: deviceSize.width * 0.25,
                                height: 30,
                                // color: Colors.lightBlue,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Item Name",
                                    style: TextStyle(fontSize: 15.ssp),
                                  ),
                                ),
                              ),
                              new Container(
                                  width: deviceSize.width * 0.50,
                                  height: 30,
                                  // color: Colors.pink,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      (showdata)
                                          ? displayDonationData['Itemname']
                                          : "",
                                      style: TextStyle(fontSize: 15.ssp),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        new Container(
                          width: deviceSize.width,
                          height: 40,
                          margin: EdgeInsets.only(left: 25),
                          child: new Row(
                            children: [
                              new Container(
                                width: deviceSize.width * 0.25,
                                height: 30,
                                // color: Colors.lightBlue,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Description",
                                    style: TextStyle(fontSize: 15.ssp),
                                  ),
                                ),
                              ),
                              new Container(
                                  width: deviceSize.width * 0.5,
                                  height: 40,
                                  // color: Colors.pink,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      (showdata)
                                          ? displayDonationData[
                                              'ItemDescription']
                                          : "",
                                      style: TextStyle(fontSize: 15.ssp),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        new Container(
                          width: deviceSize.width,
                          height: 40,
                          margin: EdgeInsets.only(left: 25),
                          child: new Row(
                            children: [
                              new Container(
                                width: deviceSize.width * 0.25,
                                height: 30,
                                // color: Colors.lightBlue,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Quantity",
                                    style: TextStyle(fontSize: 15.ssp),
                                  ),
                                ),
                              ),
                              new Container(
                                  width: deviceSize.width * 0.5,
                                  height: 30,
                                  // color: Colors.pink,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      (showdata)
                                          ? displayDonationData['Itemquantity']
                                          : "",
                                      style: TextStyle(fontSize: 15.ssp),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        new Container(
                          width: deviceSize.width,
                          height: 40,
                          margin: EdgeInsets.only(left: 25),
                          child: new Row(
                            children: [
                              new Container(
                                width: deviceSize.width * 0.25,
                                height: 30,
                                // color: Colors.lightBlue,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Address",
                                    style: TextStyle(fontSize: 15.ssp),
                                  ),
                                ),
                              ),
                              new Container(
                                  // color: Colors.green,
                                  width: deviceSize.width * 0.5,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: (showdata)
                                        ? Text(
                                            displayDonationData['Itemloc'],
                                            style: TextStyle(fontSize: 15.ssp),
                                          )
                                        : LinearProgressIndicator(),
                                  )),
                            ],
                          ),
                        ),
                        new Container(
                          width: deviceSize.width,
                          height: 40,
                          margin: EdgeInsets.only(left: 25),
                          child: new Row(
                            children: [
                              new Container(
                                width: deviceSize.width * 0.25,
                                height: 30,
                                // color: Colors.lightBlue,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Contact",
                                    style: TextStyle(fontSize: 15.ssp),
                                  ),
                                ),
                              ),
                              new Container(
                                  width: deviceSize.width * 0.5,
                                  height: 30,
                                  // color: Colors.pink,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      (showdata)
                                          ? displayDonationData['Itemcontact']
                                          : "",
                                      style: TextStyle(fontSize: 15.ssp),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        new Container(
                          width: deviceSize.width,
                          height: 40,
                          margin: EdgeInsets.only(left: 25),
                          child: new Row(
                            children: [
                              new Container(
                                width: deviceSize.width * 0.25,
                                height: 30,
                                // color: Colors.lightBlue,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Category",
                                    style: TextStyle(fontSize: 15.ssp),
                                  ),
                                ),
                              ),
                              new Container(
                                  width: deviceSize.width * 0.5,
                                  height: 30,
                                  // color: Colors.pink,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      (showdata)
                                          ? displayDonationData['Itemtype']
                                          : "",
                                      style: TextStyle(fontSize: 15.ssp),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(left: 0.016.sw, right: 0.05.sw),
                    child: Form(
                      key: _formKey,
                      child: new Column(
                        children: <Widget>[
                          SizedBox(
                            height: 0.020.sh,
                          ),
                          new ListTile(
                            leading: const Icon(Icons.person),
                            title: TextFormField(
                              controller: _tasknamecont,
                              decoration: InputDecoration(
                                labelText: "Item name: ",
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Item Name';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 0.020.sh,
                          ),
                          new ListTile(
                            leading: const Icon(FontAwesomeIcons.tags),
                            title: TextFormField(
                              controller: _taskDesc,
                              decoration: InputDecoration(
                                labelText: "Description: ",
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Description';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 0.020.sh,
                          ),
                          new ListTile(
                            leading: const Icon(
                              FontAwesomeIcons.buyNLarge,
                            ),
                            title: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _taskquantity,
                              decoration:
                                  InputDecoration(labelText: "Quantity: "),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Quantity';
                                } else if (value.contains(',') ||
                                    value.contains('-') ||
                                    double.parse(value) > 0) {
                                  return 'Please Enter Correct Format';
                                }
                                return null;
                              },
                            ),
                          ),
                          if (widget.type != 'Private')
                            SizedBox(
                              height: 0.020.sh,
                            ),
                          if (widget.type != 'Private')
                            new ListTile(
                              leading: const Icon(FontAwesomeIcons.list),
                              title: TextFormField(
                                controller: _taskunit,
                                decoration: InputDecoration(
                                    labelText: "Unit: ", hintText: "eg: kgs"),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter Unit';
                                  } else if (value.contains(',') ||
                                      double.parse(value) > 0) {
                                    return 'Please Enter Correct Format';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          SizedBox(
                            height: 0.020.sh,
                          ),
                          new ListTile(
                              leading: const Icon(Icons.location_on),
                              title: GestureDetector(
                                child: TextFormField(
                                  controller: _taskloc,
                                  onTap: () {
                                    if (_taskloc.text.isEmpty && this.mounted)
                                      setState(() {
                                        _taskloc.text = currentAddress;
                                      });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Address: ",
                                      hintText:
                                          "eg: 295,2nd main road,SVG-town"),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Address';
                                    }
                                    return null;
                                  },
                                ),
                              )),
                          SizedBox(
                            height: 0.020.sh,
                          ),
                          new ListTile(
                            leading: const Icon(
                              Icons.phone,
                            ),
                            title: TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              controller: _taskcontact,
                              decoration: InputDecoration(
                                  labelText: "Contact: ",
                                  hintText: "eg: 9876543210"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Contact number';
                                } else if (value.length != 10 ||
                                    value.contains('.') ||
                                    value.contains(',')) {
                                  return 'Enter Valid Contact number';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 0.020.sh,
                          ),
                          new ListTile(
                              title: new Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Radio(
                                value: 1,
                                groupValue: _mytasktype,
                                onChanged: _handleTaskType,
                                activeColor: Colors.blue,
                              ),
                              Text('Food', style: TextStyle(fontSize: 12.ssp)),
                              Radio(
                                value: 2,
                                groupValue: _mytasktype,
                                onChanged: _handleTaskType,
                                activeColor: Colors.blue,
                              ),
                              Text('Clothes',
                                  style: TextStyle(fontSize: 12.ssp)),
                              Radio(
                                value: 3,
                                groupValue: _mytasktype,
                                onChanged: _handleTaskType,
                                activeColor: Colors.blue,
                              ),
                              Text('Education',
                                  style: TextStyle(fontSize: 12.ssp)),
                              Radio(
                                value: 4,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                groupValue: _mytasktype,
                                onChanged: _handleTaskType,
                                activeColor: Colors.blue,
                              ),
                              Text('Others', style: TextStyle(fontSize: 12.ssp))
                            ],
                          )),
                          SizedBox(
                            height: 20.h,
                          ),
                          if (taskval == "Food")
                            new ListTile(
                              leading: const Icon(Icons.timer),
                              title: TextFormField(
                                controller: _taskExpire,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                    labelText: "Expire Time: ",
                                    hintText: "In hours"),
                              ),
                            ),
                          new Container(
                            width: deviceSize.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Container(
                                  child: new Container(
                                    margin: EdgeInsets.only(right: 35),
                                    child: RaisedButton(
                                      onPressed: () {
                                        updateData();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Save',
                                          style: TextStyle(fontSize: 20)),
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      elevation: 5,
                                    ),
                                  ),
                                ),
                                new Container(
                                  child: new Container(
                                    margin: EdgeInsets.only(left: 35),
                                    child: RaisedButton(
                                      onPressed: () {
                                        deleteCurrentItem();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete',
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      elevation: 5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                );
        }).toList(),
      ),
    );
  }
}
