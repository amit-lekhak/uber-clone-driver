import 'package:driver_app/DataHandler/appData.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/Assistants/requestAssistant.dart';
import 'package:driver_app/Models/directionDetails.dart';
import "package:driver_app/configMaps.dart";
import 'package:provider/provider.dart';

class AssistantMethods {
  // static Future<String> searchCoordinateAddress(
  //     Position position, context) async {
  //   String placeAddress = "";
  //   // String st1, st2, st3, st4;
  //   String url =
  //       "https://api.mapbox.com/geocoding/v5/mapbox.places/${position.longitude},${position.latitude}.json?access_token=$mapBoxKey";

  //   var response = await RequestAssistant.getRequest(url);

  //   if (response != "failed") {
  //     placeAddress = response["features"][0]["place_name"];

  //     // st1 = response["features"][0]["context"][2]["text"];
  //     // st2 = response["features"][0]["context"][4]["text"];
  //     // st3 = response["features"][0]["context"][5]["text"];
  //     // st4 = response["features"][0]["context"][6]["text"];

  //     // placeAddress = "$st1, $st2, $st3, $st4";

  //     Address userPickUpAddress = new Address();
  //     userPickUpAddress.latitude = position.latitude;
  //     userPickUpAddress.longitude = position.longitude;
  //     userPickUpAddress.placeName = placeAddress;

  //     Provider.of<AppData>(context, listen: false)
  //         .updatePickUpLocationAddress(userPickUpAddress);
  //   }

  //   return placeAddress;
  // }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://api.mapbox.com/directions/v5/mapbox/driving/${initialPosition.longitude},${initialPosition.latitude};${finalPosition.longitude},${finalPosition.latitude}?access_token=$mapBoxKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "failed") return null;

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints = res["routes"][0]["geometry"];

    int distance = (res["routes"][0]["legs"][0]["distance"]).toInt();
    var distanceinKm = (distance / 1000).toStringAsFixed(2);

    directionDetails.distanceText = "$distanceinKm km";
    directionDetails.distanceValue = distance;

    int seconds = (res["routes"][0]["legs"][0]["duration"]).toInt();

    directionDetails.durationValue = seconds;

    Duration duration = Duration(seconds: seconds);

    String durationText =
        "${duration.inHours}h:${duration.inMinutes.remainder(60)}m:${(duration.inSeconds.remainder(60))}s";

    directionDetails.durationText = durationText;

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    double timeTravelledFare = (directionDetails.durationValue / 60) * 0.20;
    double distanceTravelledFare =
        (directionDetails.distanceValue / 1000) * 0.20;

    double totalFareAmount = timeTravelledFare + distanceTravelledFare;

    return totalFareAmount.truncate();
  }

  // static void getCurrentUserInfo() async {
  //   firebaseUser = FirebaseAuth.instance.currentUser;
  //   String userId = firebaseUser.uid;
  //   DatabaseReference reference =
  //       FirebaseDatabase.instance.reference().child("users").child(userId);

  //   reference.once().then((DataSnapshot dataSnapshot) {
  //     if (dataSnapshot.value != null) {
  //       userCurrentInfo = Users.fromSnapShot(dataSnapshot);
  //     }
  //   });
  // }

  static void disableHomeTabLiveLocationUpdates() {
    if (homeTabPageStreamSubscription != null) {
      homeTabPageStreamSubscription.pause();
    }
    Geofire.removeLocation(currentFirebaseUser.uid);
  }

  static void enableHomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription.resume();
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);
  }

  static void retireveEarningsInfo(context) {
    driversRef
        .child(currentFirebaseUser.uid)
        .child("earnings")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        String earnings = snapshot.value.toString();

        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });
  }
}
