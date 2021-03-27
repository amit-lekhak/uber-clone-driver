import 'package:firebase_database/firebase_database.dart';

class Drivers {
  String name;
  String email;
  String phone;
  String id;
  String carModel;
  String carNumber;
  String carColor;

  Drivers(
      {this.carColor,
      this.carModel,
      this.carNumber,
      this.email,
      this.id,
      this.name,
      this.phone});

  Drivers.fronSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    phone = snapshot.value["phone"];
    email = snapshot.value["email"];
    name = snapshot.value["name"];
    carModel = snapshot.value["car_details"]["car_model"];
    carNumber = snapshot.value["car_details"]["car_number"];
    carColor = snapshot.value["car_details"]["car_color"];
  }
}
