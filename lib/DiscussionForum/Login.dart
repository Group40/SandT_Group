import 'package:flutter/material.dart';
import 'package:sandtgroup/DiscussionForum/DiscussionForum.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Enter',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: FlatButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DiscussionForum();
              }));
            },
            child: Text(
              'Enter Discussion Forum',
              style: TextStyle(color: Colors.cyan, fontSize: 20.0),
            )),
      ),
    );
  }
}
