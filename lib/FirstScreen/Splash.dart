import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sandtgroup/SignUpLogIn/AuthScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'HomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _token;
  String _id;
  String _fname;
  String _lname;
  String _email;
/*
  @override
  void initState() {
    super.initState();

    _mockCheckForSession().then((status) {
      if (status) {
        _navigationHome();
      } else {
        _navigationLog();
      }
    });
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 3000));
    return true;
  }*/

  @override
  void initState() {
    super.initState();

    _tryAutoLogin().then((status) {
      if (status) {
        _navigationHome();
      } else {
        _navigationLog();
      }
    });
  }

  Future<bool> _tryAutoLogin() async {
    await Future.delayed(Duration(milliseconds: 3000));
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    _token = extractedUserData['token'];
    _fname = extractedUserData['username'];
    _lname = extractedUserData['lname'];
    _email = extractedUserData['email'];

    return true;
  }

  void _navigationHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => HomePage())); //HomePage()
  }

  void _navigationLog() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          //alignment: Alignment.center,
          children: <Widget>[
            Opacity(
                opacity: 0.8,
                child: Image.asset(
                  'assets/image/logo.jpg',
                  scale: 10,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ))
          ],
        ),
      ),
    );
  }
}
