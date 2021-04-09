import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:minimalweather/models/IsValidCityResponse.dart';
import 'package:minimalweather/models/WeatherInfo.dart';

class WeatherService {
  static const String _endPoint = 'https://api.rosemite.cf/weather';

  static Future<http.Response> _fetchWeather({String city, double lat, double lon}) {
    log("Lat: " + lat.toString());
    log("Lat: " + lon.toString());
    return http.get(
      _endPoint,
      headers: {
        // "accesskey": Credentials.rosemiteAccessKey,
        "city": city,
        "lat": lat == null || lat == -1 ? "" : lat.toString(),
        "lon": lon == null || lon == -1 ? "" : lon.toString(),
      },
    );
  }

  static Future<List<WeatherInfo>> fetchWeather({@required String city, double lat, double lon}) async {
    final response = await _fetchWeather(city: city, lat: lat, lon: lon);
    List<WeatherInfo> res = [];

    final map = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<dynamic> weatherStatuses = map["daily"];

      res.add(WeatherInfo.fromJsonCurrent(map["current"], weatherStatuses[0], city));

      for (var i = 1; i < weatherStatuses.length; i++) {
        res.add(WeatherInfo.fromJson(weatherStatuses[i], city));
      }
      // for (var item in map["daily"]) {
      //   res.add(WeatherInfo.fromJson(item, city));
      // }
      return res;
    } else {
      try {
        log(response.statusCode.toString());
      } catch (e) {}
      throw Exception('Failed to load weather');
    }
  }

  static Future<http.Response> _fetchSingleWeather(String city) {
    return http.get(
      _endPoint,
      headers: {
        "city": city,
        "type": "single",
      },
    );
  }

  static Future<IsValidCityResponse> isValidCity(String city) async {
    final response = await _fetchSingleWeather(city);

    final isVaild = response.statusCode == 200;

    if (isVaild) {
      final map = jsonDecode(response.body);

      final lat = map["coord"]["lat"].toDouble();
      final lon = map["coord"]["lon"].toDouble();

      return IsValidCityResponse(lat: lat, lon: lon, isvalid: isVaild);
    }

    return IsValidCityResponse(isvalid: isVaild);
  }
}
