import 'dart:developer';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver_app/Models/rideDetails.dart';
import 'package:driver_app/Notifications/notificationDialog.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future initialize(BuildContext context) async {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message), context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message), context);
      },
      onResume: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message), context);
      },
    );
  }

  Future<String> getToken() async {
    String token = await firebaseMessaging.getToken();
    log("Token $token");
    driversRef.child(currentFirebaseUser.uid).child("token").set(token);

    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");

    return token;
  }

  String getRideRequestId(Map<String, dynamic> message) {
    String rideRequesterId = "";

    if (Platform.isAndroid) {
      rideRequesterId = message["data"]["ride_request_id"];
    } else {
      rideRequesterId = message["ride_request_id"];
    }

    return rideRequesterId;
  }

  void retrieveRideRequestInfo(String rideRequesterId, BuildContext context) {
    newRequestsRef
        .child(rideRequesterId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot != null && dataSnapshot.value != null) {
        assetsAudioPlayer.open(Audio("sounds/alert.mp3"));
        assetsAudioPlayer.play();

        double pickUpLat =
            double.parse(dataSnapshot.value["pickup"]["latitude"].toString());

        double pickUpLng =
            double.parse(dataSnapshot.value["pickup"]["longitude"].toString());

        String pickUpAddress = dataSnapshot.value["pickup_address"].toString();

        double dropOffLat =
            double.parse(dataSnapshot.value["dropoff"]["latitude"].toString());

        double dropOffLng =
            double.parse(dataSnapshot.value["dropoff"]["longitude"].toString());

        String dropOffAddress =
            dataSnapshot.value["dropoff_address"].toString();

        String paymentMethod = dataSnapshot.value["payment_method"].toString();

        String riderName = dataSnapshot.value["rider_name"];
        String riderPhone = dataSnapshot.value["rider_phone"];

        RideDetails rideDetails = RideDetails();
        rideDetails.rideRequestId = rideRequesterId;
        rideDetails.pickUpAddress = pickUpAddress;
        rideDetails.dropOffAddress = dropOffAddress;
        rideDetails.pickUp = LatLng(pickUpLat, pickUpLng);
        rideDetails.dropOff = LatLng(dropOffLat, dropOffLng);
        rideDetails.paymentMethod = paymentMethod;
        rideDetails.riderName = riderName;
        rideDetails.riderPhone = riderPhone;

        log("Pick Add $pickUpAddress \n Drop Add $dropOffAddress ");

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => NotificationDialog(
            rideDetails: rideDetails,
          ),
        );
      }
    });
  }
}
