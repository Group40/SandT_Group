import 'package:flutter/material.dart';
import './EditEvent.dart';
import './AddEvent.dart';

class EventPublishing extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return EventPublishingState();
    throw UnimplementedError();
  }
}

class EventPublishingState extends State<EventPublishing> {
  int count = 10;
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
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.cyan[100],
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.cyan,
              child: Icon(Icons.event_available),
            ),
            title: Text('Dummy title',style: TextStyle(color: Colors.black54)),
            subtitle: Text('Dummy Date',style: TextStyle(color: Colors.cyan[900])),
            trailing: Icon(Icons.delete, color: Colors.red,),
            onTap: (){
              debugPrint("Event clicked");
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return EditEvent();
              }));
            },
          ),
        );
      },
    );
  }
}