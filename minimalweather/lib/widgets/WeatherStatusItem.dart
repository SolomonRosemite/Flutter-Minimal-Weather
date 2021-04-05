import 'package:flutter/material.dart';

class WeatherStatusItem extends StatelessWidget {
  WeatherStatusItem(this.title, this.value);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
          ),
          Text(value, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
