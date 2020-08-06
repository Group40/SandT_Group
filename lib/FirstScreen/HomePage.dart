import 'package:flutter/material.dart';
import 'AppDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        drawer: new AppDrawer(),
        appBar: new AppBar(
          title: new Text(
            "S & T",
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Text(
            "User Home Page ",
            style: TextStyle(fontSize: 25),
          ),
        ));
  }
}
