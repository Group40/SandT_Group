import 'package:flutter/material.dart';
import 'package:sandtgroup/EventPublishingBooking/EventBooking.dart';
import 'package:sandtgroup/FirstScreen/Profile.dart';
import 'package:sandtgroup/main.dart';
//import '../FirstSceen/Profile.dart';

import 'Menu.dart';

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
        child: Container(
      //color: Colors.cyan,

      child: new ListView(
        children: <Widget>[
          new Container(
              child: CircleAvatar(
            radius: 40,
            child: Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 70,
            ),
          )),
          Divider(
            color: Colors.black.withOpacity(0),
          ),
          new ListTile(
            title: new Text(
              "User Name",
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              "email@email.com",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(
            height: 10,
            thickness: 0.8,
            color: Colors.black.withOpacity(0.3),
            indent: 32,
            endIndent: 32,
          ),
          Menu(
            icon: Icons.person,
            title: "Profile",
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
          Menu(
            icon: Icons.home,
            title: "Home",
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          Menu(
            icon: Icons.home,
            title: "Piyumal",
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EventBooking()));
            },
          ),
          Divider(
            height: 64,
            thickness: 0.8,
            color: Colors.black.withOpacity(0.3),
            indent: 32,
            endIndent: 32,
          ),
          Menu(
            icon: Icons.settings,
            title: "Setting",
          ),
        ],
      ),
    ));
  }
}
