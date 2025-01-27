import 'package:flutter/material.dart';
import 'package:weathora/models/weather_data.dart';
import 'package:weathora/widgets/animated_weather_icon.dart';

class WeeklyForecast extends StatelessWidget {
  final List<WeatherData> forecast;

  const WeeklyForecast({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '7-Day Forecast',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: forecast.length,
              itemBuilder: (context, index) {
                return ForecastDay(
                  date: DateTime.now().add(Duration(days: index)),
                  weather: forecast[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ForecastDay extends StatelessWidget {
  final DateTime date;
  final WeatherData weather;

  const ForecastDay({super.key, 
    required this.date,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            _formatDate(date),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: AnimatedWeatherIcon(
              condition: weather.condition,
              size: 80,
            ),
          ),
          Text(
            '${weather.temperature.round()}°',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${weather.feelsLike.round()}°',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day) return 'Today';
    if (date.day == now.day + 1) return 'Tomorrow';
    
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }
}