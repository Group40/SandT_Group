import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import './EditCourse.dart';
import './AddCourse.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';

var notificationUrl = getUrl() + "/addNotification";

class AdminCourse extends StatefulWidget {
  @override
  AdminCourseState createState() => AdminCourseState();
}

class AdminCourseState extends State<AdminCourse> {
  List data;
  String searchTerm;

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(getUrl() + "/findAllCourses"),
        headers: {"Accept": "application/json"});
    this.setState(() {
      data = jsonDecode(response.body);
    });
    if (searchTerm != null) {
      if (searchTerm.length != 0) {
        var j = 0;
        for (var i = 0; i < data.length; i++) {
          if (data[i]["name"]
              .toLowerCase()
              .contains(searchTerm.toLowerCase())) {
            data[j] = data[i];
            j++;
          }
        }
        data.length = j;
      }
    }
    return "success!";
  }

  void delete(String id, String name) async {
    final http.Response response = await http.delete(
      getUrl() + '/deleteCourse/' + id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var notificationBody = jsonEncode({
      'authorName': getUsername(),
      'authorType': getrole(),
      'authorMail': getEmail(),
      'name': name,
      'nameType': "deleted the course",
      'date': DateTime.now().toString()
    });
    return http.post(notificationUrl, body: notificationBody, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      print(res.toString());
      setState(() {
        initState();
      });
    });
  }

  void showSnackBar(BuildContext context, String id, String name) {
    var snackBar = SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      content: Text(
        'Permently delete the course?',
        style: TextStyle(fontSize: 20, color: Colors.black54),
      ),
      action: SnackBarAction(
          textColor: Theme.of(context).primaryColor,
          label: "YES",
          onPressed: () {
            delete(id, name);
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          onChanged: (value) {
            setState(() {
              searchTerm = value;
            });
          },
          decoration: InputDecoration(
              hintText: "Search Course",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.black12,
              isDense: true,
              contentPadding: EdgeInsets.all(8)),
        ),
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              getData();
            },
            color: Theme.of(context).primaryColor,
          ),
        ],
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
          color: Theme.of(context).accentColor,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(data[position]["name"],
                style: TextStyle(color: Colors.black54)),
            subtitle: Text(
                "Age " +
                    data[position]["ageGroupMin"] +
                    " to " +
                    data[position]["ageGroupMax"],
                style: TextStyle(color: Colors.black54)),
            trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                tooltip: 'Delete this course',
                onPressed: () {
                  showSnackBar(
                      context, data[position]["id"], data[position]["name"]);
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
