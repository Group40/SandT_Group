import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'package:sandtgroup/Photography/AdminFun/ReviewPic.dart';
import 'package:shimmer/shimmer.dart';

import '../PicGallery.dart';

var notificationUrl = getUrl() + "/addNotification";

class ViewScreenAdmin extends StatefulWidget {
  final String picurl;
  final bool ismypic;
  final bool isreview;
  ViewScreenAdmin({Key key, this.picurl, this.ismypic, this.isreview})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ViewScreenAdminState();
}

class _ViewScreenAdminState extends State<ViewScreenAdmin> {
  List list = List();
  String title = "";
  String email = "";
  String detail = "";
  String ownername = "";
  List<String> picsid = new List();
  bool isLoading = true;
  bool _btnstateconfirm = false;
  bool _btnstatedelete = false;
  String picid = "";
  String date = "";
  String town = "";
  String distric = "";

  @override
  void initState() {
    super.initState();
    getPicdata();
  }

  Future<String> getPicdata() async {
    isLoading = true;
    String dataurl = getUrl() + '/admin/viewPicsdata';
    var uri = Uri.parse(dataurl);
    var request = new http.MultipartRequest("POST", uri);
    request.fields['url'] = widget.picurl;
    var body = {'url': widget.picurl};
    try {
      final response =
          await request.send().timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) {
          list = (json.decode(value) as List);
          title = list[0]['picTitle'];
          detail = list[0]['picDetails'];
          ownername = list[0]['ownername'];
          email = list[0]['ownerEmail'];
          picid = list[0]['uploadPhotoId'];
          date = list[0]['date'];
          town = list[0]['town'];
          distric = list[0]['distric'];
          // viewpic(
          //   url,
          //   list[0]['picTitle'],
          //   list[0]['picDetails'],
          //   /*list[0]['ownername'], "id"*/
          // );
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

  Future<String> confirmPicReport() async {
    var notificationBody = jsonEncode({
      'authorName': getUsername(),
      'authorType': getrole(),
      'authorMail': getEmail(),
      'name': title,
      'nameType': "confirmed the photo",
      'date': DateTime.now().toString(),
    });
    return http.post(notificationUrl, body: notificationBody, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      setState(() {
        _btnstateconfirm = false;
      });
      Navigator.of(context).pop();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ReviewPic();
      }));
    });
  }

  Future<String> confirmPic() async {
    String senturl = getUrl() + '/picreviewed/' + picid;
    try {
      final response = await http.put(
        senturl,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
      );
      if (response.statusCode == 200) {
        confirmPicReport();
      } else {
        _showNetErrorDialog("Somjething went wrong ");
        return null;
      }
    } on TimeoutException catch (_) {
      _showNetErrorDialog("Internet Connection Problem");
      throw Exception('Failed to load');
    }
  }

  Future<String> unreviewePicReport() async {
    var notificationBody = jsonEncode({
      'authorName': getUsername(),
      'authorType': getrole(),
      'authorMail': getEmail(),
      'name': title,
      'nameType': "unreview photo",
      'date': DateTime.now().toString(),
    });
    return http.post(notificationUrl, body: notificationBody, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      setState(() {
        _btnstatedelete = false;
      });
      Navigator.of(context).pop();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return PicGallery();
      }));
    });
  }

  Future<String> unreviewePic() async {
    String senturl = getUrl() + '/picunreviewed/' + picid;
    try {
      final response = await http.put(
        senturl,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
      );
      if (response.statusCode == 200) {
        unreviewePicReport();
      } else {
        _showNetErrorDialog("Somjething went wrong ");
        return null;
      }
    } on TimeoutException catch (_) {
      _showNetErrorDialog("Internet Connection Problem");
      throw Exception('Failed to load');
    }
  }

  Future<String> deletReport() async {
    var notificationBody = jsonEncode({
      'authorName': getUsername(),
      'authorType': getrole(),
      'authorMail': getEmail(),
      'name': title,
      'nameType': "deleted photo",
      'date': DateTime.now().toString(),
    });
    return http.post(notificationUrl, body: notificationBody, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      setState(() {
        _btnstatedelete = false;
      });
      Navigator.of(context).pop();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return PicGallery();
      }));
    });
  }

  Future<String> deletePic() async {
    String senturl = getUrl() + '/deletepic/' + picid;
    try {
      final response = await http.delete(
        senturl,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
      );
      if (response.statusCode == 200) {
        deletReport();
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
    return Scaffold(
        //appBar: ,
        body: ListView(
      children: <Widget>[
        new Container(
            child: AppBar(
          title: Text(
            'Review Upload Photos',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white.withOpacity(1),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
        )),
        //Image.network(widget.picurl),
        FadeInImage.assetNetwork(
            image: widget.picurl,
            placeholder: "assets/loading/image.gif" // your assets image path

            ),
        SizedBox(height: 45.0),
        isLoading
            ? placeholder()
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
        (!isLoading && !widget.ismypic)
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.camera_alt),
                        Text(
                          "  " + ownername,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 18,
                        ),
                        Text(
                          "  " + email.toString(),
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            : SizedBox(height: 5.0),
        isLoading
            ? placeholder()
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Captuer Date : "+
                          " " + date,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Text(
                          "Captuer Town : "+
                          " " + town,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Text(
                          "Captuer Ditric : "
                          +
                          " " + distric,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    SizedBox(height: 25.0),
                    Row(
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        children: [
                          Text(detail,
                              style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.left)
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    widget.isreview ? _buildConfirmBtn() : _buildUnreviewBtn(),
                    widget.isreview ? _buildDelete() : SizedBox(height: 5.0),
                  ],
                ),
              ),
      ],
    ));
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

  void _showBtnMsg(String title, String message, bool isdelete) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              setState(() {
                _btnstatedelete = false;
              });
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              setState(() {
                _btnstatedelete = true;
                if (isdelete) {
                  deletePic();
                } else {
                  unreviewePic();
                }
              });
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Row txtplaceholder() {
    return Row(
      children: <Widget>[
        Container(
          height: 8,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildConfirmBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            confirmPic();
            setState(() {
              _btnstateconfirm = true;
            });
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blueAccent,
          child: setUpConfirmButton()),
    );
  }

  Widget setUpConfirmButton() {
    if (_btnstateconfirm == false) {
      return new Text(
        'Confirm Photo',
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 1.5,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        ),
      );
    } else if (_btnstateconfirm == true) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  Widget _buildUnreviewBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            if (!_btnstatedelete) {
              _showBtnMsg("Are You Sure",
                  "Do You really want to unreview this image ?", false);
            }
            // setState(() {
            //   _btnstatedelete = true;
            // });
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.redAccent[400],
          child: setUpUnreviewButton()),
    );
  }

  Widget setUpUnreviewButton() {
    if (_btnstatedelete == false) {
      return new Text(
        'Unreview Photo',
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 1.5,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        ),
      );
    } else if (_btnstatedelete == true) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  Widget _buildDelete() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            if (!_btnstatedelete) {
              _showBtnMsg("Are You Sure",
                  "Do You really want to delete this image ?", true);
            }
            // setState(() {
            //   _btnstatedelete = true;
            // });
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.redAccent[700],
          child: setUpDeleteButton()),
    );
  }

  Widget setUpDeleteButton() {
    if (_btnstatedelete == false) {
      return new Text(
        'Delete Photo',
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 1.5,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        ),
      );
    } else if (_btnstatedelete == true) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  Center placeholder() {
    return Center(
      child: Shimmer.fromColors(
          period: Duration(milliseconds: 800),
          direction: ShimmerDirection.ltr,
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[300],
                ),
              ],
            ),
            SizedBox(height: 35.0),
            txtplaceholder(),
            SizedBox(height: 8.0),
            txtplaceholder(),
            SizedBox(height: 8.0),
            txtplaceholder(),
            SizedBox(height: 8.0),
            txtplaceholder(),
            SizedBox(height: 25.0),
          ]),
          baseColor: Colors.grey[400],
          highlightColor: Colors.grey[100]),
    );
  }
}
