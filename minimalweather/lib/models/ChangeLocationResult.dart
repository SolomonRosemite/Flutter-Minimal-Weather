import 'package:flutter/material.dart';

class ChangeLocationResult {
  final bool didApply;
  final String city;

  ChangeLocationResult({@required this.city, @required this.didApply});
}
