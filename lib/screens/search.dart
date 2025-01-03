import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/weather_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _weatherService = WeatherService();
  final _searchController = TextEditingController();
  List<String> _recentSearches = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
    setState(() => _isLoading = true);
    try {
      final weatherData = await _weatherService.getWeather(city);
      await _saveSearch(city);
      Navigator.pop(context, weatherData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('City not found')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search city...',
            border: InputBorder.none,
            suffixIcon: _isLoading
                ? Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _searchCity(_searchController.text),
                  ),
          ),
          onSubmitted: _searchCity,
        ),
      ),
      body: ListView.builder(
        itemCount: _recentSearches.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.history),
            title: Text(_recentSearches[index]),
            onTap: () => _searchCity(_recentSearches[index]),
          );
        },
      ),
    );
  }
}