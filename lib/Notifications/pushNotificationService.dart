import 'dart:developer';
import 'dart:io';

import 'package:driver_app/Models/rideDetails.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future initialize() async {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message));
      },
      onLaunch: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message));
      },
      onResume: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message));
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

  void retrieveRideRequestInfo(String rideRequesterId) {
    newRequestsRef
        .child(rideRequesterId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot != null && dataSnapshot.value != null) {
        
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

        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequesterId;
        rideDetails.pickup_address = pickUpAddress;
        rideDetails.dropoff_address = dropOffAddress;
        rideDetails.pickup = LatLng(pickUpLat, pickUpLng);
        rideDetails.dropoff = LatLng(dropOffLat, dropOffLng);
        rideDetails.payment_method = paymentMethod;

        log("Pick Add $pickUpAddress \n Drop Add $dropOffAddress ");
      }
    });
  }
}
