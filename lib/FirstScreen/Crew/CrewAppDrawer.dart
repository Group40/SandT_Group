import 'package:flutter/material.dart';
import 'package:sandtgroup/FirstScreen/Profile.dart';
import 'package:sandtgroup/Photography/MainPage.dart';
import 'package:sandtgroup/Photography/PicGallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../Menu.dart';
import '../Splash.dart';
import '../../EventPublishingBooking/EventPublishing.dart';
import '../../Institute/AdminCourseList.dart';
import '../../Notification/CrewNotification.dart';

class CrewAppDrawer extends StatefulWidget {
  @override
  _CrewAppDrawerState createState() => new _CrewAppDrawerState();
}

class _CrewAppDrawerState extends State<CrewAppDrawer> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: Container(
      color: Colors.grey,
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
            icon: Icons.person,
            title: "Profile",
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
          Menu(
            icon: Icons.event,
            title: "Publish Events",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EventPublishing();
              }));
            },
          ),
          Menu(
            icon: Icons.school,
            title: "Course List",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AdminCourse();
              }));
            },
          ),
          Menu(
            icon: Icons.report,
            title: "Activity Report",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CrewNotification();
              }));
            },
          ),
          Menu(
            icon: Icons.image,
            title: "Photography",
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PicGallery()));
            },
          ),
          Divider(
            height: 40,
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
              clearEmail();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SplashScreen()));
            },
          ),
        ],
      ),
    ));
  }
}
