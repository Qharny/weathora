import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherService {
  static const String _baseUrl = 'http://api.weatherstack.com/current';
  static const String _apiKey = 'b7e5fa0294bf972f828379c7b9f909d9';

  Future<WeatherData> getWeather(String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?access_key=$_apiKey&query=$city'),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}