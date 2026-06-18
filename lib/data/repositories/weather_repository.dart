import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:weather_app/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/data/datasources/weather_local_data_source.dart';
import 'package:weather_app/data/models/weather_model.dart';

class WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final Connectivity connectivity;

  WeatherRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  Future<WeatherModel?> getWeather(String city) async {
    final connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      // No internet connection, show cached weather
      return localDataSource.getCachedWeather();
    }

    try {
      // Fetch from API
      final weather = await remoteDataSource.getWeather(city);
      
      // Cache the weather data
      await localDataSource.cacheWeather(weather);
      
      return weather;
    } catch (e) {
      // If API call fails, fallback to cached weather
      return localDataSource.getCachedWeather();
    }
  }

  Future<void> saveRecentSearch(String city) async {
    await localDataSource.cacheRecentSearch(city);
  }

  List<String> getRecentSearches() {
    return localDataSource.getRecentSearches();
  }
}
