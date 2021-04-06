import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:minimalweather/models/WeatherInfo.dart';
import 'package:minimalweather/models/ChangeLocationResult.dart';
import 'package:minimalweather/services/WeatherService.dart';
import 'package:minimalweather/services/herlpers.dart';
import 'package:minimalweather/tabs/NextWeek.dart';
import 'package:minimalweather/tabs/SingleDayTab.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const duration = const Duration(seconds: 1);
  final Color backgroundColor = Helpers.getColorFromDate(DateTime.now());

  Future<List<WeatherInfo>> futureweatherInfos;

  String city = "Berlin";
  Color indicatorColor;
  Color navBarColor;
  String time = "";
  Timer timer;

  @override
  void initState() {
    super.initState();
    futureweatherInfos = WeatherService.fetchWeather(city: "London");

    setNavBarColor(75);
    setIndicatorColor(125);

    time = Helpers.format(DateTime.now());
    if (timer == null) {
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
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
      time = Helpers.format(DateTime.now());
    });
  }

  Future<ChangeLocationResult> handleChangeLocationClick() async {
    bool didApply = false;
    double opacity = 0;
    String city = "";
    String text = "";
    bool progressIndicatorActive = false;

    await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Location'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Opacity(
                //   opacity: opacity,
                //   child: Text(
                //     'Sorry... the city ' + city + " could not be found.",
                //     style: TextStyle(
                //       color: Colors.red[400],
                //     ),
                //   ),
                // ),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.red[400],
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'London',
                  ),
                  onChanged: (value) {
                    city = value;
                    setState(() {
                      text = "";
                      opacity = 0;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Dismiss',
                style: TextStyle(color: Colors.red[400]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Apply'),
              onPressed: () async {
                if (city.trim().length == 0) {
                  return;
                }
                FocusScope.of(context).unfocus();
                progressIndicatorActive = true;
                GlobalKey _dialogKey = GlobalKey();
                showLoadingDialog(context, _dialogKey);

                if (!await WeatherService.isValidCity(city)) {
                  if (progressIndicatorActive) {
                    Navigator.of(_dialogKey.currentContext, rootNavigator: true).pop();
                    progressIndicatorActive = false;
                  }

                  log("message");
                  setState(() {
                    text = "Sorry... the city " + city + " could not be found.";
                    opacity = 1;
                  });
                  return;
                }

                if (progressIndicatorActive) {
                  Navigator.of(_dialogKey.currentContext, rootNavigator: true).pop();
                  progressIndicatorActive = false;
                }

                didApply = true;

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return ChangeLocationResult(city: city, didApply: didApply);
  }

  showLoadingDialog(BuildContext context, GlobalKey _key) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          key: _key,
          children: [
            Center(
              child: Container(
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    CircularProgressIndicator(
                      backgroundColor: Colors.blue[100],
                      valueColor: AlwaysStoppedAnimation(Colors.blue[800]),
                      strokeWidth: 4,
                    ),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),
                    Text("Please Wait"),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> handleRefresh({String newCity}) async {
    log(newCity);
    city = newCity != null ? newCity : city;
    futureweatherInfos = WeatherService.fetchWeather(city: city);
    await futureweatherInfos;
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: ButtonStyle(),
                          onPressed: handleRefresh,
                          child: Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            var res = await handleChangeLocationClick();
                            if (res.didApply) {
                              handleRefresh(newCity: res.city);
                            }
                          },
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
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
              return RefreshIndicator(
                onRefresh: () async => await handleRefresh(),
                child: TabBarView(
                  children: [
                    SingleDayTab(snapshot.data.first, backgroundColor),
                    SingleDayTab(snapshot.data[1], backgroundColor),
                    NextWeek(snapshot.data, backgroundColor, navBarColor),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
