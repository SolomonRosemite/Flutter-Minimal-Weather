import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimalweather/models/WeatherInfo.dart';
import 'package:minimalweather/tabs/NextTenDaysTab.dart';
import 'package:minimalweather/tabs/TodayTab.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const duration = const Duration(seconds: 1);
  // final Color backgroundColor = Colors.blue[400];
  final Color backgroundColor = Color.fromARGB(255, 8, 90, 198);
  Color indicatorColor;
  Color navBarColor;
  Timer timer;

  final timeFormat = new DateFormat('HH:mm');
  String time = "";

  List<WeatherInfo> weatherInfos;

  @override
  void initState() {
    super.initState();

    prepareData();
    setNavBarColor(75);
    setIndicatorColor(125);

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
      weatherInfos.add(
        WeatherInfo(
          city: "Seattle",
          status: "Clouds",
          description: "Few Clouds",
          icon: "03n",
          temp: 1,
          feelsLike: -1,
          tempMax: 5,
          tempMin: -2,
          sunrise: 1617597836,
          sunset: 1617645757,
          windSpeed: 3.09,
        ),
      );
    }
  }

  void setNavBarColor(final int p) {
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

  void setIndicatorColor(final int p) {
    final red = ((backgroundColor.red * p) / 100);
    final green = (backgroundColor.green * p) / 100;
    final blue = (backgroundColor.blue * p) / 100;

    if (red > 255 || green > 255 || blue > 255) {
      setIndicatorColor(p - 10);
      return;
    }

    indicatorColor = Color.fromARGB(
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
            indicatorColor: indicatorColor,
            tabs: [
              Tab(child: Text("Today")),
              Tab(child: Text("Tomorrow")),
              Tab(child: Text("10 Days")),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleDayTab(weatherInfos.first, backgroundColor),
            SingleDayTab(weatherInfos[1], backgroundColor),
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
