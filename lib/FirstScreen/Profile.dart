import 'package:flutter/material.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';
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
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          ClipPath(
            child: Container(
                color: Theme.of(context).primaryColor.withOpacity(0.9)),
            clipper: getClipper(),
          ),
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.height / 15,
              child: Column(
                children: <Widget>[
                  Container(
                      child: CircleAvatar(
                    radius: 65,
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
                        fontSize: 40.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 15.0),
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
                  Container(
                      height: 30.0,
                      width: 200.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Center(
                            child: Text(
                              'Edit Your Details',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 25.0),
                  Container(
                      height: 30.0,
                      width: 200.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.redAccent,
                        color: Colors.redAccent,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Center(
                            child: Text(
                              'Update You Password',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 25.0),
                  Container(
                      height: 30.0,
                      width: 95.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.redAccent,
                        color: Colors.red,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.of(context).pop();
                            final pref = await SharedPreferences.getInstance();
                            await pref.clear();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AuthScreen()));
                          },
                          child: Center(
                            child: Text(
                              'Log out',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ))
                ],
              ))
        ],
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
