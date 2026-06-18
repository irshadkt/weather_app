import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class FetchWeatherEvent extends WeatherEvent {
  final String city;

  const FetchWeatherEvent(this.city);

  @override
  List<Object?> get props => [city];
}

class RefreshWeatherEvent extends WeatherEvent {
  final String city;

  const RefreshWeatherEvent(this.city);

  @override
  List<Object?> get props => [city];
}
