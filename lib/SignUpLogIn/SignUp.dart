import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../SignUpLogIn/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var url = "http://10.0.2.2:8080/auth/signup";

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

  bool _emailvalidate = false;
  bool _namevalidate = false;
  bool _passwordvalidate = false;
  bool _passwor2dvalidate = false;

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
      } else {
        _resetEmail();
        _showErrorDialog("Email is already using tyr to login");
      }
      print(jsonDecode(res.body));
    } catch (error) {
      _showErrorDialog('Could not authenticate you. Please try again later.');
    }
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          //color: Colors.white,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              errorText: _emailvalidate ? 'Please Enter Valid Email' : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          //color: Colors.white,
          child: TextField(
            keyboardType: TextInputType.text,
            controller: fnameController,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              errorText: _namevalidate ? 'This field cannot be empty' : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.white,
              ),
              hintText: 'Enter your Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Last Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          //color: Colors.white,
          child: TextField(
            keyboardType: TextInputType.text,
            controller: lnameController,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.white,
              ),
              hintText: 'Enter your Last Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            controller: passwordController,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              errorText: _passwordvalidate
                  ? 'Please Enter Valid Password with at least 8 chara'
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordReTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Re Type',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            controller: passwordController2,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              errorText: _passwor2dvalidate ? 'Password Not Match' : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password Again',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
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
          if (_emailvalidate &&
              _namevalidate &&
              _passwordvalidate /*&&
              _passwor2dvalidate*/) {
            sends();
          }
        }, //=> sends(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white70,
        child: Text(
          'SIGH UP',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
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
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black26,
                      Colors.black26,
                      Colors.black38,
                      Colors.black54
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: MediaQuery.of(context).size.height / 5,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      /*Opacity(
                          opacity: 0.8,
                          child: Image.asset(
                            'assets/image/logo.jpg',
                            scale: 13,
                          )),*/
                      SizedBox(height: 20.0),
                      _buildFNameTF(),
                      SizedBox(height: 20.0),
                      _buildLNameTF(),
                      SizedBox(height: 20.0),
                      _buildEmailTF(),
                      SizedBox(height: 20.0),
                      _buildPasswordTF(),
                      SizedBox(height: 20.0),
                      //_buildPasswordReTF(),
                      SizedBox(height: 20.0),
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
  }

  void _resetEmail() {
    emailController.text = '';
    passwordController.text = '';
  }

  void validate() {
    fnameController.text.isEmpty ? _namevalidate = true : _namevalidate = false;
    validateEmail(emailController.text)
        ? _emailvalidate = true
        : _emailvalidate = false;

    passwordController.text.isEmpty
        ? _passwordvalidate = true
        : _passwordvalidate = false;

    paswordmatch() ? _passwor2dvalidate = true : _passwor2dvalidate = false;
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? true : false;
  }

  bool paswordmatch() {
    if (_passwordvalidate == false) {
      return true;
    } else {
      if (passwordController.text == passwordController2.text) {
        return true;
      } else {
        return true;
      }
    }
  }
}
