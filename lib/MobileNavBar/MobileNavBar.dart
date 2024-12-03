import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmc/LineStatus/LineStatus.dart';
import 'package:gmc/MessagesPage/messages_page.dart';
import 'package:gmc/ProfilePage/profile_page.dart';
import 'package:gmc/Themes/gmc_colors.dart';

class MobileNavBar extends StatefulWidget {
  const MobileNavBar({super.key});

  @override
  State<MobileNavBar> createState() => _MobileNavBarState();
}

class _MobileNavBarState extends State<MobileNavBar> {
  int _selectedIndex = 1;

  static const List<Widget> _pages = <Widget>[
    MessagesPage(),
    LineStatus(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: GMCColors.darkBrown,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'images/Chat.svg',
              color: _selectedIndex == 0 ? GMCColors.orange : GMCColors.white,
              height: 24,
              width: 24,
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'images/House.svg',
              color: _selectedIndex == 1 ? GMCColors.orange : GMCColors.white,
              height: 24,
              width: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'images/Person.svg',
              color: _selectedIndex == 2 ? GMCColors.orange : GMCColors.white,
              height: 24,
              width: 24,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: GMCColors.orange,
        unselectedItemColor: GMCColors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
