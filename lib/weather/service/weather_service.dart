import 'dart:convert';

import 'package:geocoding/geocoding.dart';

import '../weather.dart';
import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';

class WeatherService {
  // ignore: constant_identifier_names
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    //get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else {}

    //fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //convert the location into a list of placemark objects
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract the city name from the first placemark
    String? city = placemark[0].locality;

    return city ?? "";
  }
}
