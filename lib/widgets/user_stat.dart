import 'package:chat_app/utils/colors.dart';
import 'package:flutter/material.dart';

class UserStat extends StatelessWidget {
  final int value;
  final String label;

  const UserStat({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
              color: primaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w400, color: hintTextColor),
        )
      ],
    );
  }
}
