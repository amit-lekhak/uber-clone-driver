import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails {
  String pickUpAddress;
  String dropOffAddress;
  LatLng pickUp;
  LatLng dropOff;
  String rideRequestId;
  String paymentMethod;
  String riderName;
  String riderPhone;

  RideDetails(
      {this.dropOff,
      this.dropOffAddress,
      this.paymentMethod,
      this.pickUp,
      this.pickUpAddress,
      this.rideRequestId,
      this.riderName,
      this.riderPhone});
}
