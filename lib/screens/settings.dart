import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weathora/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _temperatureUnit = '°C';
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _temperatureUnit = prefs.getString('tempUnit') ?? '°C';
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() => _isDarkMode = value);
    WeatherApp.of(context).toggleTheme(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            subtitle: Text('Toggle dark theme'),
            value: _isDarkMode,
            onChanged: _toggleTheme,
          ),
          ListTile(
            title: Text('Temperature Unit'),
            trailing: DropdownButton<String>(
              value: _temperatureUnit,
              items: ['°C', '°F'].map((unit) => 
                DropdownMenuItem(value: unit, child: Text(unit))
              ).toList(),
              onChanged: (value) async {
                if (value != null) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('tempUnit', value);
                  setState(() => _temperatureUnit = value);
                }
              },
            ),
          ),
          SwitchListTile(
            title: Text('Weather Notifications'),
            subtitle: Text('Get weather updates'),
            value: _notificationsEnabled,
            onChanged: (value) async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('notifications', value);
              setState(() => _notificationsEnabled = value);
            },
          ),
        ],
      ),
    );
  }
}