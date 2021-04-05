import 'package:flutter/material.dart';

// https://openweathermap.org/weather-conditions
// api.openweathermap.org/data/2.5/weather?q={city}&appid={api key}&units=metric
class WeatherInfo {
  final String city;
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
  });
}
