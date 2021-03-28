import 'package:firebase_database/firebase_database.dart';

class History {
  String paymentMethod;
  String createdAt;
  String status;
  String fares;
  String dropOffAddress;
  String pickUpAddress;

  History(
      {this.createdAt,
      this.dropOffAddress,
      this.fares,
      this.paymentMethod,
      this.pickUpAddress,
      this.status});

  History.fromSnapshot(DataSnapshot snapshot) {
    paymentMethod = snapshot.value["payment_method"];
    createdAt = snapshot.value["created_at"];
    status = snapshot.value["status"];
    fares = snapshot.value["fares"];
    dropOffAddress = snapshot.value["dropoff_address"];
    pickUpAddress = snapshot.value["pickup_address"];
  }
}
