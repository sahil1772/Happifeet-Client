import 'package:flutter/material.dart';

class CalendarUtils {
  static showPicker(
      {required BuildContext context,DateTime? selectedStartDate}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate??DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));

    return picked;
  }
}
