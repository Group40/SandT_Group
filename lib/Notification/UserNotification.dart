import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

class UserNotification extends StatefulWidget {
  @override
  UserNotificationState createState() => UserNotificationState();
}

class UserNotificationState extends State<UserNotification> {
  List data;

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://192.168.1.26:8080/findAllNotifications"),
        headers: {"Accept": "application/json"});
    this.setState(() {
      data = jsonDecode(response.body).reversed.toList();
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
          "Notification Log",
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
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.notifications,
                color: Theme.of(context).primaryColor,
              ),
            ),
            subtitle: (data[position]["authorType"] == "3")
                ?
                //Admin----------------------------------------------
                (data[position]["eventDate"] == null)
                    ?
                    //Course
                    Text(
                        data[position]["nameType"] +
                            " '" +
                            data[position]["name"] +
                            ") on " +
                            data[position]["date"].substring(0, 10) +
                            " at " +
                            data[position]["date"].substring(11, 20) +
                            " Visit courses for more information.",
                        style: TextStyle(color: Colors.black54))
                    :
                    //Event
                    Text(
                        data[position]["nameType"] +
                            " '" +
                            data[position]["name"] +
                            "' (event date : " +
                            data[position]["eventDate"] +
                            ") on " +
                            data[position]["date"].substring(0, 10) +
                            " at " +
                            data[position]["date"].substring(11, 20) +
                            " Visit upcoming events for more information.",
                        style: TextStyle(color: Colors.black54))
                :
                //Crew Member----------------------------------------
                (data[position]["eventDate"] == null)
                    ?
                    //Course
                    Text(
                        data[position]["nameType"] +
                            " '" +
                            data[position]["name"] +
                            "' (event date : " +
                            data[position]["eventDate"] +
                            ") on " +
                            data[position]["date"].substring(0, 10) +
                            " at " +
                            data[position]["date"].substring(11, 20) +
                            " Visit courses for more information.",
                        style: TextStyle(color: Colors.black54))
                    :
                    //Event
                    Text(
                        data[position]["nameType"] +
                            " '" +
                            data[position]["name"] +
                            "' (event date : " +
                            data[position]["eventDate"] +
                            ") on " +
                            data[position]["date"].substring(0, 10) +
                            " at " +
                            data[position]["date"].substring(11, 20) +
                            " Visit upcoming events for more information.",
                        style: TextStyle(color: Colors.black54)),
          ),
        );
      },
    );
  }
}
