import 'package:flutter/material.dart';
import 'package:sandtgroup/Photography/MyUploads.dart';
import 'package:sandtgroup/Photography/PicGallery.dart';
import 'package:sandtgroup/Photography/UploadPics.dart';

int _currentIndex = 0;

class MainPage extends StatefulWidget {
  // final int page;
  // MainPage(int i, {Key key, this.page}) : super(key: key);
  // @override
  // State<StatefulWidget> createState() => new MainPageState();
  MainPage(this.page);
  final int page;

  @override
  MainPageState createState() => MainPageState();
}

@override
void initState() {}

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      iconSize: 25,
      selectedFontSize: 15,
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
          }
        }
      },
    );
  }
}
