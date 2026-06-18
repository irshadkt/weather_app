import 'package:bloc/bloc.dart';
import 'package:weather_app/presentation/providers/weather_bloc_event.dart';
import 'package:weather_app/presentation/providers/weather_bloc_state.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc({required this.repository}) : super(const WeatherInitial()) {
    on<FetchWeatherEvent>(_onFetchWeather);
    on<RefreshWeatherEvent>(_onRefreshWeather);
    on<LoadCachedWeatherEvent>(_onLoadCachedWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());

    try {
      final weather = await repository.getWeather(event.city);
      emit(WeatherLoaded(weather, isCached: false));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  Future<void> _onRefreshWeather(
    RefreshWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());

    try {
      final weather = await repository.getWeather(event.city);
      emit(WeatherLoaded(weather, isCached: false));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  Future<void> _onLoadCachedWeather(
    LoadCachedWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      final cachedWeather = repository.getCachedWeather();
      if (cachedWeather != null) {
        emit(WeatherLoaded(cachedWeather, isCached: true));
      }
    } catch (e) {
      // Silently fail if no cached weather
    }
  }
}
