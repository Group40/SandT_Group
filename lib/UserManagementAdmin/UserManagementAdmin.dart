import 'package:flutter/material.dart';
import './CrewMembers.dart';
import './Admins.dart';
import './Block.dart';


class UserManagementAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manage Users',
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.cyan,
          accentColor: Colors.indigoAccent),
    );
    throw UnimplementedError();
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 10.0, top: 40.0),
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              AdminButton(),
              CrewButton(),
              BlockButton(),
            ],
          ),
        ),
      ),
    );

    throw UnimplementedError();
  }
}

class AdminButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      width: 250.0,
      height: 50.0,
      child: RaisedButton(
        textColor: Colors.white,
        child: Container(
          decoration: const BoxDecoration (
            color: Colors.blue,
          ),
          child: Text(
            "Admins",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
        elevation: 6.0,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Admins();
          }));
        }, //onpressed
      ),
    );
    throw UnimplementedError();
  }
}

class CrewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      width: 250.0,
      height: 50.0,
      child: RaisedButton(
        textColor: Colors.white,
        child: Container(
            decoration: const BoxDecoration (
              color: Colors.blue,
            ),
          child: Text(
            "Crew Members",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
        elevation: 6.0,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CrewMembers();
          }));
        }, //onpressed
      ),
    );
    throw UnimplementedError();
  }
}

class BlockButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      width: 250.0,
      height: 50.0,
      child: RaisedButton(
        color: Colors.red,
        textColor: Colors.white,
        child: Container(
          decoration: const BoxDecoration (
            color: Colors.red,
          ),
          child: Text(
            "Block Users",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
        elevation: 6.0,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Block();
          }));
        }, //onpressed
      ),
    );
    throw UnimplementedError();
  }
}

/*class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
        centerTitle: true,
        backgroundColor: Colors.blue[600],
      ),
      body: Center(
        child: Text('hello',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.grey[600],

          ),
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text('click '),
        backgroundColor: Colors.red[600],
      ),
    );
  }
}*/
