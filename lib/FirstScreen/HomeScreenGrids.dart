import 'package:flutter/material.dart';
import 'package:sandtgroup/ArticleHandling/ArticleHome.dart';
import 'package:sandtgroup/EventPublishingBooking/EventBooking.dart';
import 'package:sandtgroup/Institute/CourseList.dart';
import 'package:sandtgroup/Photography/PicGallery.dart';

class HomeScreenGrids extends StatelessWidget {
  Item item1 = new Item("Event", 'assets/icons/calendar.jpg', EventBooking());
  Item item2 = new Item("Photography", 'assets/icons/pics.png', PicGallery());
  Item item3 = new Item("Courses", 'assets/icons/course.png', CourseList());

  Item item4 = new Item("Youtube", 'assets/icons/youtube.png', ArticleHome());
  Item item5 = new Item("Magazine", 'assets/icons/magazine.jpg', MainPage());
  Item item6 = new Item("S&T Optics", 'assets/icons/store.png', MainPage());



  @override
  Widget build(BuildContext context) {
    List<Item> iconlist = [item1, item2, item3, item4, item5, item6];
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.all(20),
          crossAxisCount: 3,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: iconlist.map((data) {
            return Container(
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => data.page)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        data.img,
                        width: 42,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        data.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }
}

class Item {
  String title;
  String img;
  final Widget page;
  Item(this.title, this.img, this.page);
}
//event
//photography
//optics
//magazine
//youtube
//course
