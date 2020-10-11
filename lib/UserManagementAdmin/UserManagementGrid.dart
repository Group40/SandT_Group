import 'package:flutter/material.dart';
import 'package:sandtgroup/UserManagementAdmin/AdminUsers.dart';

import 'Block.dart';
import 'CrewMembers.dart';
import 'UserMembers.dart';

class UserManagementGrid extends StatelessWidget {
  Item item1 =
      new Item("Admin Members", Icons.admin_panel_settings, AdminUsers());
  Item item2 = new Item(
      "Crew Members", Icons.admin_panel_settings_outlined, CrewUsers());
  Item item3 =
      new Item("Users", Icons.supervised_user_circle_sharp, NormalUsers());
  Item item4 = new Item("Block Users", Icons.block, BlockUsers());

  @override
  Widget build(BuildContext context) {
    List<Item> iconlist = [
      item1,
      item2,
      item3,
      item4,
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
