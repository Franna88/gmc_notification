import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmc/LineStatus/LineAttend.dart';
import 'package:gmc/LineStatus/LineStatus.dart';
import 'package:gmc/LineStatus/Reuseable/TimeService.dart';
import 'package:gmc/Themes/gmc_colors.dart';

class MobileNavBar extends StatefulWidget {
  const MobileNavBar({super.key});

  @override
  State<MobileNavBar> createState() => MobileNavBarState();
}

class MobileNavBarState extends State<MobileNavBar> {
  int _selectedIndex = 1;

  // Shared state to pass to LineAttend
  String lineLabel = 'Line 1';
  TimerService timerService = TimerService();

  @override
  void initState() {
    super.initState();
    timerService.startTimer();
  }

  static const List<Widget> _staticPages = <Widget>[
    Center(
        child: Text('Messages Page', style: TextStyle(color: GMCColors.white))),
    Center(
        child: Text('Profile Page', style: TextStyle(color: GMCColors.white))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;

    if (_selectedIndex == 1) {
      currentPage = LineStatus(
        onLineSelected: (String selectedLineLabel, int elapsedSeconds) {
          setState(() {
            lineLabel = selectedLineLabel;
            _selectedIndex = 2; // Navigate to LineAttend
          });
        },
        initialSeconds: timerService.secondsElapsed,
      );
    } else if (_selectedIndex == 2) {
      currentPage = LineAttend(
        lineLabel: lineLabel,
        initialSeconds: timerService.secondsElapsed,
      );
    } else {
      currentPage = _staticPages[_selectedIndex];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: currentPage,
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
