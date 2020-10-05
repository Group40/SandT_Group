import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ViewAllForums extends StatefulWidget {
  @override
  _ViewAllForums createState() => new _ViewAllForums();
}

class _ViewAllForums extends State<ViewAllForums> {
  List data;

  Future<List<Forums>> getAllForums() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://192.168.1.26:8080/getForums"),
        headers: {"Accept": "application/json"});
    data = jsonDecode(response.body);
    print(response.statusCode);

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
    return Scaffold(
      body: Container(
        child: FutureBuilder(
            future: getAllForums(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Icon(Icons.assignment),
                        title: Text(data[index]["title"]),
                        subtitle: Text(data[index]["date"]),
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
  final String date;

  Forums({this.id, this.title, this.date});
}