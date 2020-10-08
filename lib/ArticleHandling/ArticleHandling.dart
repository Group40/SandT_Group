import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:async/async.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';

var url = getUrl() + "/addArticle";

class ArticleHandling extends StatefulWidget {
  @override
  _ArticleHandlingState createState() => _ArticleHandlingState();
}

class _ArticleHandlingState extends State<ArticleHandling> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descrptController = TextEditingController();
  File _image;
  int _state = 0;
  bool _validatetitle = true;
  bool _validatedis = true;
  bool _picvalidate = false;

  void _articleSend() async {
    debugPrint('function called');
    var body = jsonEncode({
      'ArticleTitle': titleController.text,
      'Description': descrptController.text,
      'email': getEmail(),
      'ArticleWriter_name': getUsername()
    });

    return http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      print("kasadldad");
      print(res.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Astro Articles'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.undo,
              ),
              onPressed: () {
                setState(() {
                  _reset();
                });
              },
            ),
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
              child: TextFormField(
                controller: titleController,
                onChanged: (value) {
                  setState(() {
                    _validatetitle = true;
                  });
                },
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                decoration: InputDecoration(
                    errorText: _validatetitle ? null : 'Title Can\'t Be Empty',
                    labelText: 'Title',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Icon(
                        FontAwesomeIcons.userCheck,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                controller: descrptController,
                onChanged: (value) {
                  setState(() {
                    _validatedis = true;
                  });
                },
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                decoration: InputDecoration(
                    errorText:
                        _validatedis ? null : 'Description Can\'t Be Empty',
                    labelText: 'Description',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Icon(
                        FontAwesomeIcons.book,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      shape: StadiumBorder(),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).accentColor,
                      child: setUpButtonChild(),
                      onPressed: () {
                        // setState(() {
                        //   (titleController.text.isEmpty)
                        //       ? _validatetitle = false
                        //       : _validatetitle = true;
                        //   (descrptController.text.isEmpty)
                        //       ? _validatedis = false
                        //       : _validatedis = true;
                        // });
                        // if ((_validatetitle == true) &&
                        //     (_validatedis == true)) {
                        //   setState(() {
                        //     _state = 1;
                        //     _articleSend();
                           

                           
                        //   });
                        // }

                        _articleSend();
                         showAlertDialog(BuildContext context) {
                              // set up the button
                              Widget okButton = FlatButton(
                                child: Text("OK"),
                                onPressed: () {
                                   Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArticleHandling()),
                            );
                                },
                              );

                              // set up the AlertDialog
                              AlertDialog alert = AlertDialog(
                                title: Text("My title"),
                                content: Text("This is my message."),
                                actions: [
                                  okButton,
                                ],
                              );

                              // show the dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            }
                      },
                      elevation: 6.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        'Upload',
        textScaleFactor: 1.4,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void _reset() {
    titleController.text = '';
    descrptController.text = '';
    _image = null;
  }
}
