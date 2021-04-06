import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:minimalweather/credentials.dart';
import 'package:minimalweather/models/WeatherInfo.dart';

class WeatherService {
  static const String _endPoint = 'https://api.rosemite.cf/weather';

  static Future<http.Response> _fetchWeather({String city, String lat, String lon}) {
    return http.get(
      _endPoint,
      headers: {
        "accesskey": Credentials.rosemiteAccessKey,
        "city": city,
        "lat": lat == null ? "" : lat,
        "lon": lon == null ? "" : lon,
      },
    );
  }

  static Future<List<WeatherInfo>> fetchWeather({@required String city, String lat, String lon}) async {
    final response = await _fetchWeather(city: city, lat: lat, lon: lon);
    List<WeatherInfo> res = [];

    final map = jsonDecode(response.body);

    if (response.statusCode == 200) {
      for (var item in map["daily"]) {
        res.add(WeatherInfo.fromJson(item, city));
      }
      return res;
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
