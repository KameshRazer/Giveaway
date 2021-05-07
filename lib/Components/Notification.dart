// import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart';

class Notification {
  // Notification() {}
  Future sendNotification(var productId, var mode) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAACOXv4gE:APA91bGb_3awrR098iztt2_5NS8Cb7_IPFgWU9qHoAUtRrrzFHHUwjW1qhOQZHFZuchSwTRX7bSCKD96ldxV3tbj32CI4-dT1st6nltVB_dVAznKx1gcVi3H640Ztto7VgjbthyW9UFr",
      };
      await Firebase.initializeApp();
      print("curent mode : $mode");
      FirebaseFirestore.instance
          .collection('Donation')
          .doc(productId)
          .get()
          .then((value) {
        var data = value.data();
        print(data);
        String donorId = data['Donor'];
        String itemName = data['Itemname'];
        String benefactorId = data['Benefactor'];
        String tokenId;

        var donorDetails =
            FirebaseFirestore.instance.collection('users').doc(donorId).get();
        donorDetails.then((val) {
          var data = val.data();
          tokenId = data["fcmToken"];
          FirebaseFirestore.instance
              .collection('users')
              .doc(benefactorId)
              .get()
              .then((value) {
            var data = value.data();
            String name = data['Name'];
            // String tokenId = data['fcmToken'];
            String type = (mode == "Public") ? "Requested" : "Ready to donate ";
            var body = {
              "notification": {
                "title": (mode == "Public") ? "New Request" : "New Donation",
                "body": "$itemName has $type by $name",
                "sound": "default",
                "color": "#990000",
              },
              "priority": "high",
              "to": tokenId
            };
            post(url, headers: header, body: json.encode(body))
                .whenComplete(() {})
                .catchError((e) {
              print('Error 32 Notification ${e.message}');
            });
          });
        });
      });

      // await client.post(url, headers: header, body: json.encode(request));
    } catch (e) {
      print('Error 249 Notification : $e');
    }
  }
}
