import 'package:flutter/material.dart';
import 'package:flutter_weather_app/weather/weather.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService("");
  Weather? _weather;

  //fetch weather detail
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();
    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
      //if any errors
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    //by default show sunny animation
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Column(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: Colors.redAccent,
                  size: 40,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  _weather?.cityName ?? "loading",
                  style: TextStyle(fontSize: 25, color: Colors.grey[800]),
                ),
              ],
            ),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            //temp
            Text(
              '${_weather?.temperature.round()}°C',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),

            //main condition
            Text(
              _weather?.mainCondition ?? "",
              style: TextStyle(
                fontSize: 30,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
