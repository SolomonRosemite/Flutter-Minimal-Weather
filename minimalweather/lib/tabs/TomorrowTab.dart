import 'package:flutter/material.dart';
import 'package:minimalweather/models/WeatherInfo.dart';

class TomorrowTab extends StatelessWidget {
  TomorrowTab(this.weatherInfos, this.backgroundColor);
  final WeatherInfo weatherInfos;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Text(
          "a",
          style: TextStyle(fontFamily: "artill", color: Colors.black, fontSize: 200),
        ),
      ),
    );
  }
}
