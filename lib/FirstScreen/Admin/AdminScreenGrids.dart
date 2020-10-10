import 'package:flutter/material.dart';
import 'package:sandtgroup/EventPublishingBooking/EventBooking.dart';
import 'package:sandtgroup/FirstScreen/UserScreenManagement/UserScreenManagement.dart';
import 'package:sandtgroup/Institute/CourseList.dart';
import 'package:sandtgroup/Photography/PicGallery.dart';
import 'package:sandtgroup/UserManagementAdmin/UserManagementAdmin.dart';

class AdminScreenGrids extends StatelessWidget {
  Item item1 =
      new Item("Event Management", Icons.calendar_today, EventBooking());
  Item item2 = new Item("Photography", Icons.image, PicGallery());
  Item item3 = new Item("Courses", Icons.school, CourseList());
  Item item4 = new Item("Youtube", Icons.videocam, UserScreenManagement());
  Item item5 = new Item("Magazine", Icons.book, UserScreenManagement());
  Item item6 =
      new Item("S & T Optics", Icons.shopping_basket, UserScreenManagement());
  Item item7 = new Item("Home Screen", Icons.home, UserScreenManagement());
  Item item8 = new Item(
      "User Management", Icons.supervised_user_circle, UserManagementAdmin());

  @override
  Widget build(BuildContext context) {
    List<Item> iconlist = [
      item1,
      item2,
      item3,
      item4,
      item5,
      item6,
      item7,
      item8
    ];
    return Flexible(
      child: ListView(
          padding: EdgeInsets.all(10),
          children: iconlist.map((data) {
            return Container(
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => data.page)),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(data.icon),
                        title: Text(
                          data.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        dense: false,
                      ),
                    )),
              ),
            );
          }).toList()),
    );
  }
}

class Item {
  String title;
  final IconData icon;
  final Widget page;
  Item(this.title, this.icon, this.page);
}
//event
//photography
//optics
//magazine
//youtube
//course
