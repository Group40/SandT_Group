import 'package:flutter/material.dart';
import 'package:sandtgroup/DiscussionForum/CreateForum.dart';
import 'package:sandtgroup/DiscussionForum/Login.dart';

import './ArticleHandling/ArticleHandling.dart';
import './DiscussionForum/DiscussionForum.dart';
import './EventPublishingBooking/EventBooking.dart';
import './EventPublishingBooking/EventPublishing.dart';
import './SignUpLogIn/SignUpLogIn.dart';
import './UserManagementAdmin/UserManagementAdmin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'S & T Group',
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.cyan,
          accentColor: Colors.cyan),
    );
    throw UnimplementedError();
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('S & T Group'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 10.0, top: 40.0),
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SakuniButton(),
              SandunButton(),
              PiyumalButton(),
              HasiniButton(),
              PunsaraButton(),
            ],
          ),
        ),
      ),
    );

    throw UnimplementedError();
  }
}

class SakuniButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      width: 250.0,
      height: 50.0,
      child: RaisedButton(
        color: Colors.cyan,
        child: Text(
          "Sakuni",
          style: TextStyle(fontSize: 20.0, color: Colors.blue[900]),
        ),
        elevation: 6.0,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UserManagementAdmin();
          }));
        },
      ),
    );
    throw UnimplementedError();
  }
}

class SandunButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      width: 250.0,
      height: 50.0,
      child: RaisedButton(
        color: Colors.cyan,
        child: Text(
          "Sandun",
          style: TextStyle(fontSize: 20.0, color: Colors.blue[900]),
        ),
        elevation: 6.0,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SignUpLogIn();
          }));
        },
      ),
    );
    throw UnimplementedError();
  }
}

class PiyumalButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      width: 250.0,
      height: 50.0,
      child: Row(
        children: <Widget>[
          RaisedButton(
            color: Colors.cyan,
            child: Text(
              "Piyumal",
              style: TextStyle(fontSize: 20.0, color: Colors.blue[900]),
            ),
            elevation: 6.0,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EventBooking();
              }));
            },
          ),
          RaisedButton(
            color: Colors.cyan,
            child: Text(
              "Admin",
              style: TextStyle(fontSize: 20.0, color: Colors.blue[900]),
            ),
            elevation: 6.0,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EventPublishing();
              }));
            },
          ),
        ],
      ),
    );
    throw UnimplementedError();
  }
}

class HasiniButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      width: 250.0,
      height: 50.0,
      child: Row(
        children: <Widget>[
          RaisedButton(
            color: Colors.cyan,
            child: Text(
              "Hasini",
              style: TextStyle(fontSize: 20.0, color: Colors.blue[900]),
            ),
            elevation: 6.0,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Login();
              }));
            },
          ),
          RaisedButton(
            color: Colors.cyan,
            child: Text(
              "Admin",
              style: TextStyle(fontSize: 20.0, color: Colors.blue[900]),
            ),
            elevation: 6.0,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CreateForum();
              }));
            },
          ),
        ],
      ),
    );
    throw UnimplementedError();
  }
}

class PunsaraButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      width: 250.0,
      height: 50.0,
      child: RaisedButton(
        color: Colors.cyan,
        child: Text(
          "Punsara",
          style: TextStyle(fontSize: 20.0, color: Colors.blue[900]),
        ),
        elevation: 6.0,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ArticleHandling();
          }));
        },
      ),
    );
    throw UnimplementedError();
  }
}
