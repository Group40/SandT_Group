import 'package:flutter/material.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'package:sandtgroup/Profile/UpdatePassword.dart';
import 'package:sandtgroup/Profile/UpdateUserData.dart';
import 'package:sandtgroup/SignUpLogIn/AuthScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //drawer: new AppDrawer(),
      appBar: new AppBar(
        title: new Text(
          "My Profile",
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          // ClipPath(
          //   child: Container(
          //       color: Theme.of(context).primaryColor.withOpacity(0.9)),
          //   clipper: getClipper(),
          // ),
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.height / 15,
              child: Column(
                children: <Widget>[
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
                    getUsername(),
                    style: TextStyle(
                        fontSize: 35.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    getEmail(),
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Montserrat'),
                  ),
                  Divider(
                    color: Colors.black.withOpacity(0),
                    height: 50,
                  ),
                  SizedBox(height: 25.0),
                  _buildUpdateDetails(),
                  _buildUpdatePassword(),
                  SizedBox(height: 10.0),
                  _buildLogout(),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildLogout() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: MediaQuery.of(context).size.width / 1.5,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () async {
            Navigator.of(context).pop();
            final pref = await SharedPreferences.getInstance();
            await pref.clear();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => AuthScreen()));
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.red,
          child: setUpButton("Log Out")),
    );
  }

  Widget _buildUpdatePassword() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width / 1.3,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            //Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                 builder: (BuildContext context) => UpdatePassword()));
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blueAccent,
          child: setUpButton("Update My Password")),
    );
  }

  Widget _buildUpdateDetails() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width / 1.3,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            //Navigator.of(context).pop();
             Navigator.of(context).push(MaterialPageRoute(
                 builder: (BuildContext context) => UpdateUserData()));
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.green,
          child: setUpButton("Edit My Details")),
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
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
