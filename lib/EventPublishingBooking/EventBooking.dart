import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './EventDetail.dart';
import './Calendar.dart';

class EventBooking extends StatefulWidget {
  @override
  EventBookingState createState() => EventBookingState();
}

class EventBookingState extends State<EventBooking> {
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
        title: Text('Upcoming Events'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Calendar();
              }));
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20.0),
        child : getListView(),
      )
//
    );
    throw UnimplementedError();
  }

  ListView getListView() {
    //TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int position) {
        int availableInt = int.parse(data[position]["available"]);
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ),
            color: Colors.cyan[200],
            elevation: 5.0,
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
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black)),
              subtitle: Text(data[position]["date"],
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.cyan[900])),
              onTap: () {
                debugPrint("Event clicked");
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EventDetail(text: data[position]["id"]);
                }));
              },
            ),
          ),
        );
      }
    );
  }
}
