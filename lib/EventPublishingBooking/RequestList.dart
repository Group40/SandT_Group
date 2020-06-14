import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './EditEvent.dart';
var url = "http://10.0.2.2:8080/addConfirmedEventRequest";

class RequestList extends StatefulWidget {
  final String text;
  RequestList({Key key, @required this.text}) : super(key: key);

  @override
  RequestListState createState() =>RequestListState(text);
}

class RequestListState extends State<RequestList> {

  RequestListState(String text);

  List requestData;
  var eventData;
  String availableString ='';

  Future<String> getData() async{
    http.Response response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8080/getEventRequestsByEventId/"+widget.text),
        headers: {
          "Accept": "application/json"
        }
    );
    this.setState(() {
      requestData = jsonDecode(response.body);
    });
    http.Response response2 = await http.get(
        Uri.encodeFull("http://10.0.2.2:8080/findAllEvents/" + widget.text),
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
      'http://10.0.2.2:8080/deleteEventRequest/'+id,
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
    return await http.post("http://10.0.2.2:8080/updateEvent", body: body, headers: {
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
      'eventId':requestData[position]["eventId"],
      'eventName':  requestData[position]["eventName"],
      'eventDate':  requestData[position]["eventDate"],
      'name': requestData[position]["name"],
      'number':  requestData[position]["number"],
      'email': requestData[position]["email"],
      'heads':  requestData[position]["heads"],
    });
    print(body);
    return await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      print(res.toString());
    });
  }

  void showSnackBarConfirm(BuildContext context, String id, int position){
    var snackBar = SnackBar(
      backgroundColor: Colors.black54,
      content:  Text (
        'Are you sure?',
        style: TextStyle(fontSize: 20, color: Colors.white70),
      ),
      action: SnackBarAction(
          textColor: Colors.cyan,
          label: "YES",
          onPressed: () {
            confirmRequest(position);
            deleteRequest(id);
            reduceAvailable(position);
          }
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void showSnackBarReject(BuildContext context, String id){
    var snackBar = SnackBar(
      backgroundColor: Colors.black54,
      content:  Text (
        'WARNING!\nRequests are not recoverable after rejection!',
        style: TextStyle(fontSize: 20, color: Colors.white70),
      ),
      action: SnackBarAction(
          textColor: Colors.cyan,
          label: "OKAY",
          onPressed: () {
            deleteRequest(id);
          }
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  //Call get data
  @override
  void initState(){
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Request List"),
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
      body: getListView(),
    );
    throw UnimplementedError();
  }

  ListView getListView(){
    //TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: requestData == null ? 0 : requestData.length,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.cyan[100],
          elevation: 2.0,
          child : Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.cyan,
                  child: Icon(Icons.people),
                ),
                title: Text("Name : "+requestData[position]["name"],style: TextStyle(color: Colors.black54)),
                subtitle: Text("Contact Number : "+requestData[position]["number"]+"\nEmail : "+requestData[position]["email"]+"\nHeads : "+requestData[position]["heads"],style: TextStyle(color: Colors.cyan[900])),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('CONFIRM',style: TextStyle(color: Colors.blue)),
                    onPressed: () {
                      showSnackBarConfirm(context, requestData[position]["id"], position);
                    },
                  ),
                  FlatButton(
                    child: const Text('REJECT',style: TextStyle(color: Colors.red)),
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