import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './CourseDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CourseList extends StatefulWidget {
  @override
  CourseListState createState() => CourseListState();
}

class CourseListState extends State<CourseList> {
  TextEditingController ageController = TextEditingController();

  List data;
  var modal = false;
  String name;
  String url;
  String searchTerm;
  String age;

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
    if (age != null) {
      if (age.length != 0) {
        var j = 0;
        for (var i = 0; i < data.length; i++) {
          int ageGroupMinInt = int.parse(data[i]["ageGroupMin"]);
          int ageGroupMaxInt = int.parse(data[i]["ageGroupMax"]);
          int ageInt = int.parse(age);
          if ((ageGroupMinInt <= ageInt) && (ageInt <= ageGroupMaxInt)) {
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

  //Call get data
  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    if (modal) {
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
          iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                getData();
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                setState(() {
                  modal = !modal;
                });
              },
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
        body: filterModal(),
      );
    } else {
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
          iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                getData();
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                setState(() {
                  modal = !modal;
                });
              },
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
        body: getListView(),
      );
    }

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
                Icons.school,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(data[position]["name"],
                style: TextStyle(color: Theme.of(context).primaryColor)),
            subtitle: Text(
                "From age " +
                    data[position]["ageGroupMin"] +
                    " to " +
                    data[position]["ageGroupMax"],
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

  ListView filterModal() {
    //TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int position) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 330,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Filter Courses",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              Divider(),
              Text("By Age"),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  controller: ageController,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter an age group';
                    }
                    int valueInt = int.parse(value);
                    if (1 > valueInt) {
                      return 'Enter a real Age';
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (value) {
                    debugPrint('Something changed in Text Field');
                  },
                  decoration: InputDecoration(
                      labelText: 'My Age',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(top: 0),
                        // add padding to adjust icon
                        child: Icon(
                          Icons.view_agenda,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2.0),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      )),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: RaisedButton(
                  child: Text(
                    "Set Filter",
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () {
                    setState(() {
                      age = ageController.text;
                      modal = !modal;
                    });
                    getData();
                  },
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
