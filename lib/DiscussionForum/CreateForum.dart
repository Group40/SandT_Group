import 'package:flutter/material.dart';

class CreateDiscussion extends StatefulWidget {
  @override
  _CreateForumState createState() => _CreateForumState();
}

class _CreateForumState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Create',
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
                return null;
              }));
            },
            child: Text(
              'Create Discussion Forum',
              style: TextStyle(color: Colors.cyan, fontSize: 20.0),
            )),
      ),
    );
  }
}
