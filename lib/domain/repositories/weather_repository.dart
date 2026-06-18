import 'package:weather_app/data/models/weather_model.dart';

abstract class WeatherRepository {
  Future<WeatherModel> getWeather(String city);
  WeatherModel? getCachedWeather();
}
