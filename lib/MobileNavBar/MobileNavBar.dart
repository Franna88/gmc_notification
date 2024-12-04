import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmc/LineStatus/LineAttend.dart';
import 'package:gmc/LineStatus/LineStatus.dart';
import 'package:gmc/LineStatus/Reuseable/TimeService.dart';
import 'package:gmc/MessagesPage/messages_page.dart';
import 'package:gmc/ProfilePage/profile_page.dart';
import 'package:gmc/Themes/gmc_colors.dart';

class MobileNavBar extends StatefulWidget {
  const MobileNavBar({super.key});

  @override
  State<MobileNavBar> createState() => MobileNavBarState();
}

class MobileNavBarState extends State<MobileNavBar> {
  int _selectedIndex = 1;
  bool showLineAttend = false;

  String lineLabel = 'Line 1';
  TimerService timerService = TimerService();

  @override
  void initState() {
    super.initState();
    timerService.startTimer();
  }

  static List<Widget> _staticPages = <Widget>[
    MessagesPage(),
    LineStatus(
      onLineSelected: (String selectedLineLabel, int elapsedSeconds) {},
    ),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      showLineAttend = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;

    if (_selectedIndex == 1 && showLineAttend) {
      currentPage = LineAttend(
        lineLabel: lineLabel,
        initialSeconds: timerService.secondsElapsed,
      );
    } else if (_selectedIndex == 1) {
      currentPage = LineStatus(
        onLineSelected: (String selectedLineLabel, int elapsedSeconds) {
          setState(() {
            lineLabel = selectedLineLabel;
            showLineAttend = true;
          });
        },
        initialSeconds: timerService.secondsElapsed,
      );
    } else {
      currentPage = _staticPages[_selectedIndex];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: currentPage,
      ),
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
              color: (_selectedIndex == 1) ? GMCColors.orange : GMCColors.white,
              height: 24,
              width: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'images/person.svg',
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
