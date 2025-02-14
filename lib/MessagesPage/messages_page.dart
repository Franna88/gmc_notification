import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmc/MessagesPage/contact_tab.dart';
import 'package:gmc/MessagesPage/messages_tab.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String activeTab = 'Messages'; // Default active tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "images/GMC_Logo_White_Background_Black_Text 1.png",
                  height: 40,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tab Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 48,
              decoration: const BoxDecoration(
                color: GMCColors.darkGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  setState(() {
                    activeTab = index == 0 ? 'Messages' : 'Contacts';
                  });
                },
                tabs: [
                  // Messages Tab
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'images/Chat.svg', // Path to your SVG file
                            height: 24, // Adjust the size as needed
                            width: 24, // Adjust the size as needed
                            color: GMCColors
                                .white, // Apply color to match the text color
                          ),
                          const Spacer(),
                          const Text(
                            'Messages',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: GMCColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Contacts Tab
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'images/person.svg', // Path to your SVG file
                            height: 24, // Adjust the size as needed
                            width: 24, // Adjust the size as needed
                            color: GMCColors
                                .white, // Apply color to match the text color
                          ),
                          const Spacer(),
                          const Text(
                            'Contacts',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: GMCColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                labelColor: GMCColors.white, // Text color for selected tab
                unselectedLabelColor:
                    Colors.black, // Text color for unselected tabs
                indicator: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10), // Rounded top left corner
                    topRight: Radius.circular(10), // Rounded top right corner
                  ),
                  color: GMCColors.orange, // Indicator color
                ),
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
          ),

          // Tab View Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                MessagesTab(),
                ContactTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
