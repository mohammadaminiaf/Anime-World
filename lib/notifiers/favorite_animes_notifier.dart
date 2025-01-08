import 'dart:async';

import 'package:anime_world/locator.dart';
import 'package:anime_world/repositories/animes_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/movies/movie.dart';

class FavoriteAnimesNotifier extends AutoDisposeAsyncNotifier<List<Movie>> {
  final AnimesRepository animesRepo;
  FavoriteAnimesNotifier({required this.animesRepo});

  @override
  FutureOr<List<Movie>> build() async {
    final animes = await getAllFavoriteAnimes();
    return animes;
  }

  /// Get all favorite animes
  Future<List<Movie>> getAllFavoriteAnimes() async {
    try {
      state = const AsyncLoading();

      final favoriteAnimes = await animesRepo.fetchFavoriteAnimes();

      state = AsyncData(favoriteAnimes);

      return favoriteAnimes;
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }

    return [];
  }

  // Add a favorite movie
  Future<void> addFavoriteAnime({required Movie movie}) async {
    try {
      state = const AsyncLoading();

      final favoriteMovie = await animesRepo.createFavoriteAnime(movie: movie);
      final animes = state.value ?? [];
      animes.add(favoriteMovie);

      state = AsyncData(animes);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  // Remove a favorite anime
  Future<void> removeFavoriteAnime({required int id}) async {
    try {
      state = const AsyncLoading();

      await animesRepo.deleteFavoriteAnime(id: id);

      final movies = state.value?.cast<Movie>() ?? [];
      final List<Movie> updatedAnimes = List.from(
        movies.where((anime) => anime.id != id).toList() ?? [],
      );

      state = AsyncData(updatedAnimes);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}

final favoriteAnimesProvider =
    AsyncNotifierProvider.autoDispose<FavoriteAnimesNotifier, List<Movie>>(
  () {
    return FavoriteAnimesNotifier(
      animesRepo: getIt.get<AnimesRepository>(),
    );
  },
);
