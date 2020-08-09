import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './EventPublishing.dart';
import './RequestList.dart';
import './ConfirmedList.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';

var url = "http://10.0.2.2:8080/updateEvent";
var notificationUrl = "http://10.0.2.2:8080/addNotification";

class EditEvent extends StatefulWidget {
  final String text;

  EditEvent({Key key, @required this.text}) : super(key: key);

  @override
  EditEventState createState() => EditEventState(text);
}

class EditEventState extends State<EditEvent> {
  EditEventState(String text);
  DateTime _dateTime = DateTime.now();
  var _formKey = GlobalKey<FormState>();
  var event;
  String name = '';
  String id = '';
  String date = '';
  String venue = '';
  String description = '';
  String headCount = '';
  String available = '';

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8080/findAllEvents/" + widget.text),
        headers: {"Accept": "application/json"});

    this.setState(() {
      event = jsonDecode(response.body);
      id = event['id'];
      name = event['name'];
      date = event['date'];
      venue = event['venue'];
      description = event['description'];
      headCount = event['headCount'];
      available = event['available'];
    });
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void update() async {
    debugPrint('funtion called');
    var body = jsonEncode({
      'id': id,
      'name': nameController.text,
      'date': dateController.text,
      'venue': venueController.text,
      'description': descriptionController.text,
      'headCount': headCount,
      'available': available
    });
    var notificationBody = jsonEncode({
      'authorName': getUsername(),
      'authorType': getrole(),
      'authorMail': getEmail(),
      'name': nameController.text,
      'nameType': "edited the event",
      'date': DateTime.now().toString(),
      'eventDate': dateController.text
    });
    return await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      return http.post(notificationUrl, body: notificationBody, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).then((dynamic res) {
        print(res.toString());
      });
    });
  }

  void showSnackBar(BuildContext context) {
    var snackBar = SnackBar(
      backgroundColor: Colors.black54,
      content: Text(
        'Are you sure?',
        style: TextStyle(fontSize: 20, color: Colors.white70),
      ),
      action: SnackBarAction(
          textColor: Colors.cyan,
          label: "YES",
          onPressed: () {
            update();
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
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit this event"),
        //Optional back button
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
              Navigator.pop(context, true);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EventPublishing();
              }));
            }),
        //Optional back button ends
      ),
      body: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: Padding(
            padding:
                EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0, bottom: 5),
            child: ListView(
              children: <Widget>[
                //Buttons
                Padding(
                  padding: EdgeInsets.only(top: 0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      //Request Button
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).accentColor,
                          child: Text(
                            'Request List',
                            textScaleFactor: 1.5,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return RequestList(text: id);
                              }));
                            });
                          },
                        ),
                      ),

                      //Confirm Button
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Confirmed List',
                            textScaleFactor: 1.5,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ConfirmedList(text: id);
                              }));
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                //Capacity and Availability
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      //Capacity
                      Expanded(
                        child: Text(
                          'Capacity : ' + headCount,
                          textScaleFactor: 1.5,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),

                      //Availability
                      Expanded(
                        child: Text(
                          'Availabile : ' + available,
                          textScaleFactor: 1.5,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                    ],
                  ),
                ),

                //Name Field
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: nameController..text = name,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter the Name';
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
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),

                //Date Field
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      //Date Field
                      Expanded(
                        child: TextFormField(
                          enabled: false,
                          controller: dateController..text = date,
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
                            debugPrint('Something changed in Text Field');
                          },
                          decoration: InputDecoration(
                              labelText: 'Date',
                              labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
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
                              'Take a date',
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
                              ).then((inputDate) => {
                                    setState(() {
                                      if (inputDate != null) {
                                        _dateTime = inputDate;
                                        date = _dateTime
                                            .toString()
                                            .substring(0, 10);
                                      }
                                    }),
                                  });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Venue Field
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: venueController..text = venue,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter the venue';
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
                        labelText: 'Venue',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),

                //Description Field
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    maxLines: null,
                    controller: descriptionController..text = description,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter the description';
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
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),

                //Edit Button
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).accentColor,
                          child: Text(
                            'Edit',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              showSnackBar(context);
                              debugPrint('Add button clicked');
                            }
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
