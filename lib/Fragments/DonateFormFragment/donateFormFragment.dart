import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:async';
import 'package:intl/intl.dart';

class DonateFormFragment extends StatefulWidget {
  final String type;
  DonateFormFragment(this.type);
  @override
  DonateFragmentState createState() => DonateFragmentState();
}

class DonateFragmentState extends State<DonateFormFragment> {
  Position currentPosition;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  String currentAddress;
  String Taskname,
      Taskquantity,
      Taskunit,
      Taskloc,
      TaskContact,
      TaskDesc,
      cur_time,
      TaskExpire;
  TextEditingController _tasknamecont,
      _taskquantity,
      _taskunit,
      _taskloc,
      _taskcontact,
      _taskDesc,
      _taskExpire;
  double lati = 0.0, longi = 0.0;
  GeoPoint posi;
  getlocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lati = position.latitude;
      longi = position.longitude;
    });
  }

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
    DateTime now = DateTime.now();
    cur_time = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    getCurrentLocation();
  }

  int _mytasktype = 0;
  String taskval;
  void _handleTaskType(int value) {
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
          taskval = "Medicine";
          break;
        case 5:
          taskval = "others";
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
      'PostedTime': cur_time,
      'Status': "Posted",
      'Expire': _taskExpire.text,
      'Type': widget.type,
    };
    print(tasks);
    collection.add(tasks).then((val) => {
          users.doc(FirebaseAuth.instance.currentUser.uid).update({
            "DonationCart": FieldValue.arrayUnion([val.id])
          })
        });
  }

  getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      print('Postion : $position');
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

      print(
          "Address :  ${place.locality},${place.subAdministrativeArea}, ${place.postalCode}, ${place.country}");
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
  }

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Giveaway',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(deviceSize.width * .010),
        child: Form(
          key: _formKey,
          child: new Column(
            children: <Widget>[
              new ListTile(
                leading: const Icon(Icons.person),
                title: TextFormField(
                  controller: _tasknamecont,
                  decoration: InputDecoration(labelText: "Item name: "),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Item Name';
                    }
                    return null;
                  },
                ),
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
              const Divider(
                height: 1.0,
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
                      return 'Please enter Quantity';
                    }
                    return null;
                  },
                ),
              ),
              const Divider(
                height: 1.0,
              ),
              new ListTile(
                leading: const Icon(FontAwesomeIcons.list),
                title: TextFormField(
                  controller: _taskunit,
                  decoration:
                      InputDecoration(labelText: "Unit: ", hintText: "eg: kgs"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Unit';
                    }
                    return null;
                  },
                ),
              ),
              const Divider(
                height: 1.0,
              ),
              new ListTile(
                  leading: const Icon(Icons.location_on),
                  title: GestureDetector(
                    child: TextFormField(
                      controller: _taskloc,
                      decoration: InputDecoration(
                          labelText: "Address: ",
                          hintText: "eg: 295,2nd main road,Tvl-town"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Address';
                        }
                        return null;
                      },
                    ),
                  )),
              new ListTile(
                leading: const Icon(Icons.phone),
                title: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  controller: _taskcontact,
                  decoration: InputDecoration(
                      labelText: "Contact: ", hintText: "eg: 9442770493"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Contact number';
                    } else if (value.length != 10) {
                      return 'Enter Valid Contact number';
                    }
                    return null;
                  },
                ),
              ),
              new ListTile(
                  title: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      child: Radio(
                    value: 1,
                    groupValue: _mytasktype,
                    onChanged: _handleTaskType,
                    activeColor: Colors.blue,
                  )),
                  Flexible(
                      child: Text('Food', style: TextStyle(fontSize: 10.0))),
                  Flexible(
                      child: Radio(
                    value: 2,
                    groupValue: _mytasktype,
                    onChanged: _handleTaskType,
                    activeColor: Colors.blue,
                  )),
                  Flexible(
                      child: Text('Clothes', style: TextStyle(fontSize: 10.0))),
                  Flexible(
                      child: Radio(
                    value: 3,
                    groupValue: _mytasktype,
                    onChanged: _handleTaskType,
                    activeColor: Colors.blue,
                  )),
                  Flexible(
                      child:
                          Text('Education', style: TextStyle(fontSize: 10.0))),
                  Flexible(
                      child: Radio(
                    value: 4,
                    groupValue: _mytasktype,
                    onChanged: _handleTaskType,
                    activeColor: Colors.blue,
                  )),
                  Flexible(
                      child: Text('Others', style: TextStyle(fontSize: 10.0)))
                ],
              )),
              if (taskval == "Food")
                new ListTile(
                  leading: const Icon(Icons.timer),
                  title: TextFormField(
                    controller: _taskExpire,
                    decoration: InputDecoration(
                        labelText: "Expire Time: ", hintText: "In hours"),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (_formKey.currentState.validate()) {
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
