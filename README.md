# Weathora - Weather App

A modern Flutter weather application with real-time updates, animated weather icons, and smart notifications.

## Features

- Real-time weather data using WeatherStack API
- Animated weather icons for different conditions
- Location-based weather detection
- Smart weather notifications
- Weekly forecast with detailed metrics
- Search functionality with recent history
- Dark/Light theme support

## Screenshots

[Place your screenshots here]

## Prerequisites

- Flutter 3.0+
- Dart 3.0+
- WeatherStack API key
- Android SDK / Xcode (for mobile deployment)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/qharny/weathora.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure API key:
   - Create `lib/config/api_config.dart`
   - Add your WeatherStack API key:
```dart
const String WEATHER_API_KEY = 'your_api_key_here';
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart
├── models/
│   └── weather_data.dart
├── screens/
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── home_screen.dart
│   └── search_screen.dart
├── services/
│   ├── weather_service.dart
│   ├── location_service.dart
│   └── notification_service.dart
├── widgets/
│   ├── animated_weather_icon.dart
│   └── weekly_forecast.dart
└── theme/
    └── app_theme.dart
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.2
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  flutter_local_notifications: ^16.3.0
  workmanager: ^0.5.2
```

## Key Features Implementation

### Animated Weather Icons
- Custom animations for various weather conditions
- Smooth transitions between states
- Vector-based graphics for scalability

### Location Services
- Real-time location detection
- Reverse geocoding for city names
- Permission handling

### Weather Notifications
- Background weather monitoring
- Severe weather alerts
- Customizable notification triggers

## Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/NewFeature`
3. Commit changes: `git commit -am 'Add NewFeature'`
4. Push to branch: `git push origin feature/NewFeature`
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- WeatherStack API for weather data
- Flutter team for the framework
- Contributors and testers

## Contact

Name - [@mr_kabuteyy](https://twitter.com/mr_kabuteyy)
Project Link: [https://github.com/qharny/weathora](https://github.com/qharny/weathora)