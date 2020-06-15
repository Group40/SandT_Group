import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './EventPublishing.dart';
import 'package:flutter/services.dart';

var url = "http://10.0.2.2:8080/addEvent";

class AddEvent extends StatefulWidget {
  @override
  AddEventState createState() => AddEventState();
}

class AddEventState extends State<AddEvent> {
  DateTime _dateTime = DateTime.now();
  var _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController headCountController = TextEditingController();

  AddEventState();

  void send() async {
    debugPrint('funtion called');
    var body = jsonEncode({
      'name': nameController.text,
      'date': dateController.text,
      'venue': venueController.text,
      'description': descriptionController.text,
      'headCount': headCountController.text,
      'available': headCountController.text
    });
    return await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      print(res.toString());
    });
  }

  void showSnackBar(BuildContext context){
    var snackBar = SnackBar(
      backgroundColor: Colors.black54,
      content:  Text (
        'Are you sure?',
        style: TextStyle(fontSize: 20, color: Colors.white70),
      ),
      action: SnackBarAction(
        textColor: Colors.cyan,
          label: "YES",
          onPressed: () {
            send();
            _reset();
          }
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Event'),
        //Optional back button
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context,true);
              Navigator.pop(context,true);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EventPublishing();
              }));
            }),
        //Optional back button ends
      ),
      body: Builder(
        builder: (context) =>
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                child: ListView(
                  children: <Widget>[

                    //Name Field
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextFormField(
                        controller: nameController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter a Title';
                          }
                          return null;
                        },
                        style: textStyle,
                        onChanged: (value) {
                          debugPrint('Something changed in Text Field');
                        },
                        decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: textStyle,
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

                              controller: dateController..text = _dateTime.toString().substring(0,10),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please enter the date';
                                }
                                return null;
                              },
                              style: textStyle,
                              onChanged: (value) {
                                debugPrint('Something changed in Text Field');
                              },
                              decoration: InputDecoration(
                                  labelText: 'Date',
                                  labelStyle: textStyle,
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
                                color: Colors.black26,
                                child: Text('Take a date'),
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2001),
                                    lastDate: DateTime(2222),
                                  ).then((date) => {
                                    setState((){
                                      if(date == null){
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

                    //Venue Field
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextFormField(
                        controller: venueController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter the venue';
                          }
                          return null;
                        },
                        style: textStyle,
                        onChanged: (value) {
                          debugPrint('Something changed in Text Field');
                        },
                        decoration: InputDecoration(
                            labelText: 'Venue',
                            labelStyle: textStyle,
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
                        controller: descriptionController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter the description';
                          }
                          return null;
                        },
                        style: textStyle,
                        onChanged: (value) {
                          debugPrint('Something changed in Text Field');
                        },
                        decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      ),
                    ),

                    //Heads Field
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        controller: headCountController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter the head count';
                          }
                          return null;
                        },
                        style: textStyle,
                        onChanged: (value) {
                          debugPrint('Something changed in Text Field');
                        },
                        decoration: InputDecoration(
                            labelText: 'Head Count',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      ),
                    ),

                    //Buttons
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        children: <Widget>[

                          //Reset Button
                          Expanded(
                            child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text(
                                'Reset',
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                setState(() {
                                  _reset();
                                });
                              },
                            ),
                          ),
                          Container(
                            width: 5.0,
                          ),

                          //Add Button
                          Expanded(
                            child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text(
                                'Add',
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_formKey.currentState.validate()) {
                                    showSnackBar(context);
                                    debugPrint('Add button clicked');
                                  }
                                });
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

  void _reset() {
    nameController.text = '';
    dateController.text = '';
    venueController.text = '';
    descriptionController.text = '';
    headCountController.text = '';
  }
}
