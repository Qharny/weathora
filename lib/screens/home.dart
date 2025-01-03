import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weathora/screens/settings.dart';
import 'package:weathora/services/location.dart';
import 'package:weathora/widgets/animated_weather_icon.dart';
import 'package:weathora/widgets/floating_button.dart';
import '../services/weather_service.dart';
import '../models/weather_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _searchController = TextEditingController();
  WeatherData? _weatherData;
  bool _isLoading = true;
  bool _isSearching = false;
  List<String> _recentSearches = [];
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _loadWeatherData();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _saveSearch(String city) async {
    if (!_recentSearches.contains(city)) {
      final prefs = await SharedPreferences.getInstance();
      _recentSearches.insert(0, city);
      if (_recentSearches.length > 5) _recentSearches.removeLast();
      await prefs.setStringList('recent_searches', _recentSearches);
      setState(() {});
    }
  }

  Future<void> _searchCity(String city) async {
    if (city.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final weatherData = await _weatherService.getWeather(city);
      await _saveSearch(city);
      setState(() {
        _weatherData = weatherData;
        _isSearching = false;
      });
      _searchController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('City not found')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadWeatherData([String? city]) async {
    try {
      final weather = await _weatherService.getWeather(city ?? 'New York');
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

  Future<void> _loadLocationWeather() async {
    try {
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();
      final city = await locationService.getCityName(position);
      await _loadWeatherData(city);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not get location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 420, // Increased height
                      floating: false,
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            WeatherHeader(weatherData: _weatherData),
                            Positioned(
                              top: MediaQuery.of(context).padding.top +
                                  10, // Adjusted position
                              left: 20,
                              right: 20,
                              child: SearchBar(
                                controller: _searchController,
                                onSearch: _searchCity,
                                onFocus: (focused) =>
                                    setState(() => _isSearching = focused),
                              ),
                            ),
                            if (_isSearching)
                              Positioned(
                                top: MediaQuery.of(context).padding.top +
                                    70, // Adjusted position
                                left: 20,
                                right: 20,
                                child: RecentSearchesList(
                                  searches: _recentSearches,
                                  onSelect: _searchCity,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: WeatherDetails(weatherData: _weatherData),
                    ),
                  ],
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingMenuButton(
                    onLocationPressed: _loadLocationWeather,
                    onSettingsPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final Function(bool) onFocus;

  const SearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onFocus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Focus(
        onFocusChange: onFocus,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search city...',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          onSubmitted: onSearch,
        ),
      ),
    );
  }
}

class RecentSearchesList extends StatelessWidget {
  final List<String> searches;
  final Function(String) onSelect;

  const RecentSearchesList({
    super.key,
    required this.searches,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: searches.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.history),
              title: Text(searches[index]),
              onTap: () => onSelect(searches[index]),
            );
          }),
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
          SizedBox(
              height: MediaQuery.of(context).padding.top + 60), // Added padding
          Text(
            weatherData!.location,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          AnimatedWeatherIcon(
            condition: weatherData!.condition,
            size: 120,
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

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DetailItem({
    super.key,
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

  const WeatherDetailCard({
    super.key,
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

// class DetailItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String value;

//   const DetailItem({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, color: Theme.of(context).primaryColor),
//         SizedBox(width: 8),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             ),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
