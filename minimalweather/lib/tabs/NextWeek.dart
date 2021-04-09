import 'package:flutter/material.dart';
import 'package:minimalweather/models/WeatherInfo.dart';
import 'package:minimalweather/services/Herlpers.dart';
import 'package:minimalweather/views/SingleWeatherView.dart';

class NextWeek extends StatelessWidget {
  NextWeek(this.weatherInfos, this.backgroundColor, this.navBarColor);
  final Color navBarColor;
  static const String path = "assets/images/";
  final List<WeatherInfo> weatherInfos;
  final Color backgroundColor;

  void handleWeatherClick(final WeatherInfo info, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SingleWeatherView(backgroundColor, navBarColor, info)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: weatherInfos.length,
        itemBuilder: (context, index) {
          return Container(
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(Colors.black),
              ),
              onPressed: () => handleWeatherClick(weatherInfos[index], context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Center(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            weatherInfos[index].date.isSameDate(DateTime.now()) ? "Today" : Helpers.format(weatherInfos[index].date, formatStr: "EEEE, d. MMM."),
                          ),
                          Text(weatherInfos[index].description.capitalizeFirstofEach),
                        ],
                      ),
                      Spacer(),
                      Image.asset(
                        path + weatherInfos[index].icon + ".png",
                        width: 30,
                        height: 30,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          Text(weatherInfos[index].tempMax.round().toString() + "°"),
                          Text(weatherInfos[index].tempMin.round().toString() + "°"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
