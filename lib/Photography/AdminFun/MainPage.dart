import 'package:flutter/material.dart';
import 'package:sandtgroup/FirstScreen/AppDrawer.dart';
import 'package:sandtgroup/Photography/MyUploads.dart';
import 'package:sandtgroup/Photography/PicGallery.dart';
import 'package:sandtgroup/Photography/UploadPics.dart';

import 'ReviewPic.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return PicPage();
  }
}

class PicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Astro Photography Admin '),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 10.0, top: 40.0),
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Admin Panel",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              UploadButton(),
              ViewMyPicButton(),
              GalleryButton(),
              ReviewButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      width: 250.0,
      height: 50.0,
      child: RaisedButton(
        color: Colors.blueAccent,
        child: Text(
          "Review Pic",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        elevation: 6.0,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ReviewPic();
          }));
        },
      ),
    );
  }
}

class UploadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      width: 250.0,
      height: 50.0,
      child: RaisedButton(
        color: Colors.blueAccent,
        child: Text(
          "Upload Pic",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        elevation: 6.0,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UploadPics();
          }));
        },
      ),
    );
  }
}

class ViewMyPicButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      width: 250.0,
      height: 50.0,
      child: RaisedButton(
        color: Colors.blueAccent,
        child: Text(
          "View My Pic",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        elevation: 6.0,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MyUploads();
          }));
        },
      ),
    );
  }
}

class GalleryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      width: 250.0,
      height: 50.0,
      child: RaisedButton(
        color: Colors.blueAccent,
        child: Text(
          "Gallery",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        elevation: 6.0,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PicGallery();
          }));
        },
      ),
    );
  }
}
