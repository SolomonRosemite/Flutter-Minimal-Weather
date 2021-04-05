import 'package:flutter/material.dart';
import 'package:minimalweather/models/WeatherInfo.dart';

class NextTenDaysTab extends StatelessWidget {
  NextTenDaysTab(this.weatherInfos, this.backgroundColor);
  final List<WeatherInfo> weatherInfos;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
    );
  }
}
