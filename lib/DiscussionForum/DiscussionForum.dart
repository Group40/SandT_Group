import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DiscussionForum extends StatefulWidget {
  final myController = TextEditingController();

  @override
  _DiscussionForumState createState() => _DiscussionForumState();
}

class _DiscussionForumState extends State<DiscussionForum> {
  final _firestore = Firestore.instance;
  final myController = TextEditingController();
  final listScrollController = ScrollController(initialScrollOffset: 50.0);
  String name = '';
  String id = '';

  @override
  void initState() {
    super.initState();
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
            onPressed: null,
            child: Text(
              "Report",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  // Widget buildMessage(int index, DocumentSnapshot document) {
  //   return Column(
  //     children: [
  //       Row(
  //         children: <Widget>[
  //           Container(
  //             child: Text(
  //               document['name'],
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 fontSize: 12.0,
  //               ),
  //             ),
  //             margin: EdgeInsets.only(top: 10.0),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: <Widget>[
  //           Expanded(
  //             flex: 14,
  //             child: Bubble(
  //               child: Text(
  //                 document['body'],
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 15.0,
  //                 ),
  //               ),
  //               alignment: Alignment.topLeft,
  //               color: Colors.cyan,
  //               nip: BubbleNip.leftTop,
  //               margin: BubbleEdges.only(right: 10.0, bottom: 10.0),
  //             ),
  //           ),
  //           Expanded(
  //               flex: 2,
  //               child: PopupMenuButton(
  //                   icon: Icon(
  //                     Icons.more_vert,
  //                     color: Colors.cyan,
  //                   ),
  //                   offset: Offset(0, 20),
  //                   color: Colors.white,
  //                   elevation: 8.0,
  //                   itemBuilder: (context) => [
  //                         PopupMenuItem(
  //                           child: InkResponse(
  //                               //borderRadius: BorderRadius.horizontal(),
  //                               highlightShape: BoxShape.rectangle,
  //                               child: Text(
  //                                 "Report message",
  //                                 style: TextStyle(
  //                                     color: Colors.black, fontSize: 12.0),
  //                               ),
  //                               onTap: () {
  //                                 Navigator.pop(context);
  //                                 _reportMessage();
  //                               }),
  //                           height: 30.0,
  //                           enabled: true,
  //                         ),
  //                       ]))
  //         ],
  //       ),

  //       //  ),
  //     ],
  //   );
  // }

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
  Future<void> send(String id, String name, String content) async {
    if (content.trim() != '') {
      myController.clear();
    }

    _firestore.collection('messages').add({
      'id': id,
      'name': name,
      'body': content,
      'timestamp': FieldValue.serverTimestamp()
      //DateTime.now().millisecondsSinceEpoch.toString()
    });
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
                              Icons.image,
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
                            onPressed: () => send(
                                '100', 'Hasini Kandage', myController.text),
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

  Widget messagesStream() {
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('messages')
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
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemBuilder: (_, index) =>
                buildMessage(index, snapshot.data.documents[index]),
            reverse: true,
            itemCount: snapshot.data.documents.length,
            controller: listScrollController,
          );
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
