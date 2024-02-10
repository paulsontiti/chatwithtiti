import 'package:chat_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PublishedDate extends StatelessWidget {
  final DateTime date;
  const PublishedDate({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat.yMEd().add_Hms().format(date),
      style: const TextStyle(color: hintTextColor),
    );
  }
}
