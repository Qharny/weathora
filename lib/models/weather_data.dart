class WeatherData {
  final String location;
  final double temperature;
  final String condition;
  final double humidity;
  final double windSpeed;
  final String weatherIcon;
  final double feelsLike;
  final int pressure;
  final double precipitation;
  final int uvIndex;
  final double visibility;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.weatherIcon,
    required this.feelsLike,
    required this.pressure,
    required this.precipitation,
    required this.uvIndex,
    required this.visibility,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    final location = json['location'];
    
    return WeatherData(
      location: location['name'],
      temperature: current['temperature'].toDouble(),
      condition: current['weather_descriptions'][0],
      humidity: current['humidity'].toDouble(),
      windSpeed: current['wind_speed'].toDouble(),
      weatherIcon: current['weather_icons'][0],
      feelsLike: current['feelslike'].toDouble(),
      pressure: current['pressure'],
      precipitation: current['precip'].toDouble(),
      uvIndex: current['uv_index'],
      visibility: current['visibility'].toDouble(),
    );
  }
}