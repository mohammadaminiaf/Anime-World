import 'package:equatable/equatable.dart';

import '/models/anime.dart';

class SeasonalAnimesState extends Equatable {
  final List<Anime> animes;
  final bool isLoading;
  final bool hasMore;
  final String? nextPageUrl;
  final String? error;

  const SeasonalAnimesState({
    this.animes = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.nextPageUrl,
    this.error,
  });

  SeasonalAnimesState copyWith({
    List<Anime>? animes,
    bool? isLoading,
    bool? hasMore,
    String? nextPageUrl,
    String? error,
  }) {
    return SeasonalAnimesState(
      animes: animes ?? this.animes,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        animes,
        isLoading,
        hasMore,
        nextPageUrl,
        error,
      ];
}
