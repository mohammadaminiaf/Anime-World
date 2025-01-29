import 'package:anime_world/locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/common/models/pagination.dart';
import '/notifiers/seasonal_animes/seasonal_animes_state.dart';
import '/repositories/animes_repository.dart';

class SeasonalAnimesNotifier extends StateNotifier<SeasonalAnimesState> {
  final AnimesRepository animesRepo;

  SeasonalAnimesNotifier({
    required this.animesRepo,
  }) : super(const SeasonalAnimesState());

  final Pagination pagination = Pagination(nextPageUrl: null);

  // Fetch all animes
  Future<void> fetchSeasonalAnimes({required int limit}) async {
    try {
      // If it's already loading or have no more data stop.
      if (state.isLoading || !state.hasMore) return;

      state = state.copyWith(isLoading: true);

      // Fetch all animes (first page or next page)
      final allAnimes = await animesRepo.fetchSeasonalAnimes(
        limit: limit,
        nextPageUrl: state.nextPageUrl,
      );

      final updatedAnimes = List.of(state.animes)..addAll(allAnimes.data);
      final hasMore = allAnimes.nextPageUrl != null;

      state = state.copyWith(
        animes: updatedAnimes,
        isLoading: false,
        hasMore: hasMore,
        nextPageUrl: allAnimes.nextPageUrl,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final seasonalAnimesNotifierProvider =
    StateNotifierProvider<SeasonalAnimesNotifier, SeasonalAnimesState>((ref) {
  final animesRepo = getIt.get<AnimesRepository>();
  return SeasonalAnimesNotifier(animesRepo: animesRepo);
});
