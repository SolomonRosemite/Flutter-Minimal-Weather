import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:minimalweather/credentials.dart';
import 'package:minimalweather/models/WeatherInfo.dart';

class WeatherService {
  static const String endPoint = 'https://api.rosemite.cf/weather';

  static Future<http.Response> _fetchWeather({String city, String lat, String lon}) {
    return http.get(
      endPoint,
      headers: {
        "accesskey": Credentials.rosemiteAccessKey,
        "city": city,
        "lat": lat,
        "lon": lon,
      },
    );
  }

  Future<WeatherInfo> fetchWeather({@required String city, String lat, String lon}) async {
    final response = await _fetchWeather(city: city, lat: lat, lon: lon);

    if (response.statusCode == 200) {
      return WeatherInfo.fromJson(jsonDecode(response.body), city);
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
