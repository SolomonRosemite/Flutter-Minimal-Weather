import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static final _timeFormat = DateFormat('HH:mm');

  static String format(DateTime date, {String formatStr}) {
    if (formatStr != null) {
      return DateFormat(formatStr).format(date);
    }
    return _timeFormat.format(date);
  }

  static Color getColorFromDate(DateTime date) {
    // print(date.hour);
    log(date.hour.toString());

    return const Color.fromARGB(255, 11, 99, 217);
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }
}
