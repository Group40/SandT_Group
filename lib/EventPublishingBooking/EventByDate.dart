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
        Uri.encodeFull("http://10.0.2.2:8080/findEventsByDate/" + widget.date),
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Upcoming Events',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.pop(context, true);
              }),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: Theme.of(context).primaryColor,
              ),
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
          child: getListView(),
        ));
    throw UnimplementedError();
  }

  ListView getListView() {
    //TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int position) {
        int availableInt = int.parse(data[position]["available"]);
        return Container(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ),
            color: Theme.of(context).accentColor,
            elevation: 1.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: availableInt == 0
                    ? Colors.red
                    : Theme.of(context).primaryColor,
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
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              subtitle: Text(data[position]["date"],
                  style: TextStyle(color: Colors.black54)),
              onTap: () {
                debugPrint("Event clicked");
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EventDetail(text: data[position]["id"]);
                }));
              },
            ),
          ),
        );
      },
    );
  }
}
