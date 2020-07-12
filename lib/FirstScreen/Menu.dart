import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;

  const Menu({Key key, this.title, this.icon, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: Colors.black,
                size: 30,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                    color: Colors.black),
              )
            ],
          )),
    );
  }
}
