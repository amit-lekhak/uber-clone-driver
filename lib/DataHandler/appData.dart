import 'package:driver_app/Models/history.dart';
import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  String earnings = "0";
  int tripsCount = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistoryDataList = [];

  void updateEarnings(String updatedEarnings) {
    earnings = updatedEarnings;
    notifyListeners();
  }

  void updateTripsCounter(int tripsCounter) {
    tripsCount = tripsCounter;
    notifyListeners();
  }

  void updateTripsKeys(List<String> newKeys) {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

   void updateTripHistoryData(History history) {
    tripHistoryDataList.add(history);
    notifyListeners();
  }
}
