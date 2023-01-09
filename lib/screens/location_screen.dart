import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';

class LocationScreen extends StatefulWidget {

  final locationWeather;
  LocationScreen(this.locationWeather);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  WeatherModel weatherModel = WeatherModel();

  String weatherIcon;
  int temperature;
  String city;
  String message;

  @override
  void initState() {
    super.initState();
    updateUi(widget.locationWeather);
  }

  void updateUi(dynamic weatherData){
    setState(() {
      if(weatherData == null){
        temperature = 0;
        weatherIcon = 'ERROR';
        message = 'Can\'t detect';
        city = '';
        return;
      }

      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weatherModel.getWeatherIcon(condition);
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      city = weatherData['name'];

      message = weatherModel.getMessage(temperature);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: ()async {
                      var weatherD =await weatherModel.getLocationWeather();
                      updateUi(weatherD);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: ()async {
                      var typeName = await Navigator.pushNamed(context, '/city');
                      if(typeName != null){
                        var weatherData = await weatherModel.getCityWeather(typeName);
                        updateUi(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$message in $city!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


