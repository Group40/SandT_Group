import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../SignUpLogIn/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'SignUp.dart';

var url = getUrl() + "/auth/signin";

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _token;
  bool _pwvalid = true;
  bool _emailvalid = true;
  String _id;
  String _fname;
  String _lname;
  String _email;
  String _tokentype;
  int _role;
  int _btnstate = 0;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
              _reset();
            },
          )
        ],
      ),
    );
  }

  void send() async {
    await Future.delayed(Duration(milliseconds: 3000));
    var body = jsonEncode({
      'email': emailController.text,
      'password': passwordController.text,
    });
    try {
      final res = await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) {
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
        setState(() {
          Future.delayed(Duration(milliseconds: 3000));
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => SplashScreen()));
        });
      } else {
        _showErrorDialog("Email or password invalid");
      }
    } on TimeoutException catch (_) {
      _showErrorDialog("Internet Connection Problem");
    } catch (error) {
      _showErrorDialog('Could not authenticate you. Please try again later.');
    }
    setState(() {
      _btnstate = 0;
    });
  }

  Widget _buildEmailTF() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Email',
            style: kLabelStyle,
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,

            //decoration: kBoxDecorationStyle,
            height: 60.0,
            //color: Colors.black,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              onChanged: (value) {
                setState(() {
                  _emailvalid = true;
                });
              },
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(35.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
                errorText:
                    _emailvalid ? null : 'Please Enter Valid Email Address',
                //border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                hintText: 'Enter your Email',
                //hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTF() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Password',
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
              controller: passwordController,
              onChanged: (value) {
                setState(() {
                  _pwvalid = true;
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
                errorText: _pwvalid ? null : 'This Field Can\'t Be Empty',
                // border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'Enter your Password',
                //hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            setState(() {
              (passwordController.text.isEmpty)
                  ? _pwvalid = false
                  : _pwvalid = true;
              EmailValidator.validate(emailController.text)
                  ? _emailvalid = true
                  : _emailvalid = false;
            });
            if (_pwvalid == true && _emailvalid == true) {
              setState(() {
                _btnstate = 1;
                send();
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
    if (_btnstate == 0) {
      return new Text(
        'LOGIN',
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

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => SignUpScreen())),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
          //onTap: () => FocusScope.of(context).unfocus(),
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
                    vertical: MediaQuery.of(context).size.height / 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Raleway'),
                      ),
                      SizedBox(height: 20.0),
                      Opacity(
                          opacity: 0.8,
                          child: Image.asset(
                            'assets/image/logo.jpg',
                            scale: 13,
                          )),
                      SizedBox(height: 20.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      _buildLoginBtn(),
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
  }
}
