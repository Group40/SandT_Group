import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './CourseDetail.dart';

class CourseList extends StatefulWidget {
  @override
  CourseListState createState() => CourseListState();
}

class CourseListState extends State<CourseList> {
  List data;

  String name;
  String url;
  String searchTerm;

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8080/findAllCourses"),
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
            print(data[i]["name"]);
            data[j] = data[i];
            j++;
          }
        }
        data.length = j;
      }
    }
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          onChanged: (value) {
            setState(() {
              searchTerm = value;
            });
          },
          decoration: InputDecoration(
              hintText: "Search Destination",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.black12,
              isDense: true,
              contentPadding: EdgeInsets.all(8)),
        ),
        iconTheme: new IconThemeData(color: Colors.purple),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              getData();
            },
            color: Colors.purple,
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // showFilterModal(context);
            },
            color: Colors.purple,
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
            // return AddCourse();
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
                Icons.school,
                color: Colors.black,
              ),
            ),
            title: Text(data[position]["name"],
                style: TextStyle(color: Colors.black54)),
            subtitle: Text(" " + data[position]["url"],
                style: TextStyle(color: Colors.black54)),
            onTap: () {
              debugPrint("Course clicked");
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CourseDetail(text: data[position]["id"]);
              }));
            },
          ),
        );
      },
    );
  }
}
