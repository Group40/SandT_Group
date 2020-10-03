import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sandtgroup/FirstScreen/Splash.dart';
import 'package:http/http.dart' as http;

class DiscussionForum extends StatefulWidget {
  final myController = TextEditingController();

  @override
  _DiscussionForumState createState() => _DiscussionForumState();
}

class _DiscussionForumState extends State<DiscussionForum> {
  final _firestore = Firestore.instance;
  final myController = TextEditingController();
  final listScrollController = ScrollController(initialScrollOffset: 50.0);
  String name;
  String email;
  int urole;
  String eventID;

  //get eventID
  Future<String> getID() async {
    var response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8080/getForums"),
        headers: {"Accept": "application/json"});
    this.setState(() {
      List data = jsonDecode(response.body);
    });
    print('response body');
  }

  @override
  void initState() {
    super.initState();
    name = getUsername();
    email = getEmail();
    urole = getrole();
    eventID = getID() as String;
    //isLoading = false;
  }

  //report message dialog //not running
  Future<void> _reportMessage() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Are you sure you want to report this message for inappropriate content?",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              )),
          FlatButton(
            onPressed: null, //call report function
            child: Text(
              "Report",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  //display message
  Widget buildMessage(int index, DocumentSnapshot document) {
    return Flexible(
      child: Card(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                document['name'],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                document['body'],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  onPressed: null,
                  child: const Text(
                    'REPLY',
                    style: TextStyle(color: Colors.black, fontSize: 12.0),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    _reportMessage();
                  },
                  child: const Text(
                    'REPORT',
                    style: TextStyle(color: Colors.black, fontSize: 12.0),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  //send method
  Future<void> send(
      String name, String email, int urole, String content) async {
    if (content.trim() != '') {
      myController.clear();
    }

    var documentReference = _firestore
        .collection('messages')
        .document(eventID)
        .collection(eventID)
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    _firestore.runTransaction((transaction) async {
      await transaction.set(documentReference, {
        'name': name,
        'email': email,
        'urole': urole,
        'body': content,
        'timestamp': FieldValue.serverTimestamp()
      });
    });

    // _firestore
    //     .collection('messages')
    //     .document('eventID')
    //     .collection('eventID')
    //     .add({
    //   'id': id,
    //   'name': name,
    //   'body': content,
    //   'timestamp': FieldValue.serverTimestamp()
    //   //DateTime.now().millisecondsSinceEpoch.toString()
    // });
    listScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  //back press
  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Are you sure you want to leave discussion?',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'NO',
                    style: TextStyle(color: Colors.black),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'YES',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(
            'Discussion Forum',
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: false),
      resizeToAvoidBottomPadding: false,
      body: WillPopScope(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              messagesStream(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Material(
                        child: Container(
                          color: Colors.white,
                          child: IconButton(
                            icon: Icon(
                              Icons.create,
                              color: Colors.cyan,
                            ),
                            onPressed: null, //onPressed method to get images
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                            controller: myController,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Type message',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: IconButton(
                            icon: Icon(Icons.send, color: Colors.cyan),
                            onPressed: () =>
                                send(name, email, urole, myController.text),
                          ), //send method to send messages
                        ),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: 50.0,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        onWillPop: _onBackPressed,
      ),
    );
  }

  //retieve message and send to listViewBuilder
  Widget messagesStream() {
    return Flexible(
      child: eventID == ''
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .document(eventID)
                  .collection(eventID)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.cyan,
                    ),
                  );
                }
                return Scrollbar(
                    isAlwaysShown: true,
                    controller: listScrollController,
                    child: ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (_, index) =>
                          buildMessage(index, snapshot.data.documents[index]),
                      reverse: true,
                      itemCount: snapshot.data.documents.length,
                      controller: listScrollController,
                    ));
              },
            ),
    );
  }

  @override
  void dispose() {
    myController.dispose();
    listScrollController.dispose();
    super.dispose();
  }
}
