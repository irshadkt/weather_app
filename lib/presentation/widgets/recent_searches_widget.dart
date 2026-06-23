import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/presentation/bloc/recentSearchBloc/recent_searches_bloc.dart';
import 'package:weather_app/presentation/bloc/recentSearchBloc/recent_searches_bloc_event.dart';
import 'package:weather_app/presentation/bloc/recentSearchBloc/recent_searches_bloc_state.dart';
import 'package:weather_app/presentation/bloc/weatherDataBloc/weather_bloc.dart';
import 'package:weather_app/presentation/bloc/weatherDataBloc/weather_bloc_event.dart';

class RecentSearchesWidget extends StatelessWidget {
  const RecentSearchesWidget({super.key});

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
        BlocBuilder<RecentSearchesBloc, RecentSearchesState>(
          builder: (context, state) {
            if (state is RecentSearchesLoading) {
              return const SizedBox(
                height: 50,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is RecentSearchesError) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Error: ${state.message}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            if (state is RecentSearchesLoaded) {
              final searches = state.searches;

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
                          context
                              .read<RecentSearchesBloc>()
                              .add(AddRecentSearchEvent(city));
                        },
                      ),
                    );
                  },
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'No recent searches',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          },
        ),
      ],
    );
  }
}

