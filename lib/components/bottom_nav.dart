import 'package:flutter/material.dart';
import 'package:my_app/presentation/friends/friends.dart';
import 'package:my_app/presentation/profile/profile.dart';
import 'package:my_app/presentation/home/home_page.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectindex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> screens = [
    HomePage(),
    FriendsList(),
  ];

  void openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ProfilePage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectindex,
        onTap: (index) {
          if (index == 2) {
            openDrawer();
          } else {
            setState(() {
              selectindex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Groups",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Friends",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: "Profile",
          ),
        ],
      ),
      body: Center(
        child: screens[selectindex],
      ),
    );
  }
}
