import 'package:flutter/material.dart';
import 'package:sandtgroup/FirstScreen/Crew/CrewScreenGrids.dart';
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
      backgroundColor: Colors.grey[300],
        key: _scaffoldKey,
        drawer: new CrewAppDrawer(),
        appBar: new AppBar(
          title: new Text(
            "S & T Group",
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
              //padding: EdgeInsets.all(20.0),
              //height: 200,
              child: Column(
                mainAxisAlignment: (MainAxisAlignment.start),
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 15.0),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Crew Panel",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  //SizedBox(height: 5.0),
                  CrewScreenGrids()
                ],
              ),
            ));
  }
}
