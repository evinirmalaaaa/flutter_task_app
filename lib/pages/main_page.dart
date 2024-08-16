import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task_app/config.dart';
import 'package:flutter_task_app/models/user_model.dart';
import 'package:flutter_task_app/pages/calender_page.dart';
import 'package:flutter_task_app/pages/home_screen.dart';
import 'package:flutter_task_app/pages/mambers_sceen.dart';
import 'package:flutter_task_app/pages/profile_page.dart';
import 'package:flutter_task_app/pages/projects_page.dart';

class MainPage extends StatefulWidget {
  final UserModel user;
  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Map<String, String>> _navigationItems = [
    {
      "icon": "assets/images/bottom_navbar/home.svg",
      "label": "Home",
    },
    {
      "icon": "assets/images/bottom_navbar/pinpaper-filled.svg",
      "label": "Projects",
    },
    {
      "icon": "assets/images/bottom_navbar/calendar.svg",
      "label": "Calendar",
    },
    {
      "icon": "assets/images/bottom_navbar/users-more.svg",
      "label": "Members",
    },
    {
      "icon": "assets/images/bottom_navbar/person.svg",
      "label": "Profile",
    },
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  body() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen(
          user: widget.user,
        );
      case 1:
        return ProjectPage();
      case 2:
        return CalenderPage();
      case 3:
        return MembersScreen();
      case 4:
        return ProfilePage(
          user: widget.user,
        );
      default:
        return Center(
            child: Text(
          'Text',
          style: font.copyWith(),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
      bottomNavigationBar: BottomNavigationBar(
        items: _navigationItems.map((item) {
          return BottomNavigationBarItem(
            icon: SvgPicture.asset(item["icon"]!,
                colorFilter: ColorFilter.mode(
                  _selectedIndex == _navigationItems.indexOf(item)
                      ? Colors.deepPurple
                      : Colors.black,
                  BlendMode.srcIn,
                )),
            label: item["label"],
          );
        }).toList(),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
