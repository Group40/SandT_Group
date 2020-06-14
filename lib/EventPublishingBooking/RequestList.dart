import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
var url = "http://10.0.2.2:8080/updateEvent";

class RequestList extends StatefulWidget {
  final String text;
  RequestList({Key key, @required this.text}) : super(key: key);

  @override
  RequestListState createState() =>RequestListState(text);
}

class RequestListState extends State<RequestList> {

  RequestListState(String text);

  List data;
  Future<String> getData() async{
    http.Response response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8080/getEventRequestsByEventId/"+widget.text),
        headers: {
          "Accept": "application/json"
        }
    );
    this.setState(() {
      data = jsonDecode(response.body);
    });
    return "success!";
  }

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

  void confirmRequest() async {
    debugPrint('funtion called');
    var body = jsonEncode({
      'id': "name",
    });
    return await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      print(res.toString());
    });
  }

  void showSnackBarConfirm(BuildContext context, String id){
    var snackBar = SnackBar(
      backgroundColor: Colors.black54,
      content:  Text (
        'Permently delete the event?',
        style: TextStyle(fontSize: 20, color: Colors.white70),
      ),
      action: SnackBarAction(
          textColor: Colors.cyan,
          label: "YES",
          onPressed: () {
            //delete(id);
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
        title: Text(widget.text),
      ),
      body: getListView(),
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
          child : Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.cyan,
                  child: Icon(Icons.people),
                ),
                title: Text("Name : "+data[position]["name"],style: TextStyle(color: Colors.black54)),
                subtitle: Text("Contact Number : "+data[position]["number"]+"\nEmail : "+data[position]["email"]+"\nHeads : "+data[position]["heads"],style: TextStyle(color: Colors.cyan[900])),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('CONFIRM',style: TextStyle(color: Colors.blue)),
                    onPressed: () {
                      showSnackBarConfirm(context, data[position]["id"]);
                    },
                  ),
                  FlatButton(
                    child: const Text('REJECT',style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      showSnackBarReject(context, data[position]["id"]);
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