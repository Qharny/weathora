import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/weather_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  WeatherData? _weatherData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    try {
      final weather = await _weatherService.getWeather('New York');
      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load weather data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: WeatherHeader(weatherData: _weatherData),
                  ),
                ),
                SliverToBoxAdapter(
                  child: WeatherDetails(weatherData: _weatherData),
                ),
              ],
            ),
    );
  }
}

class WeatherHeader extends StatelessWidget {
  final WeatherData? weatherData;

  const WeatherHeader({super.key, this.weatherData});

  @override
  Widget build(BuildContext context) {
    if (weatherData == null) return Container();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weatherData!.location,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            '${weatherData!.temperature.round()}°',
            style: TextStyle(
              color: Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            weatherData!.condition,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherDetails extends StatelessWidget {
  final WeatherData? weatherData;

  const WeatherDetails({super.key, this.weatherData});

  @override
  Widget build(BuildContext context) {
    if (weatherData == null) return Container();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          WeatherDetailCard(
            title: 'Weather Details',
            details: [
              DetailItem(
                icon: Icons.thermostat,
                title: 'Feels Like',
                value: '${weatherData!.feelsLike.round()}°',
              ),
              DetailItem(
                icon: Icons.water_drop,
                title: 'Humidity',
                value: '${weatherData!.humidity.round()}%',
              ),
              DetailItem(
                icon: Icons.air,
                title: 'Wind Speed',
                value: '${weatherData!.windSpeed} km/h',
              ),
              DetailItem(
                icon: Icons.compress,
                title: 'Pressure',
                value: '${weatherData!.pressure} hPa',
              ),
            ],
          ),
          SizedBox(height: 16),
          WeatherDetailCard(
            title: 'Additional Info',
            details: [
              DetailItem(
                icon: Icons.visibility,
                title: 'Visibility',
                value: '${weatherData!.visibility} km',
              ),
              DetailItem(
                icon: Icons.wb_sunny,
                title: 'UV Index',
                value: '${weatherData!.uvIndex}',
              ),
              DetailItem(
                icon: Icons.grain,
                title: 'Precipitation',
                value: '${weatherData!.precipitation} mm',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WeatherDetailCard extends StatelessWidget {
  final String title;
  final List<DetailItem> details;

  const WeatherDetailCard({super.key, 
    required this.title,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2,
              children: details,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DetailItem({super.key, 
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}