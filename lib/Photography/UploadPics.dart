//import 'package:path/path.dart'
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'package:sandtgroup/Photography/MainPage.dart';

import 'AdminFun/AdMainPage.dart';

var url = getUrl() + "/photouploading/uploadpic";

class UploadPics extends StatefulWidget {
  @override
  UploadPicsState createState() => UploadPicsState();
}

class UploadPicsState extends State<UploadPics> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descrptController = TextEditingController();
  TextEditingController townController = TextEditingController();
  TextEditingController districController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  File _image;
  int _state = 0;
  bool _validatetitle = true;
  bool _validatedis = true;
  bool _picvalidate = false;
  DateTime _dateTime = DateTime.now();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void _picsend() async {
    // ignore: deprecated_member_use
    var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
    var length = await _image.length();
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: _image.path.split('/').last
        //basename(_image.path),
        );
    request.fields['email'] = getEmail();
    request.fields['title'] = titleController.text;
    request.fields['detail'] = descrptController.text;
    request.fields['town'] = townController.text;
    request.fields['distric'] = districController.text;
    request.fields['date'] = dateController.text;
    request.fields['name'] = getUsername();
    request.files.add(multipartFile);
    //var response = await request.send()
    try {
      final response =
          await request.send().timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        setState(() {
          _state = 0;
        });
        _showRespondDialog("You Image has been uploaded", "Uploaded");
      } else {
        _showRespondDialog("Something Went wrong, Try Again", "Error");
      }
    } on TimeoutException catch (_) {
      _showRespondDialog("Internet Connection Error", "Error");
    }
    /*
    request.send().then((response) {
      if (response.statusCode == 200) {
        _showRespondDialog("You Image has been uploaded", "Uploaded");
      } else {
        _showRespondDialog("Something Went wrong, Try Again", "Error");
      }
    });*/
  }

  Future getimage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      _picvalidate = true;
    });
  }

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Astro Photography'),
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
        bottomNavigationBar: getrole() == 1
            ? MainPage(2)
            : getrole() == 0
                ? null
                : AdMainPage(2),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 40, right: 80, left: 80),
              child: new Column(
                children: <Widget>[
                  GridView.count(
                    shrinkWrap: true,
                    primary: false,
                    //padding: const EdgeInsets.all(70),
                    //crossAxisSpacing: 10,
                    //mainAxisSpacing: 10,
                    crossAxisCount: 1,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          getimage();
                        },
                        child: Container(
                          color: _image == null
                              ? Theme.of(context).primaryColor.withOpacity(0.4)
                              : Colors.transparent,
                          child: _image == null
                              ? Icon(FontAwesomeIcons.camera)
                              : Image.file(_image),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
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
                controller: townController,
                onChanged: (value) {
                  setState(() {
                    _validatetitle = true;
                  });
                },
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                decoration: InputDecoration(
                    errorText: _validatetitle ? null : 'Town Can\'t Be Empty',
                    labelText: 'Capture Town',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Icon(
                        FontAwesomeIcons.home,
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
                controller: districController,
                onChanged: (value) {
                  setState(() {
                    _validatetitle = true;
                  });
                },
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                decoration: InputDecoration(
                    errorText:
                        _validatetitle ? null : 'Distric Can\'t Be Empty',
                    labelText: 'Capture Distric',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Icon(
                        Icons.location_on,
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
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  //Date Field
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller: dateController
                        ..text = _dateTime.toString().substring(0, 10),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter the date';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      onChanged: (value) {
                        //debugPrint('Something changed in Text Field');
                      },
                      decoration: InputDecoration(
                          labelText: 'Date',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(top: 0),
                            // add padding to adjust icon
                            child: Icon(
                              Icons.date_range,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor,
                                width: 0.0),
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          )),
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),

                  //Calendar Button
                  Expanded(
                    child: ButtonTheme(
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          'Select Captured date',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2222),
                          ).then((date) => {
                                setState(() {
                                  if (date == null) {
                                    date = DateTime.now();
                                  }
                                  _dateTime = date;
                                }),
                              });
                        },
                      ),
                    ),
                  ),
                ],
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
                        if (_picvalidate) {
                          setState(() {
                            (titleController.text.isEmpty)
                                ? _validatetitle = false
                                : _validatetitle = true;
                            (descrptController.text.isEmpty)
                                ? _validatedis = false
                                : _validatedis = true;
                            (townController.text.isEmpty)
                                ? _validatedis = false
                                : _validatedis = true;
                            (districController.text.isEmpty)
                                ? _validatedis = false
                                : _validatedis = true;
                            (dateController.text.isEmpty)
                                ? _validatedis = false
                                : _validatedis = true;
                          });
                          if ((_validatetitle == true) &&
                              (_validatedis == true)) {
                            setState(() {
                              _state = 1;
                              _picsend();
                            });
                          }
                        } else {
                          _showRespondDialog(
                              "Please select an image", "Warning");
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

  void _reset() {
    titleController.text = '';
    descrptController.text = '';
    _image = null;
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

  void _showRespondDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
              _reset();
              setState(() {
                _state = 0;
                _picvalidate = false;
                //_validatetitle = false;
              });
            },
          ),
          FlatButton(
            child: Text('Go Back'),
            onPressed: () {
              _reset();
              setState(() {
                _state = 0;
              });
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
