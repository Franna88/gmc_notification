import 'package:flutter/material.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/Themes/text_styles.dart';
import 'package:gmc/myutility.dart'; // Ensure this path is correct

class ReusableMessageNotification extends StatelessWidget {
  final String title;
  final String dateTime;
  final String description;

  const ReusableMessageNotification({
    Key? key,
    required this.title,
    required this.dateTime,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text(title,
                  style: TextStyles(context)
                      .bold
                      .copyWith(color: GMCColors.darkGrey)),
              Text(
                dateTime,
                style: TextStyles(context)
                    .bodySmall
                    .copyWith(color: GMCColors.orange),
              ),
            ],
          ),
          const SizedBox(height: 8), // Space between title/date and description
          Text(
            description,
            style: TextStyles(context)
                .bodySmall
                .copyWith(color: GMCColors.darkGrey),
          ),
        ],
      ),
    );
  }
}
