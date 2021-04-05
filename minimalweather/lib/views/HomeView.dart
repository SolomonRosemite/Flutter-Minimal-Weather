import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimalweather/models/WeatherInfo.dart';
import 'package:minimalweather/tabs/NextTenDaysTab.dart';
import 'package:minimalweather/tabs/TodayTab.dart';
import 'package:minimalweather/tabs/TomorrowTab.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const duration = const Duration(seconds: 1);
  final Color backgroundColor = Colors.blue[400];
  Color navBarColor;
  Timer timer;

  final timeFormat = new DateFormat('hh:mm');
  String time = "";

  List<WeatherInfo> weatherInfos;

  @override
  void initState() {
    super.initState();

    prepareData();
    setNavBarColor();

    time = timeFormat.format(new DateTime.now());
    if (timer == null)
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
  }

  void prepareData() {
    // TODO: Fetch data here.
    weatherInfos = [];

    for (var i = 0; i < 10; i++) {
      weatherInfos.add(WeatherInfo());
    }
  }

  void setNavBarColor() {
    final p = 75;

    final red = ((backgroundColor.red * p) / 100);
    final green = (backgroundColor.green * p) / 100;
    final blue = (backgroundColor.blue * p) / 100;

    navBarColor = Color.fromARGB(
      255,
      red.round(),
      green.round(),
      blue.round(),
    );
  }

  void handleTick() {
    setState(() {
      time = timeFormat.format(new DateTime.now());
    });
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: navBarColor,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Expanded(
                child: Text('Mi. Weather', style: TextStyle(fontSize: 14)),
              ),
              Center(
                child: Text(time, style: TextStyle(fontSize: 14)),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: TextButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottom: TabBar(
            tabs: [
              Tab(child: Text("Today")),
              Tab(child: Text("Tomorrow")),
              Tab(child: Text("Next 10 Days")),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TodayTab(weatherInfos.first, backgroundColor),
            TomorrowTab(weatherInfos[1], backgroundColor),
            NextTenDaysTab(weatherInfos, backgroundColor),
          ],
        ),
        // bottomNavigationBar: TabBar(
        //   labelColor: Colors.red,
        //   overlayColor: MaterialStateProperty.all(Colors.blue),
        //   tabs: [
        //     Tab(child: Text("Today")),
        //     Tab(child: Text("Tomorrow")),
        //     Tab(child: Text("Next 10 Days")),
        //   ],
        // ),
      ),
    );
  }
}
