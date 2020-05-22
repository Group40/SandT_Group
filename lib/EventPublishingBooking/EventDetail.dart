import 'package:flutter/material.dart';

class EventDetail extends StatefulWidget {
  //EventDetail();
  @override
  State<StatefulWidget> createState() {
    return EventDetailState();
    throw UnimplementedError();
  }
}

class EventDetailState extends State<EventDetail> {
  static var _priorities = ['Available', 'Not Available'];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  EventDetailState();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text('Book a Event'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            //Second Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 2.0),
              child: Center(
                child: Text(
                  'Dummy Title',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.cyan,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Center(
                child: Text(
                  'Dummy Date',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 2.0),
              child: Center(
                child: Text(
                  'Dummy Description',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.cyan,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Center(
                child: Text(
                  'Dummy Availability',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            //Third Element
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in the Field');
                },
                decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in the Field');
                },
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in the Field');
                },
                decoration: InputDecoration(
                    labelText: 'Contact Number',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in the Field');
                },
                decoration: InputDecoration(
                    labelText: 'Heads',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),

            //Fourth Element
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Reset',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint('Reset button clicked');
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Request',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint('Request button clicked');
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }
}
