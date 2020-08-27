import 'dart:convert';
import 'package:async/async.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

var url = getUrl()+"/photouploading/uploadpic";

class UserScreenManagement extends StatefulWidget {
  @override
  _UserScreenManagementState createState() => new _UserScreenManagementState();
}

class _UserScreenManagementState extends State<UserScreenManagement> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  List imglist = List();
  bool isLoading = true;
  bool networkImg = false;
  int _current = 0;
  bool addmore = true;
  File _image;
  bool _picvalidate = false;

  @override
  void initState() {
    super.initState();
    getPicGallery();
  }

  Future<String> getPicGallery() async {
    await Future.delayed(Duration(milliseconds: 3000));
    try {
      http.Response response = await http
          .get(Uri.encodeFull(getUrl() + "/viewGallery/"), headers: {
        "Accept": "application/json"
      }).timeout(const Duration(seconds: 40));

      if (response.statusCode == 200) {
        //imglist = ['assets/image/logo.jpg'];
        imglist = (json.decode(response.body) as List);
        setState(() {
          isLoading = false;
          networkImg = true;
        });
        if (imglist.length > 6) {
          setState(() {
            addmore = false;
          });
        }
      } else {
        imglist = ['assets/image/logo.jpg'];
      }
    } on TimeoutException catch (_) {
      imglist = ['assets/image/logo.jpg'];
    }
  }

  void _picsend() async {
    // ignore: deprecated_member_use
    var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
    var length = await _image.length();
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: _image.path.split('/').last
        //basename(_image.path),
        );
    request.fields['email'] = getEmail();
    request.files.add(multipartFile);
    //var response = await request.send()
    try {
      final response =
          await request.send().timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        setState(() {
        });
      } else {
      }
    } on TimeoutException catch (_) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[100],
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: Colors.blueAccent,
        title: new Text(
          "User Screen Managemente",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: !isLoading
          ? Container(
              child: Column(
                mainAxisAlignment: (MainAxisAlignment.start),
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 15.0),
                  CarouselSlider(
                      items: imglist.map((e) {
                        return Builder(builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.3)),
                              child: networkImg
                                  ? Image.network(
                                      e,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset('assets/image/logo.jpg'));
                        });
                      }).toList(),
                      options: CarouselOptions(
                        height: 200,
                        initialPage: 0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        reverse: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(microseconds: 500),
                        pauseAutoPlayOnTouch: true,
                        scrollDirection: Axis.horizontal,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      )),
                  SizedBox(height: 15.0),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Delete Upload Carousels",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  UploadedList(),
                ],
              ),
            )
          : LoadingScreen(),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          getimage();
        },
        //tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }

  Future getimage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      _picvalidate = true;
    });
  }

  UploadedList() {
    return Flexible(
      child: ListView(
          padding: EdgeInsets.all(10),
          children: imglist.map((data) {
            return Container(
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => data.page)),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: new Image.asset(
                        'assets/icons/store.png',
                        fit: BoxFit.fill,
                      ),
                      dense: false,
                    )),
              ),
            );
          }).toList()),
    );
  }

  LoadingScreen() {
    return Container(
      padding: EdgeInsets.all(25),
      child: Center(
        child: Shimmer.fromColors(
            //period: Duration(milliseconds: 1500),
            direction: ShimmerDirection.ltr,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[300],
                    ),
                    Padding(padding: EdgeInsets.all(25.0)),
                  ],
                ),
                SizedBox(height: 85.0),
                Row(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 1.2,
                      color: Colors.grey[300],
                    ),
                    //Padding(padding: EdgeInsets.all(25.0)),
                  ],
                ),
              ],
            ),
            baseColor: Colors.grey[400],
            highlightColor: Colors.grey[100]),
      ),
    );
  }
}
