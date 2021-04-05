import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimalweather/models/WeatherInfo.dart';
import 'package:minimalweather/views/HomeView.dart';
import 'package:minimalweather/widgets/WeatherStatusItem.dart';

class SingleDayTab extends StatelessWidget {
  SingleDayTab(this.weatherInfo, this.backgroundColor);

  final timeFormat = new DateFormat('HH:mm');
  final WeatherInfo weatherInfo;
  final Color backgroundColor;

  String getSunRiseValue(int timestamp) {
    final value = DateTime.fromMicrosecondsSinceEpoch(timestamp);
    return timeFormat.format(value).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(weatherInfo.city, style: TextStyle(color: Colors.white, fontSize: 40)),
            ),
          ),
          SizedBox(height: 25),
          Text("a", style: TextStyle(fontFamily: "artill", color: Colors.white, fontSize: 80)),
          Text(weatherInfo.temp.round().toString() + "°", style: TextStyle(color: Colors.white, fontSize: 45)),
          SizedBox(height: 20),
          Text(
            // "Doood, I'm freezing bruv",
            // "Kinda freezing out here",
            // "Good night",
            "Good night".toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              // fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Column(
                  children: [
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WeatherStatusItem("Sunrise", getSunRiseValue(weatherInfo.sunrise)),
                        WeatherStatusItem("Wind Speed", weatherInfo.windSpeed.toString() + "m/s"),
                        WeatherStatusItem("Sunset", getSunRiseValue(weatherInfo.sunset)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
