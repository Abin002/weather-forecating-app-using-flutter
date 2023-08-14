import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:climate/constants.dart' as k;
import 'package:geolocator/geolocator.dart';
import 'model.dart';

class APIServices {
  static Future<WeatherData?> getCurrentCityWeather(Position position) async {
    var url =
        '${k.domain}lat=${position.latitude}&lon=${position.longitude}&appid=${k.apikey}';
    var response = await http.Client().get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = json.decode(data);
      return WeatherData.fromJson(decodedData);
    } else {
      print('API request failed: ${response.statusCode}');
      return null;
    }
  }

  static Future<WeatherData?> getCityWeather(String cityName) async {
    var url = '${k.domain}q=${cityName.trim()}&appid=${k.apikey}';
    var response = await http.Client().get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = json.decode(data);
      return WeatherData.fromJson(decodedData);
    } else {
      print('API request failed: ${response.statusCode}');
      return null;
    }
  }
}
