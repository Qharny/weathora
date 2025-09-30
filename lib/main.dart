import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weathora/screens/splash.dart';
import 'package:weathora/services/notification.dart';
import 'theme/app_theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = WeatherNotificationService();
  await notificationService.initialize();
  await notificationService.scheduleWeatherChecks();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('darkMode') ?? false;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(WeatherApp( isDarkMode: isDarkMode)));
}

class WeatherApp extends StatefulWidget {
  final bool isDarkMode;
  
  const WeatherApp({super.key, required this.isDarkMode});
  
  @override
  State<WeatherApp> createState() => _WeatherAppState();
  
  static _WeatherAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_WeatherAppState>()!;
}

class _WeatherAppState extends State<WeatherApp> {
  late bool _isDarkMode;
  
  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }
  
  void toggleTheme(bool isDarkMode) {
    setState(() => _isDarkMode = isDarkMode);
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(),
    );
  }
}