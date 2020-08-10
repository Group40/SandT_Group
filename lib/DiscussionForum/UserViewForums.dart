import 'package:flutter/material.dart';

class UserViewForums extends StatefulWidget {
  @override
  _UserViewForumsState createState() => _UserViewForumsState();

  UserViewForums({Key key}) : super(key: key);
}

class _UserViewForumsState extends State<UserViewForums> {
  final listScrollController = ScrollController(initialScrollOffset: 50.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'View Forums',
            style: TextStyle(color: Colors.white),
          ),
          leading: BackButton(
            color: Colors.white,
          ),
        ),
        body: Center(
          child: Scrollbar(
              isAlwaysShown: true,
              controller: listScrollController,
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                controller: listScrollController,
                itemCount: null,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            "",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
        ));
  }
}
