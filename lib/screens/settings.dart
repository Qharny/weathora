import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() => _isDarkMode = value);
              _saveSetting('darkMode', value);
            },
          ),
          ListTile(
            title: Text('Temperature Unit'),
            trailing: DropdownButton<String>(
              value: _temperatureUnit,
              items: ['°C', '°F'].map((unit) => 
                DropdownMenuItem(value: unit, child: Text(unit))
              ).toList(),
              onChanged: (value) {
                setState(() => _temperatureUnit = value!);
                _saveSetting('tempUnit', value);
              },
            ),
          ),
          SwitchListTile(
            title: Text('Weather Notifications'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
              _saveSetting('notifications', value);
            },
          ),
        ],
      ),
    );
  }
}