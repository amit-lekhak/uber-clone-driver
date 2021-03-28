import 'package:driver_app/DataHandler/appData.dart';
import 'package:driver_app/Models/history.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/Assistants/requestAssistant.dart';
import 'package:driver_app/Models/directionDetails.dart';
import "package:driver_app/configMaps.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
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

  static void retireveHistoryInfo(context) {
    

    /** retrieve and display earnings */
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

    /** retrieve and display Trip history */
    driversRef
        .child(currentFirebaseUser.uid)
        .child("history")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<dynamic, dynamic> keys = snapshot.value;
        int tripCounter = keys.length;

        Provider.of<AppData>(context, listen: false)
            .updateTripsCounter(tripCounter);

        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) {
          tripHistoryKeys.add(key);
        });

        Provider.of<AppData>(context, listen: false)
            .updateTripsKeys(tripHistoryKeys);

        obtainTripRequestHistoryData(context);
      }
    });
  }

  static void obtainTripRequestHistoryData(context) {
    List<String> keys =
        Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for (String key in keys) {
      newRequestsRef.child(key).once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var history = History.fromSnapshot(snapshot);

          Provider.of<AppData>(context, listen: false)
              .updateTripHistoryData(history);
        }
      });
    }
  }

  static String fromatTripDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }
}
