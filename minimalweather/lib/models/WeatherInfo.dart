import 'package:flutter/material.dart';

// https://openweathermap.org/weather-conditions
class WeatherInfo {
  final String city; // Hamburg
  final String status; // Clouds, Rain, ...
  final String description; // scattered clouds, ...
  final String icon; // 03n
  final double temp; // 2
  final double tempMin; // -1.2
  final double tempMax; // 5
  final double feelsLike; // -2
  final int sunrise; // 1617597836
  final int sunset; // 1617645757
  final double windSpeed; // 3.09 m/s
  final DateTime date; // Date

  factory WeatherInfo.fromJson(Map<String, dynamic> json, String city) {
    return WeatherInfo(
      city: city,
      date: DateTime.fromMillisecondsSinceEpoch(json["dt"] * 1000),
      description: json["weather"][0]["description"],
      feelsLike: json["feels_like"]["day"].toDouble(),
      icon: json["weather"][0]["icon"],
      status: json["weather"][0]["main"],
      sunrise: json["sunrise"],
      sunset: json["sunset"],
      temp: json["temp"]["day"].toDouble(),
      tempMax: json["temp"]["max"].toDouble(),
      tempMin: json["temp"]["min"].toDouble(),
      windSpeed: json["wind_speed"].toDouble(),
    );
  }

  WeatherInfo({
    @required this.city,
    @required this.status,
    @required this.description,
    @required this.icon,
    @required this.temp,
    @required this.tempMax,
    @required this.tempMin,
    @required this.feelsLike,
    @required this.sunrise,
    @required this.sunset,
    @required this.windSpeed,
    @required this.date,
  });
}
