import 'package:driver_app/AllScreens/historyScreen.dart';
import 'package:driver_app/DataHandler/appData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EarningsTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String earnings = Provider.of<AppData>(context, listen: false).earnings;
    String tripsCount =
        Provider.of<AppData>(context, listen: false).tripsCount.toString();

    return Column(
      children: [
        Container(
          color: Colors.black87,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 70,
            ),
            child: Column(
              children: [
                Text(
                  "Total Earnings",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "\$$earnings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontFamily: "Brand Bold",
                  ),
                ),
              ],
            ),
          ),
        ),
        FlatButton(
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryScreen(),
                ));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 18.0,
            ),
            child: Row(
              children: [
                Image.asset(
                  "images/uberx.png",
                  width: 70,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  "Total Trips",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      tripsCount,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 2.0,
          thickness: 2.0,
        ),
      ],
    );
  }
}
