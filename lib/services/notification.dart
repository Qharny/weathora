import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weathora/models/weather_data.dart';
import 'package:weathora/services/location.dart';
import 'package:weathora/services/weather_service.dart';
import 'package:workmanager/workmanager.dart';

class WeatherNotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  Future<void> initialize() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _notifications.initialize(initializationSettings);
    await Workmanager().initialize(callbackDispatcher);
  }

  Future<void> scheduleWeatherChecks() async {
    await Workmanager().registerPeriodicTask(
      'weatherCheck',
      'checkWeather',
      frequency: Duration(hours: 3),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  Future<void> showWeatherAlert({
    required String title,
    required String body,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'weather_alerts',
        'Weather Alerts',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notifications.show(0, title, body, notificationDetails);
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final notificationService = WeatherNotificationService();
    final locationService = LocationService();
    final weatherService = WeatherService();

    try {
      final position = await locationService.getCurrentLocation();
      final city = await locationService.getCityName(position);
      final weather = await weatherService.getWeather(city);

      // Check for severe weather conditions
      if (_shouldShowAlert(weather)) {
        await notificationService.showWeatherAlert(
          title: 'Weather Alert',
          body: _getAlertMessage(weather),
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  });
}

bool _shouldShowAlert(WeatherData weather) {
  return weather.condition.toLowerCase().contains('thunderstorm') ||
      weather.temperature > 35 ||
      weather.temperature < 0 ||
      weather.windSpeed > 50;
}

String _getAlertMessage(WeatherData weather) {
  if (weather.condition.toLowerCase().contains('thunderstorm')) {
    return 'Thunderstorm warning in your area';
  } else if (weather.temperature > 35) {
    return 'Extreme heat warning: ${weather.temperature}°C';
  } else if (weather.temperature < 0) {
    return 'Freezing temperatures: ${weather.temperature}°C';
  } else if (weather.windSpeed > 50) {
    return 'Strong winds: ${weather.windSpeed} km/h';
  }
  return 'Severe weather conditions in your area';
}
