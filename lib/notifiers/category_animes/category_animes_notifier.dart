import 'package:anime_world/locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/anime.dart';
import '/repositories/animes_repository.dart';

part 'category_animes_state.dart';

class CategoryAnimesNotifier
    extends StateNotifier<Map<String, CategoryAnimesState>> {
  final AnimesRepository animesRepo;

  CategoryAnimesNotifier(this.animesRepo) : super({});

  Future<void> fetchAnimes(String rankingType, {int limit = 20}) async {
    // If data already exists for this rankingType, prevent refetching
    final currentState = state[rankingType] ?? CategoryAnimesState();
    if (currentState.isLoading || !currentState.hasMore) return;

    // Update state to indicate loading
    state = {
      ...state,
      rankingType: currentState.copyWith(isLoading: true, error: null),
    };

    try {
      // Fetch data from the API
      final response = await animesRepo.fetchAnimesByRanking(
        rankingType: rankingType,
        nextPageUrl: currentState.nextPageUrl,
        limit: limit,
      );

      // Append new data to existing data
      final newAnimes = [...currentState.animes, ...response.data];
      final hasMore = response.nextPageUrl != null;

      // Update state with the new data
      state = {
        ...state,
        rankingType: currentState.copyWith(
          animes: newAnimes,
          isLoading: false,
          hasMore: hasMore,
          nextPageUrl: response.nextPageUrl,
        ),
      };
    } catch (e) {
      // Handle error
      state = {
        ...state,
        rankingType: currentState.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      };
    }
  }

  void resetTab(String rankingType) {
    state = {
      ...state,
      rankingType: CategoryAnimesState(), // Reset state for this tab
    };
  }
}

final categoryAnimesProvider = StateNotifierProvider<CategoryAnimesNotifier,
    Map<String, CategoryAnimesState>>(
  (ref) {
    final animesRepo = getIt.get<AnimesRepository>();
    return CategoryAnimesNotifier(animesRepo);
  },
);
