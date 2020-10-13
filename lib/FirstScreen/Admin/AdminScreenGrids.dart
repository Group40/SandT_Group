import 'package:flutter/material.dart';
import 'package:sandtgroup/ArticleHandling/ArticleAdmin.dart';
import 'package:sandtgroup/DiscussionForum/AdminView.dart';
import 'package:sandtgroup/EventPublishingBooking/EventBooking.dart';
import 'package:sandtgroup/Institute/CourseList.dart';
import 'package:sandtgroup/Photography/PicGallery.dart';
import 'package:sandtgroup/UserManagementAdmin/UserManagementAdmin.dart';
import 'package:sandtgroup/YouTube/Playlist.dart';
import '../../EventPublishingBooking/EventPublishing.dart';
import '../../Institute/AdminCourseList.dart';

class AdminScreenGrids extends StatelessWidget {
  Item item1 =
      new Item("Event Management", Icons.calendar_today, EventPublishing());
  Item item2 = new Item("Photography", Icons.image, PicGallery());
  Item item3 = new Item("Courses", Icons.school, AdminCourse());
  Item item4 = new Item("Youtube", Icons.videocam, Playlist());
  Item item5 = new Item("Magazine", Icons.book, Playlist());
  Item item6 = new Item("Discussion Forum", Icons.shopping_basket, AdminView());
  Item item7 = new Item("Article", Icons.article, ArticleAdmin());
  Item item8 = new Item(
      "User Management", Icons.supervised_user_circle, UserManagementAdmin());

  @override
  Widget build(BuildContext context) {
    List<Item> iconlist = [
      item8,
      item1,
      item2,
      item3,
      item4,
      item6,
      item7,
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
