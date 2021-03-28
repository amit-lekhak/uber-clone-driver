import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  String earnings = "0";

  void updateEarnings(String updatedEarnings) {
    earnings = updatedEarnings;
    notifyListeners();
  }
}
