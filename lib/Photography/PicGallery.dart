import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'dart:async';
import 'dart:convert';
import 'AdminFun/ViewScreenAdmin.dart';
import 'PicViewScreen.dart';
import 'Search.dart';

String searchtxt;

class PicGallery extends StatefulWidget {
  @override
  PicGalleryState createState() => PicGalleryState();
}

class PicGalleryState extends State<PicGallery> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  List list = List();
  List<String> picsurl = new List();
  bool isLoading = true;
  int pagesize = 7;
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
    getPicGallery();
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          isLoadmorePic == true) {
        getPicGallery();
      }
    });
  }

  Future<String> getPicGallery() async {
    await Future.delayed(Duration(milliseconds: 3000));
    try {
      http.Response response = await http.get(
          Uri.encodeFull(getUrl() +
              "/viewGallery/" +
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        //backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Astro Photography'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSerch());
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
                        childAspectRatio: width / (height / 1.4),
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 5,
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      Future.delayed(Duration(milliseconds: 3000));
                      return createPicBox(picsurl[index]);
                    });
              }
            }));
  }

  GestureDetector createPicBox(String url) {
    return GestureDetector(
        onTap: () {
          if (getrole() == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PicViewScreen(
                          picurl: url,
                          ismypic: false,
                        )));
          } else if (getrole() == 2 || getrole() == 3) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewScreenAdmin(
                          picurl: url,
                          ismypic: false,
                          isreview: false,
                        )));
          }
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

class DataSerch extends SearchDelegate<String> {
  final suggest = [
    "sun",
    "moon",
    "mars",
    "test",
    "title",
    "star",
  ];
  final recent = [];
  PicGallery picGallery;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: query == "" ? Icon(null) : Icon(Icons.search),
          onPressed: () {
            query == "" ? seachDone(context) : showResults(context);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: query == "" ? Icon(Icons.undo) : Icon(Icons.close),
        onPressed: () {
          query == "" ? seachDone(context) : query = "";
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    searchtxt = query;
    return SeachPic();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recent.where((element) => element.startsWith(query)).toList()
        : suggest.where((element) => element.startsWith(query)).toList();

    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
            onTap: () {
              query = suggestionList[index];
              showResults(context);
            },
            leading: Icon(Icons.find_in_page),
            title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                  TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.grey))
                ]))),
        itemCount: suggestionList.length);
  }
}

String setTxt() {
  return searchtxt;
}

void seachDone(BuildContext context) {
  Navigator.pop(context);
  PicGallery();
}
