import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MaintenanceMessage extends StatelessWidget {
  final VoidCallback onPressed;

  const MaintenanceMessage({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF242728),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          'images/Chat.svg',
          colorFilter: const ColorFilter.mode(
            Color(0xFF25CFA2),
            BlendMode.srcIn,
          ),
          height: 32,
        ),
        onPressed: onPressed,
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
