import 'package:flutter/material.dart';
import 'package:my_app/presentation/friends/friends.dart';
import 'package:my_app/presentation/groups/create_group.dart';
import 'package:my_app/presentation/profile/profile.dart';
import 'package:my_app/presentation/home/home_page.dart';
import 'package:my_app/presentation/search.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> screens = [
    HomePage(),
    const Search(),
    const FriendsList(),
    Container(),
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
        onTap: (index) {
          if (index == 3) {
            openDrawer();
          } else {
            setState(() {
              selectedIndex = index;
            });
          }
        },
        backgroundColor: const Color(0xff000080),
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Groups",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff000080),
        foregroundColor: Colors.black,
        hoverElevation: 10,
        splashColor: Colors.grey,
        tooltip: 'Add',
        elevation: 4,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CreateGroup()),
          );
        },
      ),
      body: Center(
        child: screens[selectedIndex],
      ),
    );
  }
}
