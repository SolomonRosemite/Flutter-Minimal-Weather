import 'package:flutter/material.dart';
import 'package:minimalweather/models/WeatherInfo.dart';

class TodayTab extends StatelessWidget {
  TodayTab(this.weatherInfo, this.backgroundColor);
  final WeatherInfo weatherInfo;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Icon(Icons.directions_car),
    );
  }
}
