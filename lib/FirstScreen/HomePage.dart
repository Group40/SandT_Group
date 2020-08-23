//User Home Page
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:sandtgroup/FirstScreen/HomeScreenGrids.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import 'AppDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  List imglist = List();
  bool isLoading = true;
  bool networkImg = false;
  int _current = 0;

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
        imglist = ['assets/image/logo.jpg'];
        //imglist = (json.decode(response.body) as List);
        setState(() {
          isLoading = false;
          //networkImg = true;
        });
      } else {
        imglist = ['assets/image/logo.jpg'];
      }
    } on TimeoutException catch (_) {
      imglist = ['assets/image/logo.jpg'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[100],
      key: _scaffoldKey,
      drawer: new AppDrawer(),
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          "S & T Group",
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: !isLoading
          ? Container(
              //padding: EdgeInsets.all(20.0),
              //height: 200,
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
                        autoPlayInterval: Duration(seconds: 2),
                        autoPlayAnimationDuration: Duration(microseconds: 500),
                        pauseAutoPlayOnTouch: true,
                        scrollDirection: Axis.horizontal,
                        enableInfiniteScroll: networkImg ? true : false,
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
                        "Our Products",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  //SizedBox(height: 5.0),
                  HomeScreenGrids()
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.all(25),
              child: Center(
                child: Shimmer.fromColors(
                    period: Duration(milliseconds: 1500),
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
                              width: MediaQuery.of(context).size.width/1.2,
                              color: Colors.grey[300],
                            ),
                            //Padding(padding: EdgeInsets.all(25.0)),
                          ],
                        ),
                        SizedBox(height: 35.0),
                        Row(
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width/1.2,
                              color: Colors.grey[300],
                            ),
                            //Padding(padding: EdgeInsets.all(25.0)),
                          ],
                        )
                      ],
                    ),
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.grey[100]),
              ),
            ),
    );
  }
}
