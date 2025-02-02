import 'package:anime_world/models/movies/movie.dart';
import 'package:flutter/foundation.dart';

/// A custom state class to represent various states of the anime list
@immutable
class FavoriteAnimesState {
  final bool isLoading;
  final bool isLoadingMore;
  final bool isAdding;
  final bool isRemoving;
  final List<Movie> animes;
  final String? errorMessage;

  const FavoriteAnimesState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isAdding = false,
    this.isRemoving = false,
    this.animes = const [],
    this.errorMessage,
  });

  FavoriteAnimesState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isAdding,
    bool? isRemoving,
    List<Movie>? animes,
    String? errorMessage,
  }) {
    return FavoriteAnimesState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isAdding: isAdding ?? this.isAdding,
      isRemoving: isRemoving ?? this.isRemoving,
      animes: animes ?? this.animes,
      errorMessage: errorMessage,
    );
  }
}
