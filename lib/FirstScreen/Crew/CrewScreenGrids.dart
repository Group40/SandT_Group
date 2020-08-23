import 'package:flutter/material.dart';
import 'package:sandtgroup/EventPublishingBooking/EventBooking.dart';
import 'package:sandtgroup/Institute/CourseList.dart';
import 'package:sandtgroup/Photography/MainPage.dart';

class CrewScreenGrids extends StatelessWidget {
  Item item1 =
      new Item("Event Management", Icons.calendar_today, EventBooking());
  Item item2 = new Item("Photography", Icons.image, MainPage());
  Item item3 = new Item("Courses", Icons.school, CourseList());
  Item item4 = new Item("Youtube", Icons.videocam, MainPage());
  Item item5 = new Item("Magazine", Icons.book, MainPage());
  Item item6 = new Item("S & T Optics", Icons.shopping_basket, MainPage());
  Item item7 = new Item("Home Screen", Icons.home, MainPage());

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
