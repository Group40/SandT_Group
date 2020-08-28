import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../SignUpLogIn/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdatePassword extends StatefulWidget {
  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  String _token;
  bool _currentpwvalid = true;
  bool _newpwvalid = true;
  bool _retypepwvalid = true;
  String _fname;
  String _lname;
  String _email = getEmail();
  String _tokentype;
  int _role;
  int _btnstate = 0;

  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController retypepasswordController = TextEditingController();

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

  void confirm() async {
    var url = getUrl() + "/auth/signin";
    await Future.delayed(Duration(milliseconds: 3000));
    var body = jsonEncode({
      'email': _email,
      'password': oldpasswordController.text,
    });
    try {
      final res = await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) {
        update();
      } else {
        _showErrorDialog("Your Current password is invalid");
        _reset();
        setState(() {
          _btnstate = 0;
          _currentpwvalid = false;
        });
      }
    } on TimeoutException catch (_) {
      //_reset();
      _showErrorDialog("Internet Connection Problem");
      setState(() {
        _btnstate = 0;
      });
    } catch (error) {
      _reset();
      _showErrorDialog('Something went wrong. Please try again later.');
      setState(() {
        _btnstate = 0;
      });
    }
  }

  void update() async {
    var url = getUrl() + "/updateuser/password";
    await Future.delayed(Duration(milliseconds: 3000));
    var body = jsonEncode({
      'email': _email,
      'password': newpasswordController.text,
    });
    try {
      final res = await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) {
        updatedata();
      } else {
        _showErrorDialog("Please try again");
        setState(() {
          _btnstate = 0;
        });
      }
    } on TimeoutException catch (_) {
      _showErrorDialog("Internet Connection Problem");
      setState(() {
        _btnstate = 0;
      });
    } catch (error) {
      _reset();
      _showErrorDialog('Something went wrong. Please try again later.');
      setState(() {
        _btnstate = 0;
      });
    }
  }

  void updatedata() async {
    var url = getUrl() + "/auth/signin";
    await Future.delayed(Duration(milliseconds: 3000));
    var body = jsonEncode({
      'email': _email,
      'password': newpasswordController.text,
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

        final pref = await SharedPreferences.getInstance();
        await pref.clear();
        Future.delayed(Duration(milliseconds: 3000));
        final responseData = json.decode(res.body);
        _token = responseData['accessToken'];
        _fname = responseData['username'];
        _lname = responseData['lname'];
        _email = responseData['email'];
        _tokentype = responseData['tokenType'];
        _role = responseData['erole'];

        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
            'username': _fname,
            'lname': _lname,
            'email': _email,
            'role': _role,
            'tokentype': _tokentype
          },
        );
        prefs.setString('userData', userData);
        Navigator.of(context).pop();
      } else {
        _showErrorDialog("Please try again");
        setState(() {
          _btnstate = 0;
        });
      }
    } on TimeoutException catch (_) {
      _showErrorDialog("Internet Connection Problem");
      setState(() {
        _btnstate = 0;
      });
    } catch (error) {
      _showErrorDialog('Something went wrong. Please try again later.');
      setState(() {
        _btnstate = 0;
      });
    }
  }

  Widget _buildCurrentPasswordTF() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Current Password',
            style: kLabelStyle,
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            //decoration: kBoxDecorationStyle,
            color: Colors.transparent,
            height: 60.0,
            child: TextFormField(
              obscureText: true,
              controller: oldpasswordController,
              onChanged: (value) {
                setState(() {
                  _currentpwvalid = true;
                });
              },
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(35.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
                errorText:
                    _currentpwvalid ? null : 'This Field Can\'t Be Empty',
                // border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'Enter your Current Password',
                //hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewPasswordTF() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'New Password',
            style: kLabelStyle,
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            //decoration: kBoxDecorationStyle,
            color: Colors.transparent,
            height: 60.0,
            child: TextFormField(
              obscureText: true,
              controller: newpasswordController,
              onChanged: (value) {
                setState(() {
                  _newpwvalid = true;
                });
              },
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(35.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
                errorText: _newpwvalid ? null : 'This Field Can\'t Be Empty',
                // border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'Enter your New Password',
                //hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetypePasswordTF() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Retype Password',
            style: kLabelStyle,
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            //decoration: kBoxDecorationStyle,
            color: Colors.transparent,
            height: 60.0,
            child: TextFormField(
              obscureText: true,
              controller: retypepasswordController,
              onChanged: (value) {
                setState(() {
                  _retypepwvalid = true;
                });
              },
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(35.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
                errorText: _retypepwvalid ? null : 'This Field Can\'t Be Empty',
                // border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'Retype your New Password',
                //hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
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
              newpasswordvalidate();
              chksamepassword();
            });

            if (_currentpwvalid == true &&
                _retypepwvalid == true &&
                _newpwvalid == true) {
              setState(() {
                _btnstate = 1;
                confirm();
              });
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

  chksamepassword() {
    if (_currentpwvalid && _newpwvalid) {
      if (newpasswordController.text == oldpasswordController.text) {
        _showErrorDialog('New Password Can not be the same one');
        setState(() {
          _newpwvalid = false;
          _retypepwvalid = true;
        });
      }
    }
  }

  Widget setUpButtonChild() {
    if (_btnstate == 0) {
      return new Text(
        'Confirm',
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
                          'Update My Password',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.0),
                    _buildCurrentPasswordTF(),
                    SizedBox(height: 40.0),
                    _buildNewPasswordTF(),
                    SizedBox(height: 20.0),
                    _buildRetypePasswordTF(),
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

  void validate() {
    oldpasswordController.text.isEmpty
        ? _currentpwvalid = false
        : _currentpwvalid = true;
    newpasswordController.text.length < 8
        ? _newpwvalid = false
        : _newpwvalid = true;
  }

  void newpasswordvalidate() {
    if (_currentpwvalid && _newpwvalid) {
      newpasswordController.text == retypepasswordController.text
          ? _retypepwvalid = true
          : _retypepwvalid = false;
    }
  }

  void _reset() {
    oldpasswordController.text = "";
    newpasswordController.text = "";
    retypepasswordController.text = "";
  }
}
