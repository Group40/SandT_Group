import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:sandtgroup/SignUpLogIn/AuthScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Admin/AdminHomepage.dart';
import 'Crew/CrewHomePage.dart';
import 'HomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

String _token;
String _id;
String _fname;
String _lname;
String _email;
String _tokentype;
int _role;

class _SplashScreenState extends State<SplashScreen> {
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
        _checkrole();
      } else {
        _navigationLog();
      }
    });
  }

  void _checkrole() async {
    var crewurl = getUrl() + "/auth/checkrole?email=" + _email;
    try {
      final response = await http.get(crewurl, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['message'] == "Admin Member") {
          _role = 3;
          setState(() {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => AdminHomePage()),
              (Route<dynamic> route) => false,
            );
          });

          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //     builder: (BuildContext context) => AdminHomePage()));
        } else if (responseData['message'] == "Crew Member") {
          _role = 2;
          setState(() {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => CrewHomePage()),
              (Route<dynamic> route) => false,
            );
          });

          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //     builder: (BuildContext context) => CrewHomePage()));
        } else if (responseData['message'] == "Member") {
          _role = 1;
          setState(() {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
            );
          });

          // Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        } else {
          _role = 0;
          _showRespondDialog("Can not recognize as a member", "Error");
        }
      } else {
        _role = 0;
        _showRespondDialog("Can not recognize as a member", "Error");
      }
    } on TimeoutException catch (_) {
      _role = 0;
      _showRespondDialog("Internet Connection Error", "Error");
    }
  }

  Future<bool> _tryAutoLogin() async {
    await Future.delayed(Duration(milliseconds: 3000));
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      ////////temp fun for developing time
      /*
      final userData = json.encode(
        {
          'token': "Sandun",
          'username': "Sandun",
          'lname': " Weerasekara",
          'email': "Sandun@email.com",
        },
      );
      prefs.setString('userData', userData);*/
      return false;
    } else {
      setState(() {
        final extractedUserData =
            json.decode(prefs.getString('userData')) as Map<String, Object>;
        _token = extractedUserData['token'];
        _fname = extractedUserData['username'];
        _lname = extractedUserData['lname'];
        _email = extractedUserData['email'];
        //_role = extractedUserData['role'];
        _tokentype = extractedUserData['tokentype'];
      });

      return true;
    }
  }

/*
  void _navigationHome() {
    if (getrole() == 3) {
      /*Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => AdminHomePage()));*/
    } else if (getrole() == 2) {
      /*
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => CrewHomePage()));*/
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }
  } 
*/
  void _navigationLog() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => AuthScreen()));
    //test edit
    //MaterialPageRoute(builder: (BuildContext context) => HomePage()));
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

  void _showRespondDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Exit'),
            onPressed: () {
              _role = 0;
              exitFromApp();
            },
          ),
        ],
      ),
    );
  }
}

String getfname() {
  String username = _fname;
  return username;
}

String getlname() {
  String username = _lname;
  return username;
}

String getUsername() {
  String username = _fname + " " + _lname;
  return username;
}

String getEmail() {
  return _email;
}

String getToken() {
  return _token;
}

String getTokentype() {
  return _tokentype;
}

int getrole() {
  return _role;
}

String getUrl() {
  //return "http://10.0.2.2:8080";
  return "http://sandtgroup-env.eba-6dvhzmva.ap-south-1.elasticbeanstalk.com";
}

exitFromApp() {
  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}

void clearEmail() {
  _email = "";
}

void setlname(String name) {
  _lname = name;
}

void setfname(String name) {
  _fname = name;
}
