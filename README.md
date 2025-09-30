# Weathora 🌤️

A beautiful and modern weather application built with Flutter that provides real-time weather information, forecasts, and weather alerts based on your location.

## ✨ Features

- 🌍 **Location-based Weather** - Automatically detects your location and displays current weather conditions
- 📊 **Weather Forecasts** - View detailed weather forecasts for the upcoming days
- 🔔 **Weather Alerts** - Receive notifications for severe weather conditions (thunderstorms, extreme temperatures, strong winds)
- 🎨 **Beautiful UI** - Modern and intuitive user interface with smooth animations
- 🌓 **Theme Support** - Customizable themes for a personalized experience
- 🔄 **Background Updates** - Periodic weather updates even when the app is closed
- 📍 **Multiple Locations** - Search and save weather for different cities
- ⚡ **Real-time Data** - Up-to-date weather information from reliable sources

## 📱 Screenshots

_Coming soon_

## 🛠️ Prerequisites

Before you begin, ensure you have met the following requirements:

- Flutter SDK (>=3.9.2)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- An OpenWeatherMap API key (or your preferred weather API)

## 📦 Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/weathora.git
   cd weathora
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure API Key**
   - Open `lib/services/weather_service.dart`
   - Add your weather API key:

     ```dart
     final String apiKey = 'YOUR_API_KEY_HERE';
     ```

4. **Run the app**

   ```bash
   flutter run
   ```

## 🔑 Required Permissions

### Android

The app requires the following permissions on Android:

- `INTERNET` - Fetch weather data from API
- `ACCESS_FINE_LOCATION` - Get precise location for accurate weather
- `ACCESS_COARSE_LOCATION` - Get approximate location
- `POST_NOTIFICATIONS` - Send weather alerts (Android 13+)
- `WAKE_LOCK` - Keep device awake for background updates
- `FOREGROUND_SERVICE` - Run background weather checks
- `RECEIVE_BOOT_COMPLETED` - Restart scheduled tasks after reboot

### iOS

- **Location Services** - Access to device location
- **Background Modes** - Location updates, fetch, and processing
- User-friendly permission prompts explaining why location is needed

## 📁 Project Structure

```
weathora/
├── lib/
│   ├── main.dart                      # App entry point
│   ├── models/
│   │   └── weather_data.dart          # Weather data model
│   ├── screens/
│   │   ├── splash.dart                # Splash screen
│   │   ├── onboarding.dart            # Onboarding screens
│   │   ├── home.dart                  # Main weather display
│   │   └── settings.dart              # App settings
│   ├── services/
│   │   ├── weather_service.dart       # Weather API integration
│   │   ├── location.dart              # Location services
│   │   └── notification.dart          # Push notifications
│   ├── theme/
│   │   └── app_theme.dart             # App theming
│   └── widgets/
│       ├── animated_weather_icon.dart # Animated weather icons
│       ├── floating_button.dart       # Floating action buttons
│       └── weekly_forcast.dart        # Weekly forecast widget
├── android/                            # Android configuration
├── ios/                                # iOS configuration
└── pubspec.yaml                        # Project dependencies
```

## 📚 Dependencies

- **http** - HTTP requests for weather API
- **geolocator** - Location services
- **geocoding** - Convert coordinates to city names
- **flutter_local_notifications** - Local push notifications
- **workmanager** - Background task scheduling
- **shared_preferences** - Local data storage
- **provider** - State management
- **loading_animation_widget** - Loading animations
- **just_audio** - Audio playback (for notification sounds)
- **flutter_svg** - SVG image support

## 🚀 Building for Production

### Android

```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## 🔧 Configuration

### Weather API Setup

1. Sign up for a free API key at [OpenWeatherMap](https://openweathermap.org/api) or your preferred weather service
2. Update the API key in `lib/services/weather_service.dart`
3. Configure the API endpoint if using a different service

### Notification Settings

- Customize notification frequency in `lib/services/notification.dart`
- Modify alert thresholds for temperature, wind speed, etc.
- Default check interval: Every 3 hours

## 🎯 Features in Detail

### Weather Alerts

The app monitors weather conditions and sends notifications for:

- ⛈️ Thunderstorms
- 🔥 Extreme heat (>35°C)
- ❄️ Freezing temperatures (<0°C)
- 💨 Strong winds (>50 km/h)

### Background Updates

- Automatic weather checks every 3 hours
- Network-aware (only updates when connected)
- Battery-optimized background processing

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👤 Author

**Your Name**

- GitHub: [@yourusername](https://github.com/yourusername)

## 🙏 Acknowledgments

- Weather data provided by OpenWeatherMap
- Icons and assets from various open-source projects
- Flutter community for excellent packages and support

## 📞 Support

For support, email <your-email@example.com> or create an issue in this repository.

---

Made with ❤️ using Flutter
