import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';

class AdminNotification extends StatefulWidget {
  @override
  AdminNotificationState createState() => AdminNotificationState();
}

class AdminNotificationState extends State<AdminNotification> {
  List data;

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(getUrl() + "/findAllNotifications"),
        headers: {"Accept": "application/json"});
    this.setState(() {
      data = jsonDecode(response.body).reversed.toList();
    });

    return "success!";
  }

  void delete(String id) async {
    final http.Response response = await http.delete(
      getUrl() + '/deleteNotification/' + id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    setState(() {
      initState();
    });
  }

  void showSnackBar(BuildContext context, String id) {
    var snackBar = SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      content: Text(
        'Notification will be deleted from the user view too?',
        style: TextStyle(color: Colors.black54),
      ),
      action: SnackBarAction(
          textColor: Theme.of(context).primaryColor,
          label: "I understand",
          onPressed: () {
            delete(id);
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Activity Report",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
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
            title: Text(data[position]["nameType"],
                style: TextStyle(color: Theme.of(context).primaryColor)),
            subtitle: (data[position]["authorType"] == "3")
                ?
                //Admin----------------------------------------------
                (data[position]["eventDate"] == null)
                    ?
                    //Course
                    Text(
                        data[position]["authorName"] +
                            " who has access as an admin " +
                            data[position]["nameType"] +
                            " '" +
                            data[position]["name"] +
                            "' from " +
                            data[position]["authorMail"] +
                            " on " +
                            data[position]["date"].substring(0, 10) +
                            " at " +
                            data[position]["date"].substring(11, 20),
                        style: TextStyle(color: Colors.black54))
                    :
                    //Event
                    Text(
                        data[position]["authorName"] +
                            " who has access as an admin " +
                            data[position]["nameType"] +
                            " '" +
                            data[position]["name"] +
                            "' (event date : " +
                            data[position]["eventDate"] +
                            ") from " +
                            data[position]["authorMail"] +
                            " on " +
                            data[position]["date"].substring(0, 10) +
                            " at " +
                            data[position]["date"].substring(11, 20),
                        style: TextStyle(color: Colors.black54))
                :
                //Crew Member----------------------------------------
                (data[position]["eventDate"] == null)
                    ?
                    //Course
                    Text(
                        data[position]["authorName"] +
                            " who has access as a crew member " +
                            data[position]["nameType"] +
                            " '" +
                            data[position]["name"] +
                            "' (event date : " +
                            data[position]["eventDate"] +
                            ") from " +
                            data[position]["authorMail"] +
                            " on " +
                            data[position]["date"].substring(0, 10) +
                            " at " +
                            data[position]["date"].substring(11, 20),
                        style: TextStyle(color: Colors.black54))
                    :
                    //Event
                    Text(
                        data[position]["authorName"] +
                            " who has access as a crew member " +
                            data[position]["nameType"] +
                            " '" +
                            data[position]["name"] +
                            "' (event date : " +
                            data[position]["eventDate"] +
                            ") from " +
                            data[position]["authorMail"] +
                            " on " +
                            data[position]["date"].substring(0, 10) +
                            " at " +
                            data[position]["date"].substring(11, 20),
                        style: TextStyle(color: Colors.black54)),
            trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                tooltip: 'Delete this activity',
                onPressed: () {
                  showSnackBar(context, data[position]["id"]);
                }),
          ),
        );
      },
    );
  }
}
