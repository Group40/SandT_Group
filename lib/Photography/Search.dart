import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'PicGallery.dart';

class SeachPic extends StatefulWidget {
  @override
  SeachPicState createState() => SeachPicState();
}

class SeachPicState extends State<SeachPic> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  List list = List();
  List<String> picsurl = new List();
  bool isLoading = true;
  int pagesize = 9;
  int pageno = 0;
  bool isLoadmorePic = true;
  String txt = setTxt();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    serchGallery();
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          isLoadmorePic == true) {
        serchGallery();
      }
    });
  }

  Future<String> serchGallery() async {
    if (txt.isEmpty) {
      setState(() {
        isLoading = false;
      });
    } else {
      try {
        http.Response response = await http.get(
            Uri.encodeFull("http://192.168.1.26:8080/serchPic/" +
                txt +
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
            for (int i = 0; i < list.length; i++) {
              picsurl.add(json.decode(response.body)[i]['photourl']);
            }
            isLoading = false;
          });
          if (pagesize != list.length) {
            setState(() {
              isLoadmorePic = false;
            });
          }
          list.clear();
        } else {
          _showNetErrorDialog("Somjething went wrong ");
          return null;
        }
      } on TimeoutException catch (_) {
        _showNetErrorDialog("Internet Connection Problem");
        throw Exception('Failed to load');
      }
    }
  }

  Future<String> getPicdata(String url) async {
    String dataurl = 'http://192.168.1.26:8080/viewPicsdata';
    var uri = Uri.parse(dataurl);
    var request = new http.MultipartRequest("POST", uri);
    request.fields['url'] = url;
    var body = {'url': url};
    try {
      final response =
          await request.send().timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) {
          list = (json.decode(value) as List);
          viewpic(url, list[0]['picTitle'], list[0]['picDetails'],
              list[0]['ownername'], "id");
          setState(() {
            isLoading = false;
          });
          list.clear();
        });
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
                if (picsurl.length == 0) {
                  return Center(
                    child: Text(
                      "Can't Find Any thing related " + txt,
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                } else {
                  return GridView.builder(
                      controller: _scrollController,
                      itemCount: picsurl.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        Future.delayed(Duration(milliseconds: 3000));
                        return createPicBox(picsurl[index]);
                      });
                }
              }
            }));
  }

  void viewpic(
      String url, String title, String details, String name, String id) {
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      return DecoratedBox(
        decoration: BoxDecoration(color: Colors.black87),
        child: ListView(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
              height: 50,
              width: 50,
            ),
            SingleChildScrollView(
              child: GridView.count(
                shrinkWrap: true,
                primary: false,
                crossAxisCount: 1,
                children: <Widget>[getpic(url)],
              ),
            ),
            SizedBox(height: 10.0),
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
              padding: const EdgeInsets.all(2),
              child: Text(
                "Captured by " + name,
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.redAccent,
                  //fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.end,
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

  GestureDetector createPicBox(String url) {
    return GestureDetector(
        onTap: () {
          getPicdata(url);
          setState(() {
            isLoading = true;
          });
        },
        child: getpic(url));
  }

  Padding getpic(String url) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new NetworkImage(url), fit: BoxFit.contain))),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PicGallery()));
            },
          ),
        ],
      ),
    );
  }
}
