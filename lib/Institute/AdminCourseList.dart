import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import './EditCourse.dart';
import './AddCourse.dart';

class AdminCourse extends StatefulWidget {
  @override
  AdminCourseState createState() => AdminCourseState();
}

class AdminCourseState extends State<AdminCourse> {
  List data;

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8080/findAllCourses"),
        headers: {"Accept": "application/json"});
    this.setState(() {
      data = jsonDecode(response.body);
    });
    return "success!";
  }

  void delete(String id) async {
    final http.Response response = await http.delete(
      'http://10.0.2.2:8080/deleteCourse/' + id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    setState(() {
      initState();
    });
  }

  void showSnackBar(BuildContext context, String id) {
    var snackBar = SnackBar(
      backgroundColor: Colors.black54,
      content: Text(
        'Permently delete the course?',
        style: TextStyle(fontSize: 20, color: Colors.white70),
      ),
      action: SnackBarAction(
          textColor: Colors.cyan,
          label: "YES",
          onPressed: () {
            delete(id);
          }),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  //Call get data
  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Published Courses'),
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          debugPrint("Fab click");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddCourse();
          }));
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
    throw UnimplementedError();
  }

  ListView getListView() {
    //TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.cyan[100],
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.cyan,
              child: Icon(
                Icons.event_available,
                color: Colors.black,
              ),
            ),
            title: Text(data[position]["name"],
                style: TextStyle(color: Colors.black54)),
            subtitle: Text(data[position]["url"],
                style: TextStyle(color: Colors.black54)),
            trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                tooltip: 'Delete this course',
                onPressed: () {
                  showSnackBar(context, data[position]["id"]);
                }),
            onTap: () {
              debugPrint("Course clicked");
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EditCourse(text: data[position]["id"]);
              }));
            },
          ),
        );
      },
    );
  }
}
