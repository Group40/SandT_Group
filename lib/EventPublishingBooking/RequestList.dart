import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './EditEvent.dart';

var url = "http://192.168.1.26:8080/addConfirmedEventRequest";

class RequestList extends StatefulWidget {
  final String text;
  RequestList({Key key, @required this.text}) : super(key: key);

  @override
  RequestListState createState() => RequestListState(text);
}

class RequestListState extends State<RequestList> {
  RequestListState(String text);

  List requestData;
  var eventData;
  String availableString = '';

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            "http://192.168.1.26:8080/getEventRequestsByEventId/" + widget.text),
        headers: {"Accept": "application/json"});
    this.setState(() {
      requestData = jsonDecode(response.body);
    });
    http.Response response2 = await http.get(
        Uri.encodeFull("http://192.168.1.26:8080/findAllEvents/" + widget.text),
        headers: {"Accept": "application/json"});

    this.setState(() {
      eventData = jsonDecode(response2.body);
      availableString = eventData['available'];
    });
    return "success!";
  }

  //Delete From Request Collection
  void deleteRequest(String id) async {
    final http.Response response = await http.delete(
      'http://192.168.1.26:8080/deleteEventRequest/' + id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    setState(() {
      initState();
    });
  }

  void reduceAvailable(int position) async {
    int heads = int.parse(requestData[position]["heads"]);
    int available = int.parse(availableString);
    available = available - heads;
    debugPrint('funtion called');

    var body = jsonEncode({
      'id': eventData["id"],
      'name': eventData["name"],
      'date': eventData["date"],
      'venue': eventData["venue"],
      'description': eventData["description"],
      'headCount': eventData["headCount"],
      'available': available
    });
    return await http.post("http://192.168.1.26:8080/updateEvent",
        body: body,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        }).then((dynamic res) {
      print(res.toString());
    });
  }

  //Add to Confirmed Request Collection
  void confirmRequest(int position) async {
    debugPrint('funtion called');
    var body = jsonEncode({
      'eventId': requestData[position]["eventId"],
      'eventName': requestData[position]["eventName"],
      'eventDate': requestData[position]["eventDate"],
      'name': requestData[position]["name"],
      'number': requestData[position]["number"],
      'email': requestData[position]["email"],
      'heads': requestData[position]["heads"],
    });
    print(body);
    return await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      print(res.toString());
    });
  }

  //Out of capacity Error Message
  void errorPopUp() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.cyan,
          title: new Text("There are not enough seats"),
          content: new Text("Atomatically rejecting the request by the system"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OKAY"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Confirm SnackBar
  void showSnackBarConfirm(BuildContext context, String id, int position) {
    int heads = int.parse(requestData[position]["heads"]);
    int available = int.parse(availableString);
    available = available - heads;
    if (available < 0) {
      //Out of Capacity : Error
      var snackBar = SnackBar(
        backgroundColor: Theme.of(context).accentColor,
        content: Text(
          'Are you sure?',
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
        action: SnackBarAction(
            textColor: Theme.of(context).primaryColor,
            label: "YES",
            onPressed: () {
              //Error
              deleteRequest(id);
              //Pop up error message
              errorPopUp();
            }),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else if (available == 0) {
      //OKAY : All are booking from now on
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
              //finish
              confirmRequest(position);
              deleteRequest(id);
              reduceAvailable(position);
              //Make event Unavailable here
            }),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      //Okay : Normal confirmation Scenario
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
              //Normal
              confirmRequest(position);
              deleteRequest(id);
              reduceAvailable(position);
            }),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  //Reject SnackBar
  void showSnackBarReject(BuildContext context, String id) {
    var snackBar = SnackBar(
      backgroundColor: Colors.black54,
      content: Text(
        'WARNING!\nRequests are not recoverable after rejection!',
        style: TextStyle(fontSize: 20, color: Colors.white70),
      ),
      action: SnackBarAction(
          textColor: Colors.cyan,
          label: "OKAY",
          onPressed: () {
            deleteRequest(id);
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
      //backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Request List",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        //Optional back button
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
              Navigator.pop(context, true);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EditEvent(text: widget.text);
              }));
            }),
        //Optional back button ends
      ),
      body: (requestData == null)
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
      itemCount: requestData == null ? 0 : requestData.length,
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
                title: Text("Name : " + requestData[position]["name"],
                    style: TextStyle(color: Colors.black54)),
                subtitle: Text(
                    "Contact Number : " +
                        requestData[position]["number"] +
                        "\nEmail : " +
                        requestData[position]["email"] +
                        "\nHeads : " +
                        requestData[position]["heads"],
                    style: TextStyle(color: Colors.black54)),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('CONFIRM',
                        style: TextStyle(color: Colors.blue)),
                    onPressed: () {
                      showSnackBarConfirm(
                          context, requestData[position]["id"], position);
                    },
                  ),
                  FlatButton(
                    child: const Text('REJECT',
                        style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      showSnackBarReject(context, requestData[position]["id"]);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
