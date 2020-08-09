import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import './CalendarAdmin.dart';
import './EditEvent.dart';
import './AddEvent.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';

var notificationUrl = "http://10.0.2.2:8080/addNotification";

class EventPublishing extends StatefulWidget {
  @override
  EventPublishingState createState() => EventPublishingState();
}

class EventPublishingState extends State<EventPublishing> {
  List data;

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8080/findAllEvents"),
        headers: {"Accept": "application/json"});
    this.setState(() {
      data = jsonDecode(response.body);
    });
    return "success!";
  }

  void delete(String id, String name, String date) async {
    final http.Response response = await http.delete(
      'http://10.0.2.2:8080/deleteEvent/' + id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final http.Response response2 = await http.delete(
      'http://10.0.2.2:8080/deleteEventRequestByEventId/' + id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final http.Response response3 = await http.delete(
      'http://10.0.2.2:8080/deleteConfirmedEventRequestByEventId/' + id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var notificationBody = jsonEncode({
      'authorName': getUsername(),
      'authorType': getrole(),
      'authorMail': getEmail(),
      'name': name,
      'nameType': "delete the event",
      'date': DateTime.now().toString(),
      'eventDate': date,
    });
    return http.post(notificationUrl, body: notificationBody, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      print(res.toString());
      setState(() {
        initState();
      });
    });
  }

  void showSnackBar(BuildContext context, String id, String name, String date) {
    var snackBar = SnackBar(
      backgroundColor: Colors.black54,
      content: Text(
        'Permently delete the event?',
        style: TextStyle(fontSize: 20, color: Colors.white70),
      ),
      action: SnackBarAction(
          textColor: Colors.cyan,
          label: "YES",
          onPressed: () {
            delete(id, name, date);
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
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Published Events'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CalendarAdmin();
              }));
            },
          ),
        ],
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          debugPrint("Fab click");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddEvent();
          }));
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
    throw UnimplementedError();
  }

  ListView getListView() {
    //TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int position) {
        int availableInt = int.parse(data[position]["available"]);
        return Card(
          color: Colors.cyan[100],
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: availableInt == 0 ? Colors.red : Colors.cyan,
              child: availableInt == 0
                  ? Icon(
                      Icons.event_busy,
                      color: Colors.black,
                    )
                  : Icon(
                      Icons.event_available,
                      color: Colors.black,
                    ),
            ),
            title: Text(data[position]["name"],
                style: TextStyle(color: Colors.black54)),
            subtitle: Text(data[position]["date"],
                style: TextStyle(color: Colors.black54)),
            trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                tooltip: 'Delete this event',
                onPressed: () {
                  showSnackBar(context, data[position]["id"],
                      data[position]["name"], data[position]["date"]);
                }),
            onTap: () {
              debugPrint("Event clicked");
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EditEvent(text: data[position]["id"]);
              }));
            },
          ),
        );
      },
    );
  }
}
