import 'package:equatable/equatable.dart';

abstract class RecentSearchesState extends Equatable {
  const RecentSearchesState();
}

class RecentSearchesInitial extends RecentSearchesState {
  const RecentSearchesInitial();

  @override
  List<Object?> get props => [];
}

class RecentSearchesLoading extends RecentSearchesState {
  const RecentSearchesLoading();

  @override
  List<Object?> get props => [];
}

class RecentSearchesLoaded extends RecentSearchesState {
  final List<String> searches;

  const RecentSearchesLoaded(this.searches);

  @override
  List<Object?> get props => [searches];
}

class RecentSearchesError extends RecentSearchesState {
  final String message;

  const RecentSearchesError(this.message);

  @override
  List<Object?> get props => [message];
}
