import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/data/datasources/weather_local_data_source.dart';
import 'package:weather_app/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/presentation/bloc/weatherDataBloc/weather_bloc.dart';
import 'package:weather_app/presentation/bloc/recentSearchBloc/recent_searches_bloc.dart';
import 'package:weather_app/presentation/screens/weather_screen.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();
  
  // Open Hive boxes
  await Hive.openBox('weatherBox');
  await Hive.openBox('recentSearches');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup dependencies
    final dio = Dio();
    final connectivity = Connectivity();
    final remoteDataSource = WeatherRemoteDataSource(dio);
    final localDataSource = WeatherLocalDataSource();
    final repository = WeatherRepositoryImpl(
      remote: remoteDataSource,
      local: localDataSource,
      connectivity: connectivity,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherBloc(repository: repository),
        ),
        BlocProvider(
          create: (context) => RecentSearchesBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner:false ,
        title: 'Weather App',
        theme: AppTheme.darkTheme,
        home: const WeatherScreen(),
      ),
    );
  }
}
