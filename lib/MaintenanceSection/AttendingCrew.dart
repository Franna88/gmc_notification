import 'package:flutter/material.dart';
import 'package:gmc/MaintenanceSection/Reuseable/CrewContainer.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendingCrew extends StatefulWidget {
  const AttendingCrew({super.key});

  @override
  State<AttendingCrew> createState() => _AttendingCrewState();
}

class _AttendingCrewState extends State<AttendingCrew> {
  final List<Map<String, String>> crewMembers = [
    {
      'name': 'Alec Whitten',
      'position': 'Production Manager',
      'imageUrl': 'images/Profile1.png'
    },
    {
      'name': 'Sarah Johnson',
      'position': 'Maintenance Supervisor',
      'imageUrl': 'images/Profile1.png'
    },
    {
      'name': 'Mike Chen',
      'position': 'Technical Specialist',
      'imageUrl': 'images/Profile1.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF37414A),
            width: 1,
          ),
          color: Colors.white),
      child: Column(
        children: [
          // Top section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF242728),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attending Crew',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFF6A707),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF429033).withOpacity(0.81),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Assist',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: crewMembers.length,
              itemBuilder: (context, index) {
                return CrewContainer(
                  name: crewMembers[index]['name']!,
                  position: crewMembers[index]['position']!,
                  imageUrl: crewMembers[index]['imageUrl']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
