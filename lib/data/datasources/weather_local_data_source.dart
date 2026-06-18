import 'package:hive/hive.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'dart:convert';

class WeatherLocalDataSource {
  static const String weatherBoxName = 'weatherBox';
  static const String recentSearchesBoxName = 'recentSearches';
  static const String lastWeatherKey = 'lastWeather';

  Future<void> cacheWeather(WeatherModel weather) async {
    final box = Hive.box(weatherBoxName);
    final weatherJson = {
      'city': weather.city,
      'country': weather.country,
      'temperature': weather.temperature,
      'feelsLike': weather.feelsLike,
      'tempMin': weather.tempMin,
      'tempMax': weather.tempMax,
      'condition': weather.condition,
      'description': weather.description,
      'humidity': weather.humidity,
      'windSpeed': weather.windSpeed,
      'windDegree': weather.windDegree,
      'cloudPercentage': weather.cloudPercentage,
      'visibility': weather.visibility,
    };
    await box.put(lastWeatherKey, jsonEncode(weatherJson));
  }

  WeatherModel? getCachedWeather() {
    final box = Hive.box(weatherBoxName);
    final weatherJson = box.get(lastWeatherKey);
    
    if (weatherJson == null) return null;
    
    try {
      final decoded = jsonDecode(weatherJson);
      return WeatherModel(
        city: decoded['city'] ?? 'Unknown',
        country: decoded['country'] ?? 'Unknown',
        temperature: (decoded['temperature'] as num).toDouble(),
        feelsLike: (decoded['feelsLike'] as num).toDouble(),
        tempMin: (decoded['tempMin'] as num).toDouble(),
        tempMax: (decoded['tempMax'] as num).toDouble(),
        condition: decoded['condition'] ?? 'Unknown',
        description: decoded['description'] ?? 'No description',
        humidity: decoded['humidity'] as int,
        windSpeed: (decoded['windSpeed'] as num).toDouble(),
        windDegree: decoded['windDegree'] as int? ?? 0,
        cloudPercentage: decoded['cloudPercentage'] as int? ?? 0,
        visibility: decoded['visibility'] as int? ?? 10000,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> cacheRecentSearch(String city) async {
    final box = Hive.box(recentSearchesBoxName);
    final searches = box.get('searches', defaultValue: <String>[]) as List;
    
    if (!searches.contains(city)) {
      searches.insert(0, city);
      if (searches.length > 10) searches.removeLast();
      await box.put('searches', searches);
    }
  }

  List<String> getRecentSearches() {
    final box = Hive.box(recentSearchesBoxName);
    return List<String>.from(box.get('searches', defaultValue: <String>[]));
  }

  Box<dynamic> get recentSearchesBox => Hive.box(recentSearchesBoxName);
}
