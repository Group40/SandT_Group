import 'package:flutter/material.dart';
import 'package:sandtgroup/Photography/AdminFun/ReviewPic.dart';
import 'package:sandtgroup/Photography/MyUploads.dart';
import 'package:sandtgroup/Photography/PicGallery.dart';
import 'package:sandtgroup/Photography/UploadPics.dart';

int _currentIndex = 0;

class AdMainPage extends StatefulWidget {
  // final int page;
  // MainPage(int i, {Key key, this.page}) : super(key: key);
  // @override
  // State<StatefulWidget> createState() => new MainPageState();
  AdMainPage(this.page);
  final int page;

  @override
  AdMainPageState createState() => AdMainPageState();
}

@override
void initState() {}

class AdMainPageState extends State<AdMainPage> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      iconSize: 25,
      selectedFontSize: 15,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            title: Text("Gallery"),
            backgroundColor: Colors.blueAccent),
        BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            title: Text("My Uploads"),
            backgroundColor: Colors.blueAccent),
        BottomNavigationBarItem(
            icon: Icon(Icons.cloud_upload),
            title: Text("Upload Photo"),
            backgroundColor: Colors.blueAccent),
        BottomNavigationBarItem(
            icon: Icon(Icons.mark_chat_read),
            title: Text("Review Photo"),
            backgroundColor: Colors.blueAccent),
      ],
      onTap: (index) {
        if (_currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex == 0) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return PicGallery();
            }));
          } else if (_currentIndex == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return MyUploads();
            }));
          } else if (_currentIndex == 2) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return UploadPics();
            }));
          } else if (_currentIndex == 3) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return ReviewPic();
            }));
          }
        }
      },
    );
  }
}

void setcurrentindex() {
  _currentIndex = 0;
}
