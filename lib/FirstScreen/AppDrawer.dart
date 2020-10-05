import 'package:flutter/material.dart';
import 'package:sandtgroup/DiscussionForum/UserViewForums.dart';
import 'package:sandtgroup/Photography/MainPage.dart';
import 'package:sandtgroup/Photography/UploadPics.dart';
import 'package:sandtgroup/YouTube/Playlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'Menu.dart';
import 'Profile.dart';
import 'Splash.dart';
import '../EventPublishingBooking/EventBooking.dart';
import '../Institute/CourseList.dart';
import '../Notification/UserNotification.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => new _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: Container(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: Text(
              getUsername().toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              getEmail(),
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            currentAccountPicture: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 80,
              ),
            ),
          ),
          Menu(
            icon: Icons.notifications_active,
            title: "Notifications",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UserNotification();
              }));
            },
          ),
          Menu(
            icon: Icons.person,
            title: "Profile",
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
          Menu(
            icon: Icons.home,
            title: "Home",
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          Menu(
            icon: Icons.event,
            title: "Upcoming Event",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EventBooking();
              }));
            },
          ),
          Menu(
            icon: Icons.school,
            title: "Courses",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CourseList();
              }));
            },
          ),
          Menu(
            icon: Icons.image,
            title: "Photography",
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
            },
          ),
          Menu(
            icon: Icons.bookmark,
            title: "Discussion",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UserViewForums();
              }));
            },
          ),
          Menu(
            icon: Icons.bookmark,
            title: "YouTube",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Playlist();
              }));
            },
          ),
          Divider(
            height: 65,
            thickness: 0.8,
            color: Colors.black.withOpacity(0.3),
            indent: 32,
            endIndent: 32,
          ),
          Menu(
            icon: Icons.clear_all,
            title: "Log Out",
            onTap: () async {
              Navigator.of(context).pop();
              final pref = await SharedPreferences.getInstance();
              await pref.clear();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SplashScreen()));
            },
          ),
        ],
      ),
    ));
  }
}
