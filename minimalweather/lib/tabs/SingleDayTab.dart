import 'package:minimalweather/widgets/WeatherStatusItem.dart';
import 'package:minimalweather/models/WeatherInfo.dart';
import 'package:minimalweather/services/herlpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleDayTab extends StatelessWidget {
  SingleDayTab(this.weatherInfo, this.backgroundColor);

  final WeatherInfo weatherInfo;
  final Color backgroundColor;
  final String path = "assets/images/";

  String fromTimestampToTime(int timestamp) {
    final value = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
    return Helpers.format(value);
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
              child: Text(weatherInfo.city, style: TextStyle(color: Colors.white, fontSize: 35)),
            ),
          ),
          Text(
            DateFormat("d EEEE MMMM").format(weatherInfo.date),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 45),
          Image.asset(
            path + weatherInfo.icon + ".png",
            width: 115,
            height: 115,
            color: Colors.white,
          ),
          SizedBox(height: 35),
          Text(
            weatherInfo.temp.round().toString() + "°",
            style: TextStyle(color: Colors.white, fontSize: 45, fontFamily: "Roboto"),
          ),
          SizedBox(height: 20),
          Text(
            // "Good night".toUpperCase(),
            // "Beautiful Evening".toUpperCase(),
            "Beautiful Evening",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
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
                        WeatherStatusItem("Sunrise", fromTimestampToTime(weatherInfo.sunrise)),
                        WeatherStatusItem("Wind Speed", weatherInfo.windSpeed.toString() + "m/s"),
                        WeatherStatusItem("Sunset", fromTimestampToTime(weatherInfo.sunset)),
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
