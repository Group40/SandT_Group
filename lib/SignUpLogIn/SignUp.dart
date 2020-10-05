import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

var url = "http://192.168.1.26:8080/auth/signup";

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  String _fname;
  String _lname;
  String _email;
  String _token;
  String _tokentype;
  int _role;
  bool _btnstate = false;
  bool _emailvalidate = true;
  bool _fnamevalidate = true;
  bool _lnamevalidate = true;
  bool _passwordvalidate = true;
  bool _2passwordvalidate = true;

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

  void sends() async {
    var body = jsonEncode({
      'username': fnameController.text,
      'lname': lnameController.text,
      'email': emailController.text,
      'password': passwordController.text,
    });
    try {
      final res = await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });

      if (res.statusCode == 200) {
        _reset();
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

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => SplashScreen()));
      } else {
        _resetEmail();
        _showErrorDialog("Email is already using try to login");
      }
    } catch (error) {
      _showErrorDialog('Could not authenticate you. Please try again later.');
    }
    setState(() {
      _btnstate = false;
    });
  }

  Widget _buildEmailTF() {
    return Padding(
      padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
      child: TextFormField(
        controller: emailController,
        onChanged: (value) {
          setState(() {
            _emailvalidate = true;
          });
        },
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
            errorText: _emailvalidate ? null : 'Enter valid email address',
            labelText: 'Email',
            prefixIcon: Padding(
              padding: EdgeInsets.only(top: 0),
              child: Icon(
                Icons.email,
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

  Widget _buildFNameTF() {
    return Padding(
      padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
      child: TextFormField(
        controller: fnameController,
        onChanged: (value) {
          setState(() {
            _fnamevalidate = true;
          });
        },
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
            errorText: _fnamevalidate ? null : 'Enter first name',
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
            _lnamevalidate = true;
          });
        },
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
            errorText: _lnamevalidate ? null : 'Enter last name',
            labelText: 'Last Name',
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

  Widget _buildPasswordTF() {
    return Padding(
      padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
      child: TextFormField(
        obscureText: true,
        controller: passwordController,
        onChanged: (value) {
          setState(() {
            _passwordvalidate = true;
          });
        },
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
            errorText: _passwordvalidate
                ? null
                : 'Use 8 characters or more for your password',
            labelText: 'Password',
            prefixIcon: Padding(
              padding: EdgeInsets.only(top: 0),
              child: Icon(
                FontAwesomeIcons.lock,
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

  Widget _buildPasswordReTF() {
    return Padding(
      padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
      child: TextFormField(
        obscureText: true,
        controller: passwordController2,
        onChanged: (value) {
          setState(() {
            _2passwordvalidate = true;
          });
        },
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
            errorText: _2passwordvalidate
                ? null
                : 'Those password didn\'t match try again',
            labelText: 'Confirm Password',
            prefixIcon: Padding(
              padding: EdgeInsets.only(top: 0),
              child: Icon(
                FontAwesomeIcons.lock,
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

  Widget _buildSignupBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            validate();
            passwordvalidate();
            if (_fnamevalidate == true &&
                _lnamevalidate == true &&
                _passwordvalidate == true &&
                _2passwordvalidate == true) {
              setState(() {
                _btnstate = true;
                sends();
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

  Widget setUpButtonChild() {
    if (_btnstate == false) {
      return new Text(
        'SIGH UP',
        style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 20.0,
            fontWeight: FontWeight.bold),
      );
    } else if (_btnstate == true) {
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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                //height: double.infinity,
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
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                //height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    // vertical: MediaQuery.of(context).size.height / 5,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      Text(
                        'SIGH UP',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Opacity(
                          opacity: 0.8,
                          child: Image.asset(
                            'assets/image/logo.jpg',
                            scale: 13,
                          )),
                      SizedBox(height: 10.0),
                      _buildFNameTF(),
                      _buildLNameTF(),
                      _buildEmailTF(),
                      _buildPasswordTF(),
                      _buildPasswordReTF(),
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _reset() {
    emailController.text = '';
    passwordController.text = '';
    fnameController.text = '';
    lnameController.text = '';
    passwordController2.text = "";
  }

  void _resetEmail() {
    emailController.text = '';
  }

  void passwordvalidate() {
    if (_passwordvalidate) {
      passwordController.text == passwordController2.text
          ? _2passwordvalidate = true
          : _2passwordvalidate = false;
    }
  }

  void validate() {
    fnameController.text.isEmpty
        ? _fnamevalidate = false
        : _fnamevalidate = true;
    lnameController.text.isEmpty
        ? _lnamevalidate = false
        : _lnamevalidate = true;
    EmailValidator.validate(emailController.text)
        ? _emailvalidate = true
        : _emailvalidate = false;
    passwordController.text.length > 7
        ? _passwordvalidate = true
        : _passwordvalidate = false;
  }
}
