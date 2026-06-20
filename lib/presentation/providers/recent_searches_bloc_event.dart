import 'package:equatable/equatable.dart';

abstract class RecentSearchesEvent extends Equatable {
  const RecentSearchesEvent();
}

class LoadRecentSearchesEvent extends RecentSearchesEvent {
  const LoadRecentSearchesEvent();

  @override
  List<Object?> get props => [];
}

class AddRecentSearchEvent extends RecentSearchesEvent {
  final String city;

  const AddRecentSearchEvent(this.city);

  @override
  List<Object?> get props => [city];
}

class RemoveRecentSearchEvent extends RecentSearchesEvent {
  final String city;

  const RemoveRecentSearchEvent(this.city);

  @override
  List<Object?> get props => [city];
}

class ClearRecentSearchesEvent extends RecentSearchesEvent {
  const ClearRecentSearchesEvent();

  @override
  List<Object?> get props => [];
}
