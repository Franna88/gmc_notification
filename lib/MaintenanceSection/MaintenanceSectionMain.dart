import 'package:flutter/material.dart';
import 'package:gmc/MaintenanceSection/AttendingCrew.dart';
import 'package:gmc/MaintenanceSection/DownTime.dart';
import 'package:gmc/MaintenanceSection/MaintancenceinProgress.dart';
import 'package:gmc/MaintenanceSection/Reuseable/MaintenanceFaultContainer.dart';
import 'package:gmc/MaintenanceSection/Reuseable/MaintenanceMessage.dart';
import 'package:gmc/MaintenanceSection/Reuseable/ReportButton.dart';
import 'package:gmc/Themes/gmc_colors.dart';

class MaintenanceSectionMain extends StatefulWidget {
  const MaintenanceSectionMain({super.key});

  @override
  State<MaintenanceSectionMain> createState() => _MaintenanceSectionMainState();
}

class _MaintenanceSectionMainState extends State<MaintenanceSectionMain> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "images/Antolin.png",
            ),
            MaintancenceinProgress(
              sectionNumber: "OP 50",
              sectionName: "Robotic water jet cutting",
            ),
            DownTime(
              elapsedTime: "10:00",
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReportButton(
                    onPressed: () {},
                  ),
                  MaintenanceMessage(
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: GMCColors.lightGrey,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, -4),
                    blurRadius: 4.0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    MaintenanceFaultContainer(
                      faultLocation: "OP 50 - Robotic water jet cutting",
                      faultCause: "Water Leak Detected",
                      image: Image.asset("images/waterpipe.png"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AttendingCrew(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
