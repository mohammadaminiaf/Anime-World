import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/locator.dart';
import 'search_animes_state.dart';
import '/repositories/animes_repository.dart';

class SearchNotifier extends StateNotifier<SearchAnimesState> {
  final AnimesRepository animesRepo;

  SearchNotifier({required this.animesRepo}) : super(const SearchAnimesState());

  Future<void> searchAnimes(String query, {int limit = 10}) async {
    if (query.isEmpty) return;

    state = state.copyWith(status: SearchStatus.loading);

    try {
      final results = await animesRepo.fetchAnimesBySearch(
        query: query,
        pageNum: 1,
        // limit: limit,
      );

      state = state.copyWith(
        status: SearchStatus.loaded,
        results: results.data,
        currentPage: 1,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loadMore(String query, {int limit = 10}) async {
    if (state.status == SearchStatus.loadingMore) return;

    state = state.copyWith(status: SearchStatus.loadingMore);

    try {
      final nextPage = state.currentPage + 1;

      final results = await animesRepo.fetchAnimesBySearch(
        query: query,
        pageNum: nextPage,
        // limit: limit,
      );

      final animes = results.data;

      state = state.copyWith(
        status: SearchStatus.loadingMore,
        results: [...state.results, ...animes],
        currentPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchAnimesState>((ref) {
  return SearchNotifier(animesRepo: getIt.get<AnimesRepository>());
});
