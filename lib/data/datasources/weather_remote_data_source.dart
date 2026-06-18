import 'package:dio/dio.dart';
import 'package:weather_app/core/constants/api_constants.dart';
import 'package:weather_app/data/models/weather_model.dart';

class WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSource(this.dio);

  Future<WeatherModel> getWeather(String city) async {
    final response = await dio.get(
      "${ApiConstants.baseUrl}?q=$city&appid=${ApiConstants.apiKey}&units=metric",
    );

    return WeatherModel.fromJson(response.data);
  }
}
