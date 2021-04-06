import 'dart:async';
import 'package:flutter/material.dart';
import 'package:minimalweather/models/WeatherInfo.dart';
import 'package:minimalweather/services/Herlpers.dart';
import 'package:minimalweather/tabs/SingleDayTab.dart';

class SingleWeatherView extends StatefulWidget {
  SingleWeatherView(this.backgroundColor, this.navBarColor, this.weatherInfo);
  final WeatherInfo weatherInfo;
  final Color backgroundColor;
  final Color navBarColor;

  @override
  _SingleWeatherViewState createState() => _SingleWeatherViewState();
}

class _SingleWeatherViewState extends State<SingleWeatherView> {
  static const duration = const Duration(seconds: 1);
  String time = "";
  Timer timer;

  @override
  void initState() {
    super.initState();

    time = Helpers.format(DateTime.now());
    if (timer == null) {
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    timer.cancel();
  }

  void handleTick() {
    setState(() {
      time = Helpers.format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.navBarColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                SizedBox(width: 15),
                Icon(Icons.arrow_back),
                SizedBox(width: 10)
              ],
            ),
          ),
        ),
        leadingWidth: 90,
        automaticallyImplyLeading: false,
        title: Container(
          child: Row(
            children: [
              Spacer(),
              Center(child: Text(time, style: TextStyle(fontSize: 14))),
              Spacer(),
              SizedBox(width: 90),
            ],
          ),
        ),
      ),
      body: SingleDayTab(widget.weatherInfo, widget.backgroundColor),
    );
  }
}
