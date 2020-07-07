import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sandtgroup/EventPublishingBooking/EventBooking.dart';

import 'package:sandtgroup/FirstScreen/Menu.dart';
import 'package:sandtgroup/Navigation/Navigation.dart';
import 'package:sandtgroup/main.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;
  //final bool isSidebarOpen = true;
  final _animationDuration = const Duration(milliseconds: 350);
  StreamController<bool> isSideBarOpenedStreamController;
  Stream<bool> isSideBarOpendeStream;
  StreamSink<bool> isSideBarOpenedSink;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSideBarOpenedStreamController = PublishSubject<bool>();
    isSideBarOpendeStream = isSideBarOpenedStreamController.stream;
    isSideBarOpenedSink = isSideBarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    isSideBarOpenedStreamController.close();
    isSideBarOpenedSink.close();
    super.dispose();
  }

  void OnIconPress() {
    final animationstatus = _animationController.status;
    final isAnimationComleted = animationstatus == AnimationStatus.completed;

    if (isAnimationComleted) {
      isSideBarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSideBarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSideBarOpendeStream,
      builder: (context, isSideBarOpendeAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 25,
          bottom: 0,
          left: isSideBarOpendeAsync.data ? 0 : -screenWidth,
          right: isSideBarOpendeAsync.data ? 120 : screenWidth - 35,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.cyan,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      FractionalTranslation(
                        translation: Offset(0.0, -0.4),
                        child: Align(
                          child: CircleAvatar(
                            radius: 30.0,
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 45,
                            ),
                          ),
                          alignment: FractionalOffset(0.5, 0.0),
                        ),
                      ),
                      /*ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.perm_identity,
                            color: Colors.white,
                          ),
                          radius: 40,
                        ),),*/
                      ListTile(
                        title: Text(
                          "USER NAME",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "email@email.com",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Divider(
                        height: 64,
                        thickness: 0.8,
                        color: Colors.black.withOpacity(0.3),
                        indent: 32,
                        endIndent: 32,
                      ),
                      Menu(
                        icon: Icons.person,
                        title: "Profile",
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EventBooking();
                          }));
                          OnIconPress();
                          /*
                          BlocProvider.of<Navigation>(context)
                              .add(NavigationEvent.HomeClick);*/
                        },
                      ),
                      Menu(
                        icon: Icons.home,
                        title: "Home",
                        onTap: () {
                          OnIconPress();

                          /*BlocProvider.of<Navigation>(context)
                              .add(NavigationEvent.HomeClick);*/
                        },
                      ),
                      Menu(
                        icon: Icons.home,
                        title: "Piyumal",
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EventBooking();
                          }));
                          OnIconPress();
                          /*BlocProvider.of<Navigation>(context)
                              .add(NavigationEvent.PiyumalClick);*/
                        },
                      ),
                      Divider(
                        height: 64,
                        thickness: 0.8,
                        color: Colors.black.withOpacity(0.3),
                        indent: 32,
                        endIndent: 32,
                      ),
                      Menu(
                        icon: Icons.home,
                        title: "Piyumal",
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -1),
                child: GestureDetector(
                  onTap: () {
                    OnIconPress();
                  },
                  child: ClipPath(
                    //clipper: //MenuClipper(),
                    child: Container(
                      width: 30,
                      height: 55,
                      color: Colors.cyan,
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        icon: AnimatedIcons.menu_close,
                        progress: _animationController.view,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class MenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
