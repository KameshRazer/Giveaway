import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class DonateFormFragment extends StatefulWidget {
  final String type;
  final String charityId;
  DonateFormFragment({Key key, @required this.type, this.charityId = "default"})
      : super(key: key);

  @override
  DonateFormFragmentState createState() => DonateFormFragmentState();
}

class DonateFormFragmentState extends State<DonateFormFragment> {
  Position currentPosition;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  String currentAddress;
  String currTime;
  String charityId = null;
  TextEditingController _tasknamecont,
      _taskquantity,
      _taskunit,
      _taskloc,
      _taskcontact,
      _taskDesc,
      _taskExpire;
  double lati = 0.0, longi = 0.0;
  GeoPoint posi;
  // getlocation() async {
  //   Position position = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   setState(() {
  //     lati = position.latitude;
  //     longi = position.longitude;
  //   });
  // }

  @override
  void initState() {
    super.initState();
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
  }

  int _mytasktype = 0;
  String taskval;
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

  createData() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference collection =
        FirebaseFirestore.instance.collection("Donation");
    Map<String, dynamic> tasks = {
      'Donor': FirebaseAuth.instance.currentUser.uid,
      'Itemname': _tasknamecont.text,
      'ItemDescription': _taskDesc.text,
      'Itemquantity': _taskquantity.text,
      'Itemunit': _taskunit.text,
      'Itemloc': _taskloc.text,
      'locationpoint': GeoPoint(posi.latitude, posi.longitude),
      'Itemcontact': _taskcontact.text,
      'Itemtype': taskval,
      'PostedTime': currTime,
      'Status': "Posted",
      'Expire': _taskExpire.text,
      'Type': widget.type,
    };
    if (widget.type == 'Private') {
      FirebaseFirestore.instance
          .collection('charity')
          .doc(widget.charityId)
          .get()
          .then((value) {
        String userId = value.data()['userId'];
        tasks['Benefactor'] = userId;
        collection.add(tasks).then((val) => {
              users.doc(FirebaseAuth.instance.currentUser.uid).update({
                "DonationCart": FieldValue.arrayUnion([val.id])
              })
            });
      });
    } else {
      collection.add(tasks).then((val) => {
            users.doc(FirebaseAuth.instance.currentUser.uid).update({
              "DonationCart": FieldValue.arrayUnion([val.id])
            })
          });
    }
  }

  getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
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

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: deviceSize.width, maxHeight: deviceSize.height),
        designSize: Size(deviceSize.width, deviceSize.height),
        allowFontScaling: true);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Donate Form',
          style: TextStyle(
            // fontSize: 25.ssp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
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
                  decoration: InputDecoration(labelText: "Quantity: "),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter Quantity';
                    } else if (value.contains(',') ||
                        value.contains('-') ||
                        double.parse(value) <= 0) {
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
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Unit: ", hintText: "eg: kgs"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Unit';
                      } else if (value.contains(',') ||
                          double.parse(value) <= 0) {
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
                        // print(currentAddress);
                        if (_taskloc.text.isEmpty && this.mounted)
                          setState(() {
                            _taskloc.text = currentAddress;
                          });
                      },
                      decoration: InputDecoration(
                          labelText: "Address: ",
                          hintText: "eg: 295,2nd main road,SVG-town"),
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
                      labelText: "Contact: ", hintText: "eg: 9876543210"),
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
                  Text('Clothes', style: TextStyle(fontSize: 12.ssp)),
                  Radio(
                    value: 3,
                    groupValue: _mytasktype,
                    onChanged: _handleTaskType,
                    activeColor: Colors.blue,
                  ),
                  Text('Education', style: TextStyle(fontSize: 12.ssp)),
                  Radio(
                    value: 4,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                        labelText: "Expire Time: ", hintText: "In hours"),
                  ),
                )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          if (_formKey.currentState.validate()) {
            if (_mytasktype == 0) {
              scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Select Category'),
              ));
              return;
            }

            createData();

            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Donation added'),
            ));
            clearTextField();
          }
        },
      ),
    );
  }
}
