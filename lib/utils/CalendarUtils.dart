import 'package:flutter/material.dart';

class CalendarUtils {
  static showDatePicker(
      {required BuildContext context,
      required initialDate,
      required DateTime firstDate,
      required DateTime lastDate}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
  }
}
