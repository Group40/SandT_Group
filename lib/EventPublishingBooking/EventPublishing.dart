import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import './EditEvent.dart';
import './AddEvent.dart';

class EventPublishing extends StatefulWidget{
  @override
  EventPublishingState createState() => EventPublishingState();
}

class EventPublishingState extends State<EventPublishing> {
  List data;
  Future<String> getData() async{
    http.Response response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8080/findAllEvents"),
        headers: {
          "Accept": "application/json"
        }
    );
    this.setState(() {
      data = jsonDecode(response.body);
    });
    print(data[1]["name"]);
    return "success!";
  }

  //Call get data
  @override
  void initState(){
    this.getData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Published Events'),
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint("Fab click");
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return AddEvent();
          }));
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
    throw UnimplementedError();
  }

  ListView getListView(){
    //TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.cyan[100],
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.cyan,
              child: Icon(Icons.event_available),
            ),
            title: Text(data[position]["name"],style: TextStyle(color: Colors.black54)),
            subtitle: Text(data[position]["date"],style: TextStyle(color: Colors.cyan[900])),
            trailing: Icon(Icons.delete, color: Colors.red,),
            onTap: (){
              debugPrint("Event clicked");
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return EditEvent(text: data[position]["id"]);
              }));
            },
          ),
        );
      },
    );
  }
}