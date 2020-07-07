import 'package:flutter/material.dart';
import 'package:sandtgroup/EventPublishingBooking/EventBooking.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      drawer: new AppDrawer(),
      appBar: new AppBar(
        title: new Text("Title"),
      ),
      /*body: new ListView(
        children: <Widget>[
          new ListTile(
            title: new Text("Body"),
          ),
          new ListTile(
            title: new RaisedButton(
              child: new Text("Open Drawer"),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer(); // left side
                //_scaffoldKey.currentState.openEndDrawer(); // right side
              },
            ),
          ),
        ],
      ),*/
    );
  }
}

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => new _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new DrawerHeader(
            child: Align(
              child: CircleAvatar(
                radius: 30.0,
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 55,
                ),
              ),
              alignment: FractionalOffset(0.5, 0.0),
            ),
          ),
          new ListTile(
            title: new Text("Piyumal",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                )),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyHomePage();
                return EventBooking();
              }));
            },
          ),
        ],
      ),
    );
  }
}
