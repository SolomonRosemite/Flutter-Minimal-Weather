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

  static String getUsergreeting() {
    final h = DateTime.now().hour;

    if (h > 4 && h <= 12) {
      return "Beautiful Morning";
    } else if (h > 12 && h <= 20) {
      return "Beautiful Evening";
    }

    return "Good Night";
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this.split(" ").map((str) => str.inCaps).join(" ");
}
