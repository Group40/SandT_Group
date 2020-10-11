import 'package:flutter/material.dart';
import 'package:sandtgroup/DiscussionForum/UserViewForums.dart';
import 'package:sandtgroup/DiscussionForum/ViewAllForums.dart';

class AdminView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Forums',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text("All forums"),
              ),
              Tab(
                child: Text("Active forums"),
              )
            ],
          ),
        ),
        body: TabBarView(children: [
          ViewAllForums(),
          UserViewForums(),
        ]),
      ),
    );
    throw UnimplementedError();
  }
}
