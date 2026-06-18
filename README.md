
# Weather App 🌤️

A beautiful and feature-rich Flutter weather application that provides real-time weather information with offline support and a modern UI.

## Features

✨ **Real-Time Weather Data**
- Get current weather conditions for any location
- Hourly and daily forecasts
- Temperature, humidity, wind speed, and more

📍 **Location-Based Services**
- Search weather by city name
- Automatic location detection (when permissions granted)
- Recent search history

💾 **Offline Support**
- Cache weather data locally using Hive
- View previously fetched weather data offline
- Automatic sync when connectivity is restored

🎨 **Beautiful UI/UX**
- Dark theme optimized for eye comfort
- Smooth animations and transitions
- Shimmer loading effects
- Responsive design for all screen sizes

🔄 **Connectivity Management**
- Automatic detection of internet connection
- Graceful handling of offline scenarios
- Real-time connectivity status

## Project Structure

The app follows **Clean Architecture** with BLoC pattern:

```
lib/
├── core/                           # Core utilities and constants
│   ├── constants/                  # App constants
│   ├── network/                    # Network-related utilities
│   ├── theme/                      # App theming
│   └── utils/                      # Utility functions
│
├── data/                           # Data layer
│   ├── datasources/                # Remote and local data sources
│   ├── models/                     # Data models
│   └── repositories/               # Repository implementations
│
├── domain/                         # Domain layer (Business logic)
│   ├── entities/                   # Core entities
│   └── repositories/               # Repository interfaces
│
└── presentation/                   # Presentation layer
    ├── providers/                  # BLoC providers
    ├── screens/                    # App screens
    └── widgets/                    # Reusable widgets
```

## Technologies & Dependencies

- **Flutter** - UI Framework
- **BLoC** - State management
- **Dio** - HTTP client
- **Hive** - Local database
- **Connectivity Plus** - Connectivity detection
- **Shimmer** - Loading animations
- **Google Fonts** - Typography
- **Intl** - Internationalization and formatting

## Prerequisites

Before you begin, ensure you have the following installed:
- Flutter SDK (version 3.11.5 or higher)
- Dart SDK (included with Flutter)
- Git

## Installation

1. **Clone the repository**
   ```bash
   git clone <your-repository-url>
   cd weather_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Usage

1. **Launch the App**
   - Open the app on your device or emulator

2. **Search for Weather**
   - Enter a city name in the search field
   - Tap the search button to fetch weather data

3. **View Weather Details**
   - See current weather conditions
   - Check hourly and daily forecasts
   - View additional metrics (humidity, wind speed, etc.)

4. **Use Recent Searches**
   - Your recent searches are saved automatically
   - Quickly access previously searched cities

5. **Offline Mode**
   - Previously fetched weather data is cached
   - Access saved data when internet is unavailable

## Architecture

This app implements **Clean Architecture** with three distinct layers:

### Domain Layer
- Contains business logic
- Defines repository interfaces
- Independent of any framework

### Data Layer
- Implements repositories
- Manages data sources (remote and local)
- Handles data transformation

### Presentation Layer
- Manages UI and user interactions
- Uses BLoC for state management
- Keeps business logic separate from UI

## Building for Production

### Android
```bash
flutter build apk --release
# or for App Bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Troubleshooting

**Build Issues**
- Run `flutter clean` followed by `flutter pub get`
- Ensure your Flutter SDK is up to date: `flutter upgrade`

**Runtime Issues**
- Check internet connection
- Verify API keys are properly configured
- Clear app cache and rebuild

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Made with ❤️ using Flutter**
