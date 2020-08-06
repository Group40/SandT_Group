import 'package:flutter/material.dart';
import 'AdminAppDrawer.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => new _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        drawer: new AdminAppDrawer(),
        appBar: new AppBar(
          title: new Text(
            "Admin",
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Text(
            "Admin Home Page ",
            style: TextStyle(fontSize: 25),
          ),
        ));
  }
}
