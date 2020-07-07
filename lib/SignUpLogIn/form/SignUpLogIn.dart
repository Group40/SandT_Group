import 'package:flutter/material.dart';
import '../form/sign_in.dart';
import '../form/first.dart';


class SignUpLogIn extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUpLogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
    
  }
  

  Widget _signInButton() {
    return OutlineButton(
      splashColor : Colors.grey,
      onPressed: (){
        signInWithGoogle().whenComplete(() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return FirstScreen();
          },
        ),
      );
    });
      },
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/login/google_logo.png"),height: 35.0,),
            Padding(
              padding: const EdgeInsets.only(left:10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(fontSize: 20,color: Colors.grey,)
              ),
              )
          ],
        ),
        ),
      );
      
  }
  
}
