import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';

var url2 = "http://10.0.2.2:8080/updateCourse";

class CourseDetail extends StatefulWidget {
  final String text;

  CourseDetail({Key key, @required this.text}) : super(key: key);

  @override
  CourseDetailState createState() => CourseDetailState(text);
}

class CourseDetailState extends State<CourseDetail> {
  CourseDetailState(String text);

  var isLiked = false;
  var course;
  String name = '';
  String id = '';
  String ageGroupMin = '';
  String ageGroupMax = '';
  String price = '';
  String location = '';
  String description = '';
  String url = '';
  var likedUsers = {};
  String uid = getToken();

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
      // likedUsers = course['likedUsers'];
      // likedUsers = jsonDecode(response.body)['likedUsers'];
    });
    print(course['likedUsers']);
    // print(jsonDecode(response.body)['likedUsers']);
    // likedUsers.forEach((element) {
    //   if (element == uid) {
    //     setState(() {
    //       isLiked = true;
    //     });
    //   }
    // });
    // print(likedUsers);
    if (course['likedUsers'] != null) {
      for (var i = 0; i < course['likedUsers'].length; i++) {
        if (course['likedUsers'][i] == uid) {
          setState(() {
            isLiked = true;
          });
        }
      }
    }
  }

  void likeOrUnlike() async {
    if (course['likedUsers'] == null) {
      print("likedUsers = null");
    } else if (isLiked == true) {
      course['likedUsers'].remove(uid);
      print(course['likedUsers']);
      setState(() {
        isLiked = false;
      });
    } else {
      course['likedUsers'].add(uid);
      setState(() {
        isLiked = true;
      });
    }

    try {
      var body = jsonEncode({
        'id': id,
        'name': name,
        'ageGroupMin': ageGroupMin,
        'ageGroupMax': ageGroupMax,
        'price': price,
        'location': location,
        'description': description,
        'url': url,
        'likedUsers': course['likedUsers']
      });
      return await http.post(url2, body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).then((dynamic res) {
        print(res.toString());
      });
    } catch (err) {
      print(err);
    }
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

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (course != null && course['likedUsers'] != null)
                          ? Text(
                              course['likedUsers'].length.toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          : Text(
                              '0',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        onPressed: likeOrUnlike,
                        icon: Icon(
                          Icons.thumb_up,
                          color: isLiked ? Colors.purple : Colors.black,
                          size: 30,
                        ),
                      ),
                    ],
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
