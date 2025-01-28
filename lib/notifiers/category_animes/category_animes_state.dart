part of 'category_animes_notifier.dart';

class CategoryAnimesState {
  final List<Anime> animes;
  final bool isLoading;
  final bool hasMore;
  final String? nextPageUrl;
  final String? error;

  CategoryAnimesState({
    this.animes = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.nextPageUrl,
    this.error,
  });

  CategoryAnimesState copyWith({
    List<Anime>? animes,
    bool? isLoading,
    bool? hasMore,
    String? nextPageUrl,
    String? error,
  }) {
    return CategoryAnimesState(
      animes: animes ?? this.animes,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      error: error,
    );
  }
}
