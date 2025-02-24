import 'package:flutter/material.dart';
import 'package:gmc/myutility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class MaintenanceContainer extends StatefulWidget {
  final bool isInMaintenance;
  final String operationNumber;
  final String operationName;
  final String? scheduledMaintenanceTime;
  final Duration maintenanceTimer;
  final VoidCallback? onTap;
  final String documentId;

  const MaintenanceContainer({
    super.key,
    this.isInMaintenance = false,
    required this.operationNumber,
    required this.operationName,
    this.scheduledMaintenanceTime,
    this.maintenanceTimer = Duration.zero,
    this.onTap,
    required this.documentId,
  });

  @override
  State<MaintenanceContainer> createState() => _MaintenanceContainerState();
}

class _MaintenanceContainerState extends State<MaintenanceContainer> {
  bool isOnline = true;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    if (widget.operationNumber == "OP 30.2") {
      _listenToOnlineStatus();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _listenToOnlineStatus() {
    final systemsRef = FirebaseFirestore.instance.collection('systems');
    _subscription = systemsRef
        .doc(widget.documentId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          isOnline = data['online'] ?? true;
        });
      }
    });
  }

  String get elapsedTime {
    final minutes = widget.maintenanceTimer.inMinutes;
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool showOffline = widget.operationNumber == "OP 30.2" && !isOnline;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: MyUtility(context).height * 0.09,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${widget.operationNumber} - ',
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            widget.operationName,
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.isInMaintenance
                                ? 'Maintenance'
                                : (showOffline ? 'Offline' : 'Online'),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: showOffline ? Colors.red : null,
                            ),
                          ),
                          if (widget.isInMaintenance)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF252728),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                child: Text(
                                  elapsedTime,
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ),
                            )
                          else if (widget.scheduledMaintenanceTime != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF252728),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.build,
                                      size: 18,
                                      color: const Color(0xFFF29D4E),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Scheduled Maintenance at ...',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.scheduledMaintenanceTime!,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFFF68D2B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 18,
                decoration: BoxDecoration(
                  color: showOffline
                      ? Colors.red
                      : (widget.isInMaintenance
                          ? const Color(0xFFF29D4E)
                          : const Color(0xFF639847)),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
