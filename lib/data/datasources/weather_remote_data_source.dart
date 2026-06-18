import 'package:dio/dio.dart';
import 'package:weather_app/core/constants/api_constants.dart';
import 'package:weather_app/data/models/weather_model.dart';

class WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSource(this.dio);

  Future<WeatherModel> getWeather(String city) async {
    try {
      final response = await dio.get(
        "${ApiConstants.baseUrl}?q=$city&appid=${ApiConstants.apiKey}&units=metric",
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw Exception('City not found: $city');
      } else {
        throw Exception('Failed to load weather data. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('City not found: $city');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout. The server took too long to respond.');
      } else if (e.type == DioExceptionType.unknown) {
        throw Exception('No internet connection. Please check your connection.');
      } else {
        throw Exception('Error loading weather: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }
}
