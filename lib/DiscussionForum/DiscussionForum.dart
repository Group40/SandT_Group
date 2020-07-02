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

  @override
  void initState() {
    super.initState();
    //isLoading = false;
  }

  //build item
  Widget buildMessage(int index, DocumentSnapshot document) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(
            document['body'],
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          width: 200.0,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: EdgeInsets.all(1.0),
        ),
      ],
    );
  }

  //send method
  Future<void> send(String id, String content, int type) async {
    if (content.trim() != '') {
      myController.clear();
    }

    _firestore.collection('messages').add({
      'id': id,
      'body': content,
      'type': type,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
    });
    Timer(
        Duration(milliseconds: 300),
        () => listScrollController
            .jumpTo(listScrollController.position.maxScrollExtent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Discussion Forum',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
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
                          onPressed: () => send('100', myController.text, 0),
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
