import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/data/models/city_model.dart';
import 'package:weather_app/presentation/providers/weather_bloc.dart';
import 'package:weather_app/presentation/providers/weather_bloc_event.dart';
import 'package:weather_app/presentation/providers/weather_bloc_state.dart';
import 'package:weather_app/presentation/widgets/weather_loading_shimmer.dart';
import 'package:weather_app/presentation/screens/search_cities_screen.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late TextEditingController cityController;
  String? currentCity;

  @override
  void initState() {
    super.initState();
    cityController = TextEditingController();
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  String _getErrorMessage(String error) {
    if (error.contains('404') || error.contains('not found')) {
      return 'City not found. Please check the spelling and try again.';
    } else if (error.contains('SocketException') ||
        error.contains('No internet') ||
        error.contains('No host')) {
      return 'No internet connection. Showing cached data if available.';
    } else {
      return 'Something went wrong. Please try again later.';
    }
  }

  String _getWeatherIcon(String condition) {
    final conditionLower = condition.toLowerCase();
    if (conditionLower.contains('cloud')) {
      return '☁️';
    }
    if (conditionLower.contains('rain')) {
      return '🌧️';
    }
    if (conditionLower.contains('clear') ||
        conditionLower.contains('sunny')) {
      return '☀️';
    }
    if (conditionLower.contains('snow')) {
      return '❄️';
    }
    if (conditionLower.contains('thunder')) {
      return '⛈️';
    }
    if (conditionLower.contains('mist') ||
        conditionLower.contains('fog')) {
      return '🌫️';
    }
    return '🌤️';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      appBar: AppBar(
        backgroundColor: const Color(0xff121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const Text(
          'Weather App',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (currentCity != null && currentCity!.isNotEmpty) {
            context
                .read<WeatherBloc>()
                .add(RefreshWeatherEvent(currentCity!));
          }
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: GestureDetector(
                onTap: () async {
                  final city = await Navigator.push<CityModel>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchCitiesScreen(),
                    ),
                  );
                  if (city != null && mounted) {
                    setState(() {
                      currentCity = city.name;
                      cityController.text = city.name;
                    });
                    // ignore: use_build_context_synchronously
                    context.read<WeatherBloc>().add(FetchWeatherEvent(city.name));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 16.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff252525),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade600),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          currentCity != null && currentCity!.isNotEmpty
                              ? currentCity!
                              : 'Search city...',
                          style: TextStyle(
                            color: currentCity != null && currentCity!.isNotEmpty
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Weather Content
            BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherInitial) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cloud_queue,
                            size: 64,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Search for a city to get weather',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is WeatherLoading) {
                  return const Column(
                    children: [
                      WeatherLoadingShimmer(),
                    ],
                  );
                } else if (state is WeatherLoaded) {
                  final weather = state.weather;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Weather Card
                      Card(
                        color: const Color(0xff1E1E1E),
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Location and Date
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${weather.city}, ${weather.country}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Today, ${DateFormat('d MMM').format(DateTime.now())}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Weather Icon and Temp
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getWeatherIcon(weather.condition),
                                        style: const TextStyle(fontSize: 64),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${weather.temperature.toStringAsFixed(0)}°',
                                        style: const TextStyle(
                                          fontSize: 64,
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xff4FC3F7),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        weather.description,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Weather Details Grid
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildWeatherDetailItem(
                                    icon: Icons.opacity,
                                    label: 'Humidity',
                                    value: '${weather.humidity}%',
                                  ),
                                  _buildWeatherDetailItem(
                                    icon: Icons.air,
                                    label: 'Wind Speed',
                                    value:
                                        '${weather.windSpeed.toStringAsFixed(0)} km/h',
                                  ),
                                  _buildWeatherDetailItem(
                                    icon: Icons.cloud,
                                    label: 'Cloud',
                                    value: '${weather.cloudPercentage}%',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Hourly Forecast
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Now',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            final now = DateTime.now();
                            final time =
                                now.add(Duration(hours: index)).toLocal();
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xff1E1E1E),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      DateFormat('h a').format(time),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      _getWeatherIcon(weather.condition),
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                    Text(
                                      '${(weather.temperature + (index * 1.5)).toStringAsFixed(0)}°',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Recent Searches
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Searches',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'View all',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff4FC3F7),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Recent Search Chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildSearchChip('Kochi'),
                          _buildSearchChip('London'),
                          _buildSearchChip('New York'),
                          _buildSearchChip('Tokyo'),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Get Location Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff4FC3F7),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.black, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Get My Location',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                } else if (state is WeatherError) {
                  return Card(
                    color: const Color(0xff1E1E1E),
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red.shade700,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _getErrorMessage(state.message),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is WeatherOffline) {
                  if (state.cachedWeather != null) {
                    final weather = state.cachedWeather!;
                    return Card(
                      color: const Color(0xff1E1E1E),
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade700,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Offline - Cached Data',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${weather.city}, ${weather.country}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              '${weather.temperature.toStringAsFixed(0)}°C',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff4FC3F7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              weather.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Card(
                      color: const Color(0xff1E1E1E),
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_off,
                              size: 48,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Internet Connection',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.red.shade700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No cached data available. Please connect to the internet and search for a city.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: const Color(0xff4FC3F7)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchChip(String city) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentCity = city;
          cityController.text = city;
        });
        context.read<WeatherBloc>().add(FetchWeatherEvent(city));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xff252525),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade700),
        ),
        child: Text(
          city,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
