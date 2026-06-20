import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/presentation/providers/recent_searches_bloc_event.dart';
import 'package:weather_app/presentation/providers/recent_searches_bloc_state.dart';

class RecentSearchesBloc extends Bloc<RecentSearchesEvent, RecentSearchesState> {
  late Box recentSearchesBox;

  RecentSearchesBloc() : super(const RecentSearchesInitial()) {
    on<LoadRecentSearchesEvent>(_onLoadRecentSearches);
    on<AddRecentSearchEvent>(_onAddRecentSearch);
    on<RemoveRecentSearchEvent>(_onRemoveRecentSearch);
    on<ClearRecentSearchesEvent>(_onClearRecentSearches);
    
    _initializeBox();
  }

  Future<void> _initializeBox() async {
    try {
      recentSearchesBox = Hive.box('recentSearches');
      add(const LoadRecentSearchesEvent());
    } catch (e) {
      emit(RecentSearchesError(e.toString()));
    }
  }

  Future<void> _onLoadRecentSearches(
    LoadRecentSearchesEvent event,
    Emitter<RecentSearchesState> emit,
  ) async {
    try {
      emit(const RecentSearchesLoading());
      final searches = List<String>.from(
        recentSearchesBox.get('searches', defaultValue: <String>[]),
      );
      emit(RecentSearchesLoaded(searches));
    } catch (e) {
      emit(RecentSearchesError(e.toString()));
    }
  }

  Future<void> _onAddRecentSearch(
    AddRecentSearchEvent event,
    Emitter<RecentSearchesState> emit,
  ) async {
    try {
      final searches = List<String>.from(
        recentSearchesBox.get('searches', defaultValue: <String>[]),
      );

      // Remove if already exists to avoid duplicates
      searches.removeWhere((s) => s.toLowerCase() == event.city.toLowerCase());
      
      // Add to the beginning
      searches.insert(0, event.city);

      // Keep only last 10 searches
      if (searches.length > 10) {
        searches.removeRange(10, searches.length);
      }

      await recentSearchesBox.put('searches', searches);
      emit(RecentSearchesLoaded(searches));
    } catch (e) {
      emit(RecentSearchesError(e.toString()));
    }
  }

  Future<void> _onRemoveRecentSearch(
    RemoveRecentSearchEvent event,
    Emitter<RecentSearchesState> emit,
  ) async {
    try {
      final searches = List<String>.from(
        recentSearchesBox.get('searches', defaultValue: <String>[]),
      );
      searches.removeWhere((s) => s == event.city);
      await recentSearchesBox.put('searches', searches);
      emit(RecentSearchesLoaded(searches));
    } catch (e) {
      emit(RecentSearchesError(e.toString()));
    }
  }

  Future<void> _onClearRecentSearches(
    ClearRecentSearchesEvent event,
    Emitter<RecentSearchesState> emit,
  ) async {
    try {
      await recentSearchesBox.put('searches', <String>[]);
      emit(const RecentSearchesLoaded([]));
    } catch (e) {
      emit(RecentSearchesError(e.toString()));
    }
  }
}
