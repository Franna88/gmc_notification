import 'package:flutter/material.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/Themes/text_styles.dart';
import 'package:gmc/myutility.dart';

class ReusableMessageNotification extends StatelessWidget {
  final String title;
  final String dateTime;
  final String description;
  final VoidCallback onPressed;
  final TextStyle? titleStyle; // Optional custom style for the title

  const ReusableMessageNotification({
    super.key,
    required this.title,
    required this.dateTime,
    required this.description,
    required this.onPressed,
    this.titleStyle, // Accept optional titleStyle
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: MyUtility(context).width * 0.8,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: GMCColors.darkGrey), // Dark grey border
            borderRadius: BorderRadius.circular(8), // Optional: rounded corners
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: titleStyle ??
                        TextStyles(context).bold.copyWith(
                            color: GMCColors.darkGrey), // Default style
                  ),
                  Text(
                    dateTime,
                    style: TextStyles(context)
                        .bodySmall
                        .copyWith(color: GMCColors.orange),
                  ),
                ],
              ),
              const SizedBox(
                  height: 8), // Space between title/date and description
              Text(
                description,
                style: TextStyles(context)
                    .bodySmall
                    .copyWith(color: GMCColors.darkGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
