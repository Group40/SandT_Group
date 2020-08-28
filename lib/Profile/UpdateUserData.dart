import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sandtgroup/FirstScreen/Profile.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateUserData extends StatefulWidget {
  @override
  _UpdateUserDataState createState() => _UpdateUserDataState();
}

class _UpdateUserDataState extends State<UpdateUserData> {
  bool _fnamevalid = true;
  bool _lnamevalid = true;
  String _email = getEmail();
  String _tokentype;
  int _role;
  int _btnstate = 0;

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fnameController.text = getfname();
    lnameController.text = getlname();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void updatedata() async {
    var url = getUrl() + "/updateuser/name";
    await Future.delayed(Duration(milliseconds: 3000));
    var body = jsonEncode({
      'email': _email,
      'username': fnameController.text,
      'lname': lnameController.text,
    });
    try {
      final res = await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) {
        setState(() {
          _btnstate = 3;
        });
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Profile()));
      } else {
        _showErrorDialog("Please try again");
      }
    } on TimeoutException catch (_) {
      _showErrorDialog("Internet Connection Problem");
    } catch (error) {
      _showErrorDialog('Something went wrong. Please try again later.');
    }
    setState(() {
      _btnstate = 0;
    });
  }

  Widget _buildConfirmBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            setState(() {
              validate();
            });

            if (_lnamevalid == true && _fnamevalid == true) {
              setState(() {
                _btnstate = 1;
              });
              setName();
              updateSavedata();
              updatedata();
            }
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blueAccent,
          child: setUpButtonChild()),
    );
  }

  Widget setUpButtonChild() {
    if (_btnstate == 0) {
      return new Text(
        'Update',
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 1.5,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        ),
      );
    } else if (_btnstate == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          "My Profile",
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                    Colors.white,
                    Colors.white
                  ],
                  stops: [0.009, 0.2, 0.8, 0.9],
                ),
              ),
            ),
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: MediaQuery.of(context).size.height / 25,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          'Update User Details',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.0),
                    _buildFNameTF(),
                    SizedBox(height: 20.0),
                    _buildLNameTF(),
                    SizedBox(height: 20.0),
                    _buildConfirmBtn(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFNameTF() {
    return Padding(
      padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
      child: TextFormField(
        controller: fnameController,
        onChanged: (value) {
          setState(() {
            _fnamevalid = true;
          });
        },
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
            errorText: _fnamevalid ? null : 'Enter first name',
            labelText: 'First Name',
            prefixIcon: Padding(
              padding: EdgeInsets.only(top: 0),
              child: Icon(
                FontAwesomeIcons.userTie,
                color: Colors.black,
              ),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.circular(35.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(35.0),
            )),
      ),
    );
  }

  Widget _buildLNameTF() {
    return Padding(
      padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
      child: TextFormField(
        controller: lnameController,
        onChanged: (value) {
          setState(() {
            _lnamevalid = true;
          });
        },
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
            errorText: _lnamevalid ? null : 'Enter last name',
            labelText: 'Last Name',
            prefixIcon: Padding(
              padding: EdgeInsets.only(top: 0),
              child: Icon(
                FontAwesomeIcons.userCircle,
                color: Colors.black,
              ),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.circular(35.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(35.0),
            )),
      ),
    );
  }

  void validate() {
    fnameController.text.isEmpty ? _fnamevalid = false : _fnamevalid = true;
    lnameController.text.isEmpty ? _lnamevalid = false : _lnamevalid = true;
  }

  void _reset() {
    fnameController.text = "";
    lnameController.text = "";
  }

  void setName() {
    setlname(lnameController.text);
    setfname(fnameController.text);
  }

  Future<void> updateSavedata() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'token': getToken(),
        'username': fnameController.text,
        'lname': lnameController.text,
        'email': _email,
        'role': getrole(),
        'tokentype': getTokentype()
      },
    );
    prefs.setString('userData', userData);
  }
}
