import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './EventDetail.dart';
import './Calendar.dart';

class EventByDate extends StatefulWidget {
  final String date;
  EventByDate({Key key, @required this.date}) : super(key: key);
  @override
  EventByDateState createState() => EventByDateState(date);
}

class EventByDateState extends State<EventByDate> {
  EventByDateState(String date);
  List data;
  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8080/findEventsByDate/"+widget.date),
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
      body: getListView(),
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
                  : Icon(Icons.event_available),
            ),
            title: Text(data[position]["name"],
                style: TextStyle(color: Colors.black54)),
            subtitle: Text(data[position]["date"],
                style: TextStyle(color: Colors.cyan[900])),
            onTap: () {
              debugPrint("Event clicked");
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EventDetail(text: data[position]["id"]);
              }));
            },
          ),
        );
      },
    );
  }
}
