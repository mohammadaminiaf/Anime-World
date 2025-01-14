import 'dart:async';

import 'package:anime_world/locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/anime.dart';
import '/repositories/animes_repository.dart';

class AnimesNotifier extends AutoDisposeAsyncNotifier<Iterable<Anime>> {
  final AnimesRepository animesRepo;

  AnimesNotifier({required this.animesRepo});

  @override
  FutureOr<List<Anime>> build() {
    return [];
  }

  //! Fetch all animes list
  Future<void> fetchAllAnimes({
    required String rankingType,
    required int limit,
  }) async {
    try {
      state = const AsyncLoading();

      final allAnimes = await animesRepo.fetchAnimesByRanking(
        rankingType: rankingType,
        limit: limit,
      );

      if (allAnimes.isNotEmpty) {
        state = AsyncData(allAnimes);
      } else {
        state = AsyncError('No data found', StackTrace.current);
      }
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}

final animesProvider =
    AsyncNotifierProvider.autoDispose<AnimesNotifier, Iterable<Anime>>(
  () => AnimesNotifier(animesRepo: getIt.get<AnimesRepository>()),
);
