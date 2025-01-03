import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weathora/screens/splash.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(WeatherApp()));
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weathora',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
