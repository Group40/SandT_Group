import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

var url = "http://192.168.1.26:8080/addConfirmedEventRequest";

class ConfirmedList extends StatefulWidget {
  final String text;
  ConfirmedList({Key key, @required this.text}) : super(key: key);

  @override
  ConfirmedListState createState() => ConfirmedListState(text);
}

class ConfirmedListState extends State<ConfirmedList> {
  ConfirmedListState(String text);

  List data;

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            "http://192.168.1.26:8080/getConfirmedEventRequestsByEventId/" +
                widget.text),
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
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Confirmed Request List",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: (data == null)
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : getListView(),
    );
    throw UnimplementedError();
  }

  ListView getListView() {
    //TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Theme.of(context).accentColor,
          elevation: 2.0,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                  child: Icon(Icons.people),
                ),
                title: Text("Name : " + data[position]["name"],
                    style: TextStyle(color: Colors.black54)),
                subtitle: Text(
                    "Contact Number : " +
                        data[position]["number"] +
                        "\nEmail : " +
                        data[position]["email"] +
                        "\nHeads : " +
                        data[position]["heads"],
                    style: TextStyle(color: Colors.black54)),
              ),
            ],
          ),
        );
      },
    );
  }
}
