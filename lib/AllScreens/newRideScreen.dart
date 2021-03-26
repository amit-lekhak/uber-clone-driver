import 'package:driver_app/Models/rideDetails.dart';
import "package:flutter/material.dart";

class NewRideScreen extends StatefulWidget {
  final RideDetails rideDetails;

  NewRideScreen({this.rideDetails});

  @override
  _NewRideScreenState createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Ride",
        ),
      ),
      body: Center(
        child: Text(
          "This is New Ride Page",
        ),
      ),
    );
  }
}
