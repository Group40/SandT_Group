import 'package:flutter/material.dart';
import 'package:sandtgroup/UserManagementAdmin/UserManagementGrid.dart';

class UserManagementAdmin extends StatefulWidget {
  @override
  _UserManagementAdminState createState() => new _UserManagementAdminState();
}

class _UserManagementAdminState extends State<UserManagementAdmin> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.grey[300],
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(
            "User Management",
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
                    "User Management Panel",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              //SizedBox(height: 5.0),
              UserManagementGrid()
            ],
          ),
        ));
  }
}
