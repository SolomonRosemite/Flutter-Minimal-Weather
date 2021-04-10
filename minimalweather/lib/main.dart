import 'package:flutter/services.dart';
import 'package:minimalweather/views/HomeView.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimal Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "ZURCHN",
      ),
      home: HomeView(),
    );
  }
}
