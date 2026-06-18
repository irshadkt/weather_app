import 'package:flutter/material.dart';
import 'package:weather_app/data/datasources/weather_local_data_source.dart';
import 'package:weather_app/core/constants/cities_list.dart';
import 'package:weather_app/data/models/city_model.dart';

class RecentSearchesScreen extends StatefulWidget {
  const RecentSearchesScreen({super.key});

  @override
  State<RecentSearchesScreen> createState() => _RecentSearchesScreenState();
}

class _RecentSearchesScreenState extends State<RecentSearchesScreen> {
  late WeatherLocalDataSource _localDataSource;
  List<String> _recentSearches = [];
  List<CityModel> _recentSearchCities = [];

  @override
  void initState() {
    super.initState();
    _localDataSource = WeatherLocalDataSource();
    _loadRecentSearches();
  }

  void _loadRecentSearches() {
    final searches = _localDataSource.getRecentSearches();
    setState(() {
      _recentSearches = searches;
      _recentSearchCities = cities
          .where((city) => searches.contains(city.name))
          .toList();
    });
  }

  void _clearRecentSearches() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Clear Recent Searches?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This action cannot be undone.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF4FC3F7)),
            ),
          ),
          TextButton(
            onPressed: () async {
              // Clear all recent searches
              final box = _localDataSource.recentSearchesBox;
              await box.put('searches', <String>[]);
              _loadRecentSearches();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recent Searches',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_recentSearches.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _clearRecentSearches,
              tooltip: 'Clear all',
            ),
        ],
      ),
      body: _recentSearchCities.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No recent searches',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _recentSearchCities.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                final city = _recentSearchCities[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: Icon(
                    Icons.history,
                    color: const Color(0xFF4FC3F7),
                    size: 20,
                  ),
                  title: Text(
                    city.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    city.country,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.pop(context, city);
                  },
                );
              },
            ),
    );
  }
}
