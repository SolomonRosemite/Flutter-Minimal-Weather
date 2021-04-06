import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:minimalweather/models/WeatherInfo.dart';
import 'package:minimalweather/services/Herlpers.dart';

class NextTenDaysTab extends StatelessWidget {
  NextTenDaysTab(this.weatherInfos, this.backgroundColor);
  final List<WeatherInfo> weatherInfos;
  static const String path = "assets/images/";
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: weatherInfos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(Colors.black),
              ),
              onPressed: () {},
              child: Center(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weatherInfos[index].date.isSameDate(DateTime.now()) ? "Today" : Helpers.format(weatherInfos[index].date, formatStr: "EEEE, d. MMM."),
                        ),
                        Text(weatherInfos[index].description),
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
          );
        },
      ),
    );
  }
}
