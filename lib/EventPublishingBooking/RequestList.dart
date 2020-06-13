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

  void delete(String id) async {
    final http.Response response = await http.delete(
      'http://10.0.2.2:8080/deleteEvent/'+id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    setState(() {
      initState();
    });
  }

  void confirm() async {
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

  void showSnackBar(BuildContext context, String id){
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
            delete(id);
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
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.cyan,
              child: Icon(Icons.event_available),
            ),
            title: Text("Name : "+data[position]["name"],style: TextStyle(color: Colors.black54)),
            subtitle: Text("Contact Number : "+data[position]["number"]+"\nEmail : "+data[position]["email"]+"\nHeads : "+data[position]["heads"],style: TextStyle(color: Colors.cyan[900])),
            trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red,),
                tooltip: 'Delete this event',
                onPressed: () {
                  showSnackBar(context, data[position]["id"]);
                }
            ),
          ),
        );
      },
    );
  }
}