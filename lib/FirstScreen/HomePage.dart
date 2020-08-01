import 'package:flutter/material.dart';
import 'package:sandtgroup/FirstScreen/Profile.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'package:sandtgroup/Photography/UploadPics.dart';
import 'package:sandtgroup/Photography/MainPage.dart';
import 'package:sandtgroup/main.dart';

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
          new UserAccountsDrawerHeader(
            accountName: Text(
              getUsername().toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              getEmail(),
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            currentAccountPicture: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 80,
              ),
            ),
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
                  MaterialPageRoute(builder: (context) => UploadPics()));
            },
          ),
          Menu(
            icon: Icons.home,
            title: "Photography",
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
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
