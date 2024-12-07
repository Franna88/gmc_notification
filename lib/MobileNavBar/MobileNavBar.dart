import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmc/LineStatus/LineAttend.dart';
import 'package:gmc/LineStatus/LineStatus.dart';
import 'package:gmc/LineStatus/Reuseable/UniversalTimer.dart';
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
  String documentId = '';
  final UniversalTimer universalTimer = UniversalTimer();

  // Add PageController to manage page switching
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Initialize the PageController
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index != 1) {
        showLineAttend = false;
      }
    });
    _pageController.jumpToPage(index);
  }

  void _onLineSelected(
      String selectedLineLabel, int elapsedSeconds, String lineId) {
    setState(() {
      // Store the current elapsed time before switching pages
      if (documentId.isNotEmpty) {
        TimerService currentTimer = universalTimer.getTimerForLine(documentId);
        currentTimer.setElapsedTime(currentTimer.secondsElapsed);
      }

      lineLabel = selectedLineLabel;
      documentId = lineId;
      showLineAttend = true;

      TimerService timerService = universalTimer.getTimerForLine(documentId);

      // Restore the elapsed time (if needed)
      timerService.setElapsedTime(elapsedSeconds);
    });

    // Navigate to the LineAttend page
    _pageController.jumpToPage(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics:
            const NeverScrollableScrollPhysics(), // Prevent swipe navigation
        children: [
          // MessagesPage
          const MessagesPage(),
          // LineStatus Page
          LineStatus(
            onLineSelected: _onLineSelected,
          ),
          // ProfilePage
          const ProfilePage(),
          // LineAttend Page
          LineAttend(
            lineLabel: lineLabel,
            documentId: documentId,
            timerService: universalTimer
                .getTimerForLine(documentId), // Get the TimerService instance
          ),
        ],
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
