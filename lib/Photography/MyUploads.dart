import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'package:sandtgroup/Photography/PicViewScreen.dart';
import 'package:sandtgroup/Photography/UploadPics.dart';
import 'package:shimmer/shimmer.dart';

class MyUploads extends StatefulWidget {
  @override
  MyUploadsState createState() => MyUploadsState();
}

class MyUploadsState extends State<MyUploads> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  List list = List();
  List<String> picsurl = new List();
  String email = getEmail();
  bool isLoading = true;
  int pagesize = 6;
  int pageno = 0;
  bool isLoadmorePic = true;

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

  Future<String> getMyPic() async {
    await Future.delayed(Duration(milliseconds: 3000));
    try {
      http.Response response = await http.get(
          Uri.encodeFull(getUrl() +
              "/getMypicslist/" +
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
          for (int i = 0; i < list.length; i++) {
            picsurl.add(json.decode(response.body)[i]['photourl']);
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

  int getlenth() {
    if (isLoadmorePic) {
      return (picsurl.length + 1);
    } else {
      return (picsurl.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        //backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('My Uploads'),
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
              } else if (getlenth() == 0) {
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(height: 55.0),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Nothing to show",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              } else {
                return Container(
                  child: GridView.builder(
                      controller: _scrollController,
                      itemCount: getlenth(), //picsurl.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: width / (height / 1.4),
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 5,
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        Future.delayed(Duration(milliseconds: 3000));
                        if (index == picsurl.length) {
                          //show loading indicator at last index
                          if (isLoadmorePic == true) {
                            return Center(
                              child: Shimmer.fromColors(
                                  period: Duration(milliseconds: 800),
                                  direction: ShimmerDirection.ltr,
                                  child: Container(
                                    height: height / 1.4,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey[300],
                                  ),
                                  baseColor: Colors.grey[400],
                                  highlightColor: Colors.grey[100]),
                              // CircularProgressIndicator(
                              //   backgroundColor: Colors.black,
                              // ),
                            );
                          }
                        }
                        return createPicBox(picsurl[index]);
                      }),
                );
              }
            }));
  }

  GestureDetector createPicBox(String url) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PicViewScreen(
                        picurl: url,
                        ismypic: true,
                      )));
          //getPicdata(url);
          //viewpic(url, "title", "detail", "id");
        },
        child: getpic(url));
  }

  Padding getpic(String url) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
          decoration: new BoxDecoration(
              color: Colors.grey,
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
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
