import 'package:driver_app/Assistants/assistantMethods.dart';
import 'package:driver_app/Models/history.dart';
import "package:flutter/material.dart";

class HistoryItem extends StatelessWidget {
  final History history;

  HistoryItem({this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      "images/pickicon.png",
                      height: 16.0,
                      width: 16.0,
                    ),
                    SizedBox(
                      width: 18.0,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          history.pickUpAddress,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "Brand Bold",
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "\$${history.fares}",
                      style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 16.0,
                          color: Colors.black87),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset(
                    "images/desticon.png",
                    height: 16.0,
                    width: 16.0,
                  ),
                  SizedBox(
                    width: 18.0,
                  ),
                  Text(
                    history.dropOffAddress,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                AssistantMethods.fromatTripDate(history.createdAt),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
