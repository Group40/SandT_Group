import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

var url = "http://10.0.2.2:8080/addEvent";

class AddEvent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddEventState();
    throw UnimplementedError();
  }
}

class AddEventState extends State<AddEvent> {
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
              moveToLastScreen();
            }),
        //Optional back button ends
      ),
      body: Form(
        child: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              //First Element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  controller: nameController,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'Please enter term';
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

              //Second Element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  controller: dateController,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'Please enter term';
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

              //Third Element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  controller: venueController,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'Please enter term';
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

              //Fourth Element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  controller: descriptionController,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'Please enter term';
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

              //Fifth Element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  controller: headCountController,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'Please enter term';
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

              //Sixth Element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
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
                            debugPrint('Add button clicked');
                            send();
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

  void moveToLastScreen() {
    Navigator.pop(context);
  }
}
