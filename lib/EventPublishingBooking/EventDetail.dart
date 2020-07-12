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
  var requestForm = false;
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
    var _mediaQueryData = MediaQuery.of(context);
    var screenWidth = _mediaQueryData.size.width;
    var screenHeight = _mediaQueryData.size.height;
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
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
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                //Venue Text
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08, vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Theme.of(context).accentColor,
                          child: Icon(
                            Icons.location_on,
                            color: Theme.of(context).primaryColor,
                          )),
                      title: Text(
                        venue,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),

                //date
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.18, vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Theme.of(context).accentColor,
                          child: Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).primaryColor,
                          )),
                      title: Text(
                        date,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),

                //Availability
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.28, vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Theme.of(context).accentColor,
                          child: Icon(
                            Icons.people,
                            color: Theme.of(context).primaryColor,
                          )),
                      title: Text(
                        available,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),

                //Description
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListTile(
                      subtitle: Text(
                        description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  height: 30,
                ),

                //join
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: ListTile(
                      title: Text(
                        "Join with us by filling this",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                ),

                //Name Field
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.18, vertical: 8.0),
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
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 0),
                          // add padding to adjust icon
                          child: Icon(
                            Icons.perm_identity,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        )),
                  ),
                ),

                //Email Field
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08, vertical: 8.0),
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
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
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(top: 0),
                            // add padding to adjust icon
                            child: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          labelStyle: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0),
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          )),
                    ),
                  ),
                ),

                //Contact Number Field
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.18, vertical: 8.0),
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
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
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(top: 0),
                            // add padding to adjust icon
                            child: Icon(
                              Icons.contact_phone,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          labelStyle: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0),
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          )),
                    ),
                  ),
                ),

                //Heads Field
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.27, vertical: 8.0),
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.0, bottom: 15.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      controller: headsController,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter the Heads';
                        }
                        int valueInt = int.parse(value);
                        int availableInt = int.parse(available);
                        if (availableInt < valueInt) {
                          return 'Not enough seats';
                        } else if (1 > valueInt) {
                          return 'Enter a real Value';
                        }
                        return null;
                      },
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint('Something changed in Text Field');
                      },
                      decoration: InputDecoration(
                          labelText: 'Heads',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(top: 0),
                            // add padding to adjust icon
                            child: Icon(
                              Icons.people,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          labelStyle: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0),
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          )),
                    ),
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
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).accentColor,
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
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).accentColor,
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
