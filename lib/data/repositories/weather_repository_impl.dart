import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:weather_app/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/data/datasources/weather_local_data_source.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remote;
  final WeatherLocalDataSource local;
  final Connectivity connectivity;

  WeatherRepositoryImpl({
    required this.remote,
    required this.local,
    required this.connectivity,
  });

  @override
  Future<WeatherModel> getWeather(String city) async {
    final connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      // No internet, try to get cached weather
      final cached = local.getCachedWeather();
      if (cached != null) {
        return cached;
      }
      throw Exception('No internet connection and no cached data');
    }

    try {
      // Fetch from API
      final weather = await remote.getWeather(city);

      // Cache the result
      await local.cacheWeather(weather);
      
      // Save to recent searches
      await local.cacheRecentSearch(city);

      return weather;
    } catch (e) {
      // Fallback to cached weather if API fails
      final cached = local.getCachedWeather();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }
}
