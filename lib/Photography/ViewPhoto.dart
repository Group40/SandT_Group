import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:sandtgroup/FirstScreen/HomePage.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'package:sandtgroup/Photography/UploadPics.dart';
//import 'package:flutter_advanced_networkimage/provider.dart';

class ViewPhoto extends StatefulWidget {
  @override
  ViewPhotoState createState() => ViewPhotoState();
}

class ViewPhotoState extends State<ViewPhoto> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  List list = List();
  List<String> picsurl = new List();
  List<String> picstitle = new List();
  List<String> picsdetail = new List();
  List<String> picsid = new List();
  String email = getEmail();
  bool isLoading = true;
  int pagesize = 3;
  int pageno = 0;
  bool isLoadmorePic = true;
  bool appbar = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getMyPic();

    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          isLoadmorePic == true) {
        getMyPic();
      }
    });
  }
/*
  void fetchtow() {
    getMyPic();
    setState(() {
      pageno++;
    });
    getMyPic();
  }*/

  Future<String> getMyPic() async {
    await Future.delayed(Duration(milliseconds: 3000));
    try {
      http.Response response = await http.get(
          Uri.encodeFull("http://10.0.2.2:8080/getMypicslist/" +
              email +
              "?pageSize=" +
              pagesize.toString() +
              "&pageNo=" +
              pageno.toString()),
          headers: {
            "Accept": "application/json"
          }).timeout(const Duration(seconds: 40));

      if (response.statusCode == 200) {
        list = (json.decode(response.body) as List);
        setState(() {
          pageno++;
          print(pageno);
          for (int i = 0; i < list.length; i++) {
            picsurl.add(json.decode(response.body)[i]['photourl']);
            picstitle.add(json.decode(response.body)[i]['picTitle']);
            picsdetail.add(json.decode(response.body)[i]['picDetails']);
            picsid.add(json.decode(response.body)[i]['uploadPhotoId']);
          }
          isLoading = false;
        });
        if (pagesize != list.length) {
          setState(() {
            isLoadmorePic = false;
          });
          list.clear();
        }
      } else {
        _showNetErrorDialog("Somjething went wrong ");
        return null;
      }
    } on TimeoutException catch (_) {
      _showNetErrorDialog("Internet Connection Problem");
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        //backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('My Album'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UploadPics()));
              },
            ),
          ],
        ),
        body: StreamBuilder(
            stream: null,
            builder: (context, snapshot) {
              if (isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                );
              } else {
                return GridView.builder(
                    controller: _scrollController,
                    itemCount: picsurl.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      Future.delayed(Duration(milliseconds: 3000));
                      return createPicBox(picstitle[index], picsurl[index],
                          picsdetail[index], picsid[index]);
                    });
              }
            }));
  }

  void viewpic(String url, String title, String details, String id) {
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      return DecoratedBox(
        decoration: BoxDecoration(color: Colors.black87),
        child: ListView(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: 25,
                      right: 10,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            appbar = true;
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
              height: 80,
              width: 50,
            ),
            SingleChildScrollView(
              child: GridView.count(
                shrinkWrap: true,
                primary: false,
                crossAxisCount: 1,
                children: <Widget>[
                  Container(
                      color: url == null ? Colors.green[100] : null,
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                              image: new NetworkImage(url), fit: BoxFit.cover)))
                ],
              ),
            ),
            SizedBox(height: 25.0),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                details,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  GestureDetector createPicBox(
      String title, String url, String detail, String id) {
    return GestureDetector(
        onTap: () {
          viewpic(url, title, detail, id);
        },
        child: getpic(url));
  }

  Padding getpic(String url) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new NetworkImage(url), fit: BoxFit.cover))),
    );
  }

  void _showNetErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Go Back'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
        ],
      ),
    );
  }
}
