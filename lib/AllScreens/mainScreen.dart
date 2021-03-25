import "package:flutter/material.dart";

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: [
          
        ],
      ),
    );
  }
}
