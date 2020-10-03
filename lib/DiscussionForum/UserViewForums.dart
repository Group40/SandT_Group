import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserViewForums extends StatefulWidget {
  UserViewForums({Key key, this.id, this.title, this.status}) : super(key: key);

  final String id;
  final String title;
  final String status;

  @override
  _UserViewForums createState() => new _UserViewForums();
}

class _UserViewForums extends State<UserViewForums> {
  Future<List<Forums>> _getForums() async {
    var response = await http.get("http://10.0.2.2:8080/findByStatus");
    var data = json.decode(response.body);

    List<Forums> forums = [];
    for (var f in data) {
      Forums forum = Forums();
      forums.add(forum);
    }
    print(forums.length);
    return forums;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'View Forums',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: _getForums(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                    child: Center(
                  child: CircularProgressIndicator(),
                ));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        trailing: Icon(Icons.assignment),
                        title: Text(snapshot.data[index].title),
                        subtitle: Text(snapshot.data[index].id),
                      );
                    });
              }
            }),
      ),
    );
    throw UnimplementedError();
  }
}

class Forums {
  final String id;
  final String title;
  final String status;

  Forums({this.id, this.title, this.status});
}
