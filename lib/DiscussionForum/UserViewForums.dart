import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'DiscussionForum.dart';

class UserViewForums extends StatefulWidget {
  UserViewForums({Key key, this.id, this.title, this.status}) : super(key: key);

  final String id;
  final String title;
  final String status;

  @override
  _UserViewForums createState() => new _UserViewForums();
}

class _UserViewForums extends State<UserViewForums> {
  final scrollController = ScrollController(initialScrollOffset: 50.0);
  int urole;
  String status = "1";

  @override
  void initState() {
    urole = getrole();
  }

  List data;

  Future<List<Forums>> getForums() async {
    print("sdf");
    http.Response response = await http.get(
        Uri.encodeFull("http://192.168.1.26:8080/findByStatus/1"),
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

  bool showAppBar() {
    if (urole == 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: showAppBar()
          ? AppBar(
              title: Text(
                'Active Forums',
                style: TextStyle(color: Colors.white),
              ),
              leading: BackButton(
                color: Colors.white,
              ),
            )
          : null,
      body: Container(
        child: FutureBuilder(
            future: getForums(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                    child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                  ),
                ));
              } else {
                return Scrollbar(
                  isAlwaysShown: true,
                  controller: scrollController,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Icon(Icons.assignment),
                          title: Text(
                            data[index]["title"],
                            style: TextStyle(fontSize: 18),
                          ),
                          // subtitle: Text(data[index]["id"]),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => DiscussionForum(
                                        id: data[index]["id"],
                                        title: data[index]["title"])));
                          },
                        );
                      }),
                );
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
