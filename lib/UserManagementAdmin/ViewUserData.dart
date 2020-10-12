import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'package:sandtgroup/UserManagementAdmin/AdminUsers.dart';

class ViewUserData extends StatefulWidget {
  final String name;
  final String id;
  final int role;
  final String email;
  final String date;
  ViewUserData({Key key, this.name, this.date, this.email, this.role, this.id})
      : super(key: key);
  @override
  _ViewUserDataState createState() => _ViewUserDataState();
}

class _ViewUserDataState extends State<ViewUserData> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "User Details",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.height / 15,
              child: Column(
                children: <Widget>[
                  widget.role == 3
                      ? Text(
                          "Admin Member",
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Montserrat'),
                        )
                      : widget.role == 2
                          ? Text(
                              "Crew Member",
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Montserrat'),
                            )
                          : widget.role == 1
                              ? Text(
                                  "Normal User",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'Montserrat'),
                                )
                              : Text(
                                  "Block User",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'Montserrat'),
                                ),
                  SizedBox(height: 40.0),
                  Container(
                      child: CircleAvatar(
                    radius: 55,
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 125,
                    ),
                  )),
                  SizedBox(height: 40.0),
                  Text(
                    widget.name,
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    widget.email,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Montserrat'),
                  ),
                  Divider(
                    color: Colors.black.withOpacity(0),
                    height: 50,
                  ),
                  SizedBox(height: 25.0),
                  widget.role == 2
                      ? _makeadmin()
                      : widget.role == 1
                          ? _makecrew()
                          : widget.role == 0
                              ? _makeuser()
                              : test(),
                ],
              ))
        ],
      ),
    );
  }

  Widget setUpButton(txt) {
    return new Text(
      txt,
      style: TextStyle(
        color: Colors.white,
        letterSpacing: 1.5,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
      ),
    );
  }

  Widget _makeadmin() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width / 1.3,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            toadmin();
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.green,
          child: setUpButton("Make As Admin")),
    );
  }

  Widget _makecrew() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width / 1.3,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            tocrew();
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.green,
          child: setUpButton("Make As Crew")),
    );
  }

  Widget _makeuser() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width / 1.3,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            touser();
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.green,
          child: setUpButton("Make As User")),
    );
  }

  Widget test() {
    return Container();
  }

  Future<void> toadmin() async {
    var url = getUrl() + "/userupdate/toadmin";
    var body = jsonEncode({
      'id': widget.id,
    });
    try {
      final res = await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => AdminUsers()));
      } else {}
    } on TimeoutException catch (_) {} catch (error) {}
  }

  Future<void> tocrew() async {
    var url = getUrl() + "/userupdate/tocrew";
    var body = jsonEncode({
      'id': widget.id,
    });
    try {
      final res = await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => AdminUsers()));
      } else {}
    } on TimeoutException catch (_) {} catch (error) {}
  }

  Future<void> touser() async {
    var url = getUrl() + "/userupdate/tocrew";
    var body = jsonEncode({
      'id': widget.id,
    });
    try {
      final res = await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => AdminUsers()));
      } else {}
    } on TimeoutException catch (_) {} catch (error) {}
  }
}
