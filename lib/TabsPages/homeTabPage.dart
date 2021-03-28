import 'dart:async';

import 'package:driver_app/AllScreens/registrationScreen.dart';
import 'package:driver_app/Assistants/assistantMethods.dart';
import 'package:driver_app/Models/drivers.dart';
import 'package:driver_app/Notifications/pushNotificationService.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPage extends StatefulWidget {
  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(37.42796, -122.0857), zoom: 14.4746);

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  String driverStatusText = "Offline Now - Go Online  ";
  Color driverStatusColor = Colors.black;
  bool isDriverAvailable = false;

  @override
  void initState() {
    super.initState();
    getCurrentDdriverInfo();
  }

  void getRideType() {
    driversRef
        .child(currentFirebaseUser.uid)
        .child("car_details")
        .child("type")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        setState(() {
          rideType = snapshot.value.toString();
        });
      }
    });
  }

  void getRatings() {
    /** update ratings */
    driversRef
        .child(currentFirebaseUser.uid)
        .child("ratings")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        double ratings = double.parse(snapshot.value.toString());

        setState(() {
          starCounter = ratings;
        });

        if (starCounter <= 1.5) {
          setState(() {
            title = "Very Bad";
          });
          return;
        }

        if (starCounter <= 2.5) {
          setState(() {
            title = "Bad";
          });
          return;
        }

        if (starCounter <= 3.5) {
          setState(() {
            title = "Good";
          });
          return;
        }

        if (starCounter <= 4.5) {
          setState(() {
            title = "Very Good";
          });
          return;
        }

        if (starCounter <= 5.5) {
          setState(() {
            title = "Excellent";
          });
          return;
        }
      }
    });
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLangPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLangPosition, zoom: 14);

    await newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // String address =
    //     await AssistantMethods.searchCoordinateAddress(position, context);
    // print("This is your address : $address");
  }

  void getCurrentDdriverInfo() {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;

    driversRef
        .child(currentFirebaseUser.uid)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        driversInformation = Drivers.fronSnapshot(dataSnapshot);
      }
    });

    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

    AssistantMethods.retireveHistoryInfo(context);

    getRatings();
    getRideType();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
          },
        ),

        /* Online Offline driver container */

        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.black54,
        ),
        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: RaisedButton(
                  onPressed: () {
                    if (!isDriverAvailable) {
                      makeDriverOnlineNow();
                      getLocationUpdates();

                      setState(() {
                        driverStatusColor = Colors.green;
                        driverStatusText = "Online Now";
                        isDriverAvailable = true;
                      });

                      displayToastMessage("You are Online Now", context);
                    } else {
                      makeDriverOfflineNow();

                      setState(() {
                        driverStatusColor = Colors.black;
                        driverStatusText = "Offline Now - Go Online   ";
                        isDriverAvailable = false;
                      });

                      displayToastMessage("You are Offline Now", context);
                    }
                  },
                  color: driverStatusColor,
                  child: Padding(
                    padding: EdgeInsets.all(17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          driverStatusText,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Icon(
                          Icons.phone_android,
                          color: Colors.white,
                          size: 26.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);

    rideRequestRef.set("searching");

    rideRequestRef.onValue.listen((event) {});
  }

  void getLocationUpdates() {
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isDriverAvailable) {
        Geofire.setLocation(
            currentFirebaseUser.uid, position.latitude, position.longitude);
      }

      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void makeDriverOfflineNow() {
    Geofire.removeLocation(currentFirebaseUser.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
  }
}
