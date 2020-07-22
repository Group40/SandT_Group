import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewPhoto extends StatefulWidget {
  @override
  ViewPhotoState createState() => ViewPhotoState();
}

class ViewPhotoState extends State<ViewPhoto> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descrptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Astro Photography'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.undo,
              ),
              onPressed: () {
                setState(() {});
              },
            ),
          ],
        ),
        body: ListView());
  }
}
