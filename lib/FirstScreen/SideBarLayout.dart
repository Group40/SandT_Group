import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sandtgroup/FirstScreen/SideBar.dart';
import '../Navigation/Navigation.dart';
import '../main.dart';

/*
class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<Navigation>(
        create: (context) => Navigation(),
        child: Stack(
          children: <Widget>[
            BlocBuilder<Navigation, NavigationState>(
              builder: (context, navigationState) {
                return navigationState as Widget;
              },
            ),
            SideBar(),
          ],
        ),
      ),
      //HomePage(),
    );
  }
}*/
class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Home(),
          SideBar()],
      ),
    );
  }
}
