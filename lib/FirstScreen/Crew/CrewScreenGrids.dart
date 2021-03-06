import 'package:flutter/material.dart';
import 'package:sandtgroup/DiscussionForum/AdminView.dart';
import 'package:sandtgroup/EventPublishingBooking/EventBooking.dart';
import 'package:sandtgroup/Institute/CourseList.dart';
import 'package:sandtgroup/Photography/PicGallery.dart';
import 'package:sandtgroup/YouTube/Playlist.dart';
import '../../EventPublishingBooking/EventPublishing.dart';
import '../../Institute/AdminCourseList.dart';

class CrewScreenGrids extends StatelessWidget {
  Item item1 =
      new Item("Event Management", Icons.calendar_today, EventPublishing());
  Item item2 = new Item("Photography", Icons.image, PicGallery());
  Item item3 = new Item("Courses", Icons.school, AdminCourse());
  Item item4 = new Item("Youtube", Icons.videocam, Playlist());
  Item item5 = new Item("Magazine", Icons.book, CourseList());
  Item item6 = new Item("Discussion Forum", Icons.shopping_basket, AdminView());

  @override
  Widget build(BuildContext context) {
    List<Item> iconlist = [
      item1,
      item2,
      item3,
      item4,
      item6,
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
                      color: Colors.grey[400],
                      child: ListTile(
                        leading: Icon(data.icon),
                        title: Text(
                          data.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
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
