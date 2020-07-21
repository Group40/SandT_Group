import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

class ViewPhoto extends StatefulWidget {
  @override
  ViewPhotoState createState() => ViewPhotoState();
}

class ViewPhotoState extends State<ViewPhoto> {
  File _image;

  Future getimage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Astro Photography'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
                getimage();
              },
            ),
          ],
        ),
        body: Container()
        //
        );
    throw UnimplementedError();
  }
}
