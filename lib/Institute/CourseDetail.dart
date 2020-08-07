import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class CourseDetail extends StatefulWidget {
  final String text;

  CourseDetail({Key key, @required this.text}) : super(key: key);

  @override
  CourseDetailState createState() => CourseDetailState(text);
}

class CourseDetailState extends State<CourseDetail> {
  CourseDetailState(String text);

  var course;
  String name = '';
  String id = '';
  String ageGroupMin = '';
  String ageGroupMax = '';
  String price = '';
  String location = '';
  String description = '';
  String url = '';

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8080/findAllCourses/" + widget.text),
        headers: {"Accept": "application/json"});

    this.setState(() {
      course = jsonDecode(response.body);
      id = course['id'];
      name = course['name'];
      ageGroupMin = course['ageGroupMin'];
      ageGroupMax = course['ageGroupMax'];
      price = course['price'];
      location = course['location'];
      description = course['description'];
      url = course['url'];
    });
  }

  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //Call get data
  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQueryData = MediaQuery.of(context);
    var screenWidth = _mediaQueryData.size.width;
    var screenHeight = _mediaQueryData.size.height;
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.01,
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18.0,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      body: Builder(
        builder: (context) => Form(
          child: Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                //Location Text
                Container(
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Theme.of(context).accentColor,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.black54,
                          )),
                      title: Text(
                        location,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),

                //Age
                Container(
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.assignment_ind,
                            color: Colors.black54,
                          )),
                      title: Text(
                        "From age " + ageGroupMin + " to " + ageGroupMax,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),

                //Price
                Container(
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Theme.of(context).accentColor,
                          child: Icon(
                            Icons.monetization_on,
                            color: Colors.black54,
                          )),
                      title: Text(
                        price,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),

                //Description
                Container(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListTile(
                      subtitle: Text(
                        "Description :\n" + description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).accentColor,
                          child: Text(
                            'More Information',
                          ),
                          onPressed: () {
                            _launchURL();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    throw UnimplementedError();
  }
}
