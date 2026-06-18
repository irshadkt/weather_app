import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/presentation/providers/weather_bloc.dart';
import 'package:weather_app/presentation/providers/weather_bloc_event.dart';

class RecentSearchesWidget extends StatefulWidget {
  const RecentSearchesWidget({super.key});

  @override
  State<RecentSearchesWidget> createState() => _RecentSearchesWidgetState();
}

class _RecentSearchesWidgetState extends State<RecentSearchesWidget> {
  late Box recentSearchesBox;

  @override
  void initState() {
    super.initState();
    recentSearchesBox = Hive.box('recentSearches');
  }

  List<String> _getSearches() {
    return List<String>.from(
        recentSearchesBox.get('searches', defaultValue: <String>[]));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Recent Searches',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Builder(
          builder: (context) {
            final searches = _getSearches();

            if (searches.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'No recent searches',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            return SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: searches.length,
                itemBuilder: (context, index) {
                  final city = searches[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(city),
                      onSelected: (_) {
                        context
                            .read<WeatherBloc>()
                            .add(FetchWeatherEvent(city));
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

