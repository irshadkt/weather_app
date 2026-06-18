import 'package:equatable/equatable.dart';
import 'package:weather_app/data/models/weather_model.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();

  @override
  List<Object?> get props => [];
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();

  @override
  List<Object?> get props => [];
}

class WeatherLoaded extends WeatherState {
  final WeatherModel weather;

  const WeatherLoaded(this.weather);

  @override
  List<Object?> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}

class WeatherOffline extends WeatherState {
  final WeatherModel? cachedWeather;

  const WeatherOffline({this.cachedWeather});

  @override
  List<Object?> get props => [cachedWeather];
}
