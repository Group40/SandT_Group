import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';

var url2 = getUrl() + "/updateCourse";

class CourseDetail extends StatefulWidget {
  final String text;

  CourseDetail({Key key, @required this.text}) : super(key: key);

  @override
  CourseDetailState createState() => CourseDetailState(text);
}

class CourseDetailState extends State<CourseDetail> {
  CourseDetailState(String text);
  TextEditingController commentController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  var isLiked = false;
  var isCommented = false;
  var course;
  String name = '';
  String id = '';
  String ageGroupMin = '';
  String ageGroupMax = '';
  String price = '';
  String location = '';
  String description = '';
  String url = '';

  String comment = '';
  String commentData = '';
  String commentDataOld = '';
  var likedUsers = {};
  String uid = getToken();

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(getUrl() + "/findAllCourses/" + widget.text),
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
      comment = '';
    });
    if (course['likedUsers'] != null) {
      for (var i = 0; i < course['likedUsers'].length; i++) {
        if (course['likedUsers'][i] == uid) {
          setState(() {
            isLiked = true;
          });
        }
      }
    }
    if (course['commentedUsers'] != null) {
      for (var i = 0; i < course['commentedUsers'].length; i++) {
        String str = course['commentedUsers'][i];
        const startToken = "UserToken.u99D5,hq={";
        const endToken = "}=EndUserToken.sK98,Tf1 UserName.f*j2I],9={";
        final startIndexToken = str.indexOf(startToken);
        final endIndexToken =
            str.indexOf(endToken, startIndexToken + startToken.length);
        if (course['commentedUsers'][i].contains(uid, 10) &&
            str.substring(startIndexToken + startToken.length, endIndexToken) ==
                uid) {
          const start = "}=EndUserName.iH8,g7f1 UserComment.j&gVpk,4={";
          const end = "}=EndUserComment.p9&5vGf,";
          final startIndex = str.indexOf(start);
          final endIndex = str.indexOf(end, startIndex + start.length);
          print(str.substring(startIndex + start.length, endIndex));
          setState(() {
            isCommented = true;
            comment = str.substring(startIndex + start.length, endIndex);
            commentDataOld = str;
          });
        }
      }
    }
  }

  void addComment() async {
    commentData = 'UserToken.u99D5,hq={' +
        getToken() +
        '}=EndUserToken.sK98,Tf1 UserName.f*j2I],9={' +
        getUsername() +
        '}=EndUserName.iH8,g7f1 UserComment.j&gVpk,4={' +
        commentController.text +
        '}=EndUserComment.p9&5vGf,';
    if (course['commentedUsers'] == null) {
      print("commentedUsers = null");
    } else if (isCommented == true) {
      course['commentedUsers'].remove(commentDataOld);
      course['commentedUsers'].add(commentData);
    } else {
      course['commentedUsers'].add(commentData);
      setState(() {
        isCommented = true;
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
        'likedUsers': course['likedUsers'],
        'commentedUsers': course['commentedUsers']
      });
      return await http.post(url2, body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).then((dynamic res) {
        print(res.toString());
        getData();
      });
    } catch (err) {
      print(err);
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
        'likedUsers': course['likedUsers'],
        'commentedUsers': course['commentedUsers']
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
      body: (course == null)
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : Builder(
              builder: (context) => Form(
                key: _formKey,
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

                      //Like section
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            (course != null && course['likedUsers'] != null)
                                ? Text(
                                    "This course have " +
                                        course['likedUsers'].length.toString() +
                                        " likes!",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black54),
                                  )
                                : Text(
                                    '0',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                            SizedBox(
                              width: 20,
                            ),
                            IconButton(
                              onPressed: likeOrUnlike,
                              icon: Icon(
                                Icons.thumb_up,
                                color: isLiked
                                    ? Theme.of(context).primaryColor
                                    : Colors.black54,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Comment field
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextFormField(
                          controller: commentController..text,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'comment section cannot be empty';
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (value) {
                            comment = value;
                            debugPrint('Something changed in Text Field');
                          },
                          decoration: InputDecoration(
                              labelText: 'Add a comment here',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                color: Theme.of(context).accentColor,
                                textColor: Theme.of(context).primaryColor,
                                child: Text(
                                  'Add a comment',
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_formKey.currentState.validate()) {
                                      addComment();
                                    }
                                  });
                                },
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
                                  'Visit for More Information',
                                ),
                                onPressed: () {
                                  _launchURL();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Comment section
                      Divider(),
                      Text(
                        "Comment Section",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Divider(),
                      Container(
                        child: (course == null ||
                                course['commentedUsers'].length == 0)
                            ? Center(
                                child: Text(
                                    "No comments available for this Course",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor)))
                            : Column(
                                children: [
                                  for (var i = 0;
                                      i < course['commentedUsers'].length;
                                      i++)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 0.0, bottom: 0.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Card(
                                              color:
                                                  Theme.of(context).accentColor,
                                              elevation: 0.0,
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                                //Title
                                                title: Text(
                                                    ((course['commentedUsers'][i]).substring(
                                                        ((course['commentedUsers'][i])
                                                                .indexOf(
                                                                    '}=EndUserToken.sK98,Tf1 UserName.f*j2I],9={')) +
                                                            ('}=EndUserToken.sK98,Tf1 UserName.f*j2I],9={')
                                                                .length,
                                                        ((course['commentedUsers'][i]).indexOf(
                                                            ('}=EndUserName.iH8,g7f1 UserComment.j&gVpk,4={'),
                                                            ((course['commentedUsers']
                                                                        [i])
                                                                    .indexOf(
                                                                        '}=EndUserToken.sK98,Tf1 UserName.f*j2I],9={')) +
                                                                ('}=EndUserToken.sK98,Tf1 UserName.f*j2I],9={')
                                                                    .length)))),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                                subtitle: Text(
                                                    ((course['commentedUsers'][i]).substring(
                                                        ((course['commentedUsers']
                                                                    [i])
                                                                .indexOf(
                                                                    "}=EndUserName.iH8,g7f1 UserComment.j&gVpk,4={")) +
                                                            ("}=EndUserName.iH8,g7f1 UserComment.j&gVpk,4={")
                                                                .length,
                                                        ((course['commentedUsers'][i]).indexOf(
                                                            ("}=EndUserComment.p9&5vGf,"),
                                                            ((course['commentedUsers']
                                                                        [i])
                                                                    .indexOf(
                                                                        "}=EndUserName.iH8,g7f1 UserComment.j&gVpk,4={")) +
                                                                ("}=EndUserName.iH8,g7f1 UserComment.j&gVpk,4={")
                                                                    .length)))),
                                                    style: TextStyle(
                                                        color: Colors.black54)),
                                              ),
                                            ),
                                          ),
                                        ],
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
