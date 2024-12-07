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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "images/GMC_Logo_White_Background_Black_Text 1.png",
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Tab Bar
          Container(
            decoration: const BoxDecoration(
              color: GMCColors.darkGrey, // Background color for the TabBar
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), // Rounded top left corner
                topRight: Radius.circular(12), // Rounded top right corner
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

          // Grey Container with Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Messages Tab Content
                const MessagesTab(),

                // Contacts Tab Content
                const ContactTab(),
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
