import 'package:flutter/material.dart';
import 'CrewAppDrawer.dart';

class CrewHomePage extends StatefulWidget {
  @override
  _CrewHomePageState createState() => new _CrewHomePageState();
}

class _CrewHomePageState extends State<CrewHomePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        drawer: new CrewAppDrawer(),
        appBar: new AppBar(
          title: new Text(
            "Crew Member",
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Text(
            "Crew Member Home Page ",
            style: TextStyle(fontSize: 25),
          ),
        ));
  }
}
