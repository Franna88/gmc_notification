import 'package:flutter/material.dart';
import 'package:gmc/Maintenance/LineSectionContainer.dart';
import 'package:gmc/Maintenance/MaintenanceContainer.dart';
import 'package:gmc/MaintenanceSection/MaintenanceSectionMain.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';

class MaintenanceHome extends StatefulWidget {
  final PageController pageController;
  final String lineLabel;
  final String documentId;

  const MaintenanceHome({
    super.key,
    required this.pageController,
    required this.lineLabel,
    required this.documentId,
  });

  @override
  State<MaintenanceHome> createState() => _MaintenanceHomeState();
}

class _MaintenanceHomeState extends State<MaintenanceHome> {
  void _navigateToMaintenanceSection() {
    widget.pageController.jumpToPage(6); // Index 6 for MaintenanceSectionMain
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Image.asset(
            "images/Antolin.png",
          ),
          LineSectionContainer(
            leftText: widget.lineLabel,
            rightText: "Roof Lining Merge",
          ),
          Expanded(
            child: Container(
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
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  MaintenanceContainer(
                    isInMaintenance: true,
                    operationNumber: "OP 30.1",
                    operationName: "Press Left",
                    maintenanceTimer: const Duration(seconds: 45),
                    onTap: _navigateToMaintenanceSection,
                    documentId: widget.documentId,
                  ),
                  const SizedBox(height: 8),
                  MaintenanceContainer(
                    isInMaintenance: false,
                    operationNumber: "OP 30.2",
                    operationName: "Press Right",
                    scheduledMaintenanceTime: "14:30",
                    onTap: _navigateToMaintenanceSection,
                    documentId: widget.documentId,
                  ),
                  const SizedBox(height: 8),
                  MaintenanceContainer(
                    isInMaintenance: false,
                    operationNumber: "OP 30.3",
                    operationName: "Press Left",
                    onTap: _navigateToMaintenanceSection,
                    documentId: widget.documentId,
                  ),
                  const SizedBox(height: 8),
                  MaintenanceContainer(
                    isInMaintenance: false,
                    operationNumber: "OP 30.4",
                    operationName: "Press Right",
                    onTap: _navigateToMaintenanceSection,
                    documentId: widget.documentId,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
