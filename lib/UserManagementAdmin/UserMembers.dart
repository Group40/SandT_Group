import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:sandtgroup/FirstScreen/Splash.dart';

import 'ViewUserData.dart';

class NormalUsers extends StatefulWidget {
  @override
  _NormalUsersState createState() => _NormalUsersState();
}

class _NormalUsersState extends State<NormalUsers> {
  List data;

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(getUrl() + "/userdata/finduser"),
        headers: {"Accept": "application/json"});
    this.setState(() {
      data = jsonDecode(response.body);
    });
    return "success!";
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Text(
          "Normal Users",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: (data == null)
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : getListView(),
    );
  }

  ListView getListView() {
    //TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Theme.of(context).accentColor,
          elevation: 2.0,
          child: Column(
            children: <Widget>[
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    child: Icon(Icons.people),
                  ),
                  title: Text(
                      "Name : " +
                          data[position]["username"] +
                          data[position]["lname"],
                      style: TextStyle(color: Colors.black54)),
                  subtitle: Text("\nEmail : " + data[position]["email"],
                      style: TextStyle(color: Colors.black54)),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewUserData(
                          name: data[position]["username"] +
                              data[position]["lname"],
                          email: data[position]["email"],
                          role: 1,
                          date: data[position]["username"],
                          id: data[position]["id"],
                        ),
                      ))),
            ],
          ),
        );
      },
    );
  }
}
