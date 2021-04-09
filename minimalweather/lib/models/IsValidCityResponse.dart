import 'package:flutter/cupertino.dart';

class IsValidCityResponse {
  final double lat;
  final double lon;
  final bool isvalid;

  IsValidCityResponse({this.lat, this.lon, @required this.isvalid});
}
