import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minimalweather/models/WeatherInfo.dart';
import 'package:minimalweather/services/WeatherService.dart';
import 'package:minimalweather/services/herlpers.dart';
import 'package:minimalweather/tabs/NextTenDaysTab.dart';
import 'package:minimalweather/tabs/SingleDayTab.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const duration = const Duration(seconds: 1);
  final Color backgroundColor = Helpers.getColorFromDate(DateTime.now());
  Color indicatorColor;
  Color navBarColor;
  Timer timer;

  Future<List<WeatherInfo>> futureweatherInfos;
  // List<WeatherInfo> weatherInfos;
  String time = "";

  @override
  void initState() {
    super.initState();
    futureweatherInfos = WeatherService.fetchWeather(city: "London");

    prepareData();
    setNavBarColor(75);
    setIndicatorColor(125);

    time = Helpers.format(DateTime.now());
    if (timer == null)
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
  }

  void prepareData() {
    // TODO: Fetch data here.
    // weatherInfos = WeatherService.fetchWeather(city: "London");

    // for (var i = 0; i < 10; i++) {
    //   weatherInfos.add(
    //     WeatherInfo(
    //       city: "Seattle",
    //       status: "Clouds",
    //       description: "Few Clouds",
    //       icon: i % 2 == 0 ? "01d" : "01n",
    //       temp: 1,
    //       feelsLike: -1,
    //       tempMax: 5,
    //       tempMin: -2,
    //       sunrise: 1617684053,
    //       sunset: 1617732210,
    //       windSpeed: 3.09,
    //       date: DateTime.now().add(Duration(days: i)),
    //     ),
    //   );
    // }
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
      time = Helpers.format(DateTime.now());
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
                child: GestureDetector(
                  // onTap: () => ,
                  child: Container(
                    child: Text(
                      'Mi. Weather',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
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
                        Icons.search,
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
              Tab(child: Text("Next Week")),
            ],
          ),
        ),
        body: FutureBuilder<List<WeatherInfo>>(
          future: futureweatherInfos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TabBarView(
                children: [
                  SingleDayTab(snapshot.data.first, backgroundColor),
                  SingleDayTab(snapshot.data[1], backgroundColor),
                  NextTenDaysTab(snapshot.data, backgroundColor, navBarColor),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
