import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/cities_list.dart';
import 'package:weather_app/data/models/city_model.dart';

class SearchCitiesScreen extends StatefulWidget {
  const SearchCitiesScreen({super.key});

  @override
  State<SearchCitiesScreen> createState() => _SearchCitiesScreenState();
}

class _SearchCitiesScreenState extends State<SearchCitiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CityModel> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = cities;
  }

  void _filterCities(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCities = cities;
      } else {
        _filteredCities = cities
            .where((city) =>
                city.name.toLowerCase().contains(query.toLowerCase()) ||
                city.country.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
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
          'Search City',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCities,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search city...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                ),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF4FC3F7),
                  size: 24,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFF4FC3F7),
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _filterCities('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF4FC3F7),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade700,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF4FC3F7),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredCities.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: 48,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No cities found',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredCities.length,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (context, index) {
                      final city = _filteredCities[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Icon(
                          Icons.location_on,
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
