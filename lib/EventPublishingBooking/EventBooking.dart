import 'package:flutter/material.dart';
import './EventDetail.dart';

class EventBooking extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return EventBookingState();
    throw UnimplementedError();
  }
}

class EventBookingState extends State<EventBooking> {
  int count = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Upcoming Events'),
      ),
      body: getListView(),
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
            trailing: Icon(Icons.more_vert, color: Colors.grey,),
            onTap: (){
              debugPrint("Event clicked");
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return EventDetail();
              }));
            },
          ),
        );
      },
    );
  }
}