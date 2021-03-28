import 'package:driver_app/AllWidgets/historyItem.dart';
import 'package:driver_app/DataHandler/appData.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    var historyList = Provider.of<AppData>(context).tripHistoryDataList;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Trip History",
        ),
        backgroundColor: Colors.black87,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_arrow_left,
          ),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(0.0),
        itemBuilder: (context, index) {
          return HistoryItem(
            history: historyList[index],
          );
        },
        separatorBuilder: (context, index) => Divider(
          thickness: 3.0,
          height: 3.0,
        ),
        itemCount: historyList.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
