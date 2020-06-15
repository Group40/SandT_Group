import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
var url = "http://10.0.2.2:8080/addEventRequest";

class EventDetail extends StatefulWidget {
  final String text;

  EventDetail({Key key, @required this.text}) : super(key: key);

  @override
  EventDetailState createState() => EventDetailState(text);
}

class EventDetailState extends State<EventDetail> {
  EventDetailState(String text);

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
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController headsController = TextEditingController();

  void request() async {
    debugPrint('funtion called');
    var body = jsonEncode({
      'eventId': id,
      'eventName': name,
      'eventDate': date,
      'name': nameController.text,
      'number': numberController.text,
      'email': emailController.text,
      'heads': headsController.text,
    });
    print(body);
    return await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      print(res.toString());
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
            request();
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
        title: Text(name),
      ),
      body: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[

                //Name Text
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 2.0),
                  child: Center(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                ),

                //Venue Text
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 2.0),
                  child: Center(
                    child: Text(
                      "Venue : "+venue,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                ),

                //Date Text
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Center(
                    child: Text(
                      "Date : "+date,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                //Description Text
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 2.0),
                  child: Center(
                    child: Text(
                      "Event Description >> "+
                      description,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                ),

                //Availability Text
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Center(
                    child: Text(
                      "Available Seats : "+available,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                //Name Field
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: nameController,
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

                //Email Field
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: emailController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter the Email';
                      }
                      return null;
                    },
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Text Field');
                    },
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),

                //Contact Number Field
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    controller: numberController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter the Contact Number';
                      }
                      return null;
                    },
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Text Field');
                    },
                    decoration: InputDecoration(
                        labelText: 'Contact Number',
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
                    controller: headsController,
                    validator: (String value) {
                      int valueInt = int.parse(value);
                      int availableInt = int.parse(available);
                      if (value.isEmpty) {
                        return 'Please enter the Heads';
                      }
                      else if (availableInt < valueInt) {
                        return 'Should be equal or less than current availability';
                      }
                      return null;
                    },
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Text Field');
                    },
                    decoration: InputDecoration(
                        labelText: 'Heads',
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
                      Container(
                        width: 5.0,
                      ),

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

                      //Request Button
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Request',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              showSnackBar(context);
                              debugPrint('Request button clicked');
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

  void _reset() {
    nameController.text = '';
    numberController.text = '';
    emailController.text = '';
    headsController.text = '';
  }
}

