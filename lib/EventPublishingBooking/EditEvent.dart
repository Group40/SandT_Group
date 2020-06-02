import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './EventPublishing.dart';
var url = "http://10.0.2.2:8080/updateEvent";

class EditEvent extends StatefulWidget {
  final String text;
  EditEvent({Key key, @required this.text}) : super(key: key);

  @override
  EditEventState createState() => EditEventState(text);
}

class EditEventState extends State<EditEvent> {

  EditEventState(String text);

  var _formKey = GlobalKey<FormState>();
  var event;
  String name = '';
  String id = '';
  String date = '';
  String venue = '';
  String description = '';
  String headCount = '';
  String available = '';

  Future<String> getData() async{
    http.Response response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8080/findAllEvents/"+widget.text),
        headers: {
          "Accept": "application/json"
        }
    );

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
            update();
          }
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  //Call get data
  @override
  void initState(){
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
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
                    //First Element
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
                        style: textStyle,
                        onChanged: (value) {
                          debugPrint('Something changed in Text Field');
                        },
                        decoration: InputDecoration(
                            labelText: 'Name',
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
                        controller: dateController..text = date,
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

                    //Third Element
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
                        controller: descriptionController..text = description,
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

                    //Fifth Element
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 5.0,
                          ),
                          Expanded(
                            child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
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