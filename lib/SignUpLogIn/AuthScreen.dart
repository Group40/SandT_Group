import 'package:flutter/material.dart';
import 'package:sandtgroup/SignUpLogIn/LogIn.dart';

import '../SignUpLogIn/SignUp.dart';
import 'SignUp.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => new _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('assets/image/back2.gif'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment(0, MediaQuery.of(context).size.height / 1050),
          child: Row(children: <Widget>[
            Expanded(
                child: Divider(
              //height: 0,
              thickness: 0.8,
              color: Colors.white,
              indent: 32,
              endIndent: 32,
            )),
            Text(
              "OR",
              style: TextStyle(color: Colors.white),
            ),
            Expanded(
                child: Divider(
                    //height: 0,
                    thickness: 0.8,
                    color: Colors.white,
                    indent: 32,
                    endIndent: 32)),
          ]),
        ),
        new Container(
          child: Align(
            alignment: Alignment(0, -MediaQuery.of(context).size.height / 1100),
            child: new Text(
              "APP_NAME",
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ),
        Container(
          alignment: Alignment(0, MediaQuery.of(context).size.height / 1250),
          child: SizedBox(
            width: 300.0,
            height: 50.0,
            child: OutlineButton(
              highlightedBorderColor: Colors.white,
              borderSide: BorderSide(color: Colors.white, width: 3.0),
              highlightElevation: 0.0,
              splashColor: Colors.black.withOpacity(0.2),
              highlightColor: Colors.black.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              child: Text(" REGISTER ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 23)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
            ),
          ),
        ),
        Container(
          alignment: Alignment(0, MediaQuery.of(context).size.height / 810),
          child: SizedBox(
            width: 300.0,
            height: 50.0,
            child: RaisedButton(
              highlightElevation: 0.0,
              splashColor: Colors.transparent,
              highlightColor: Colors.black.withOpacity(0.5),
              color: Colors.white.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              child: Text("   LOG  IN    ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 23)),
              onPressed: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                });
              },
            ),
          ),
        ),
      ],
    ));
  }
}
