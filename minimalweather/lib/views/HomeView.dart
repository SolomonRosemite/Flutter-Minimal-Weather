import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:minimalweather/models/WeatherInfo.dart';
import 'package:minimalweather/models/ChangeLocationResult.dart';
import 'package:minimalweather/services/SharedPreferencesService.dart';
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

  Color indicatorColor;
  Color navBarColor;
  String time = "";
  Timer timer;
  bool visable = false;

  @override
  void initState() {
    super.initState();
    futureweatherInfos = fetchWeather();

    setNavBarColor(75);
    setIndicatorColor(125);

    time = Helpers.format(DateTime.now());
    if (timer == null) {
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
    }
  }

  Future<List<WeatherInfo>> fetchWeather() async {
    await SharedPreferencesService.initialize();

    final city = SharedPreferencesService.getCity();
    final lat = SharedPreferencesService.getLatitude() ?? -1;
    final lon = SharedPreferencesService.getLongitude() ?? -1;

    return WeatherService.fetchWeather(city: city, lat: lat, lon: lon);
  }

  final snackBarFetchingMessage = SnackBar(
    // duration: const Duration(seconds: 1),
    content: Text('Fetching new data'),
    action: SnackBarAction(label: 'Ok!', onPressed: () {}),
  );

  SnackBar get snackBarFetchCompleteMessage => SnackBar(
        content: Text(
          'Updated!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: navBarColor,
      );

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
    String city = "";
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
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Example: London',
                  ),
                  onChanged: (value) {
                    city = value;
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

                final result = await WeatherService.isValidCity(city);

                if (!result.isvalid) {
                  if (progressIndicatorActive) {
                    Navigator.of(_dialogKey.currentContext, rootNavigator: true).pop();
                    progressIndicatorActive = false;
                  }

                  showErrorDialog(city);
                  return;
                }

                SharedPreferencesService.setCity(city);
                SharedPreferencesService.setLatitude(result.lat);
                SharedPreferencesService.setLongitude(result.lon);

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

  void showErrorDialog(String cityname) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Sorry the city $cityname could not be found.'),
          title: Text('Could not find city'),
          content: Text('The City "$cityname" could not be found.'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: Colors.red[400]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    final city = newCity != null ? newCity : SharedPreferencesService.getCity();
    log(city);

    ScaffoldMessenger.of(context).showSnackBar(snackBarFetchingMessage);

    futureweatherInfos = WeatherService.fetchWeather(city: city);
    await futureweatherInfos;

    ScaffoldMessenger.of(context).showSnackBar(snackBarFetchCompleteMessage);
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
              // log("here");
              new Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  visable = true;
                });
              });
              return AnimatedOpacity(
                opacity: visable ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
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
