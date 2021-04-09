import 'package:flutter/services.dart';
import 'package:minimalweather/views/HomeView.dart';
import 'package:flutter/material.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      // statusBarColor: Color(0xFFdde6e8),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //       // statusBarColor: Colors.black,
  //       ),
  // );
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
