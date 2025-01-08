import 'dart:async';

import 'package:anime_world/common/models/pagination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/locator.dart';
import '/models/movies/movie.dart';
import '/repositories/animes_repository.dart';

class FavoriteAnimesNotifier extends AutoDisposeAsyncNotifier<List<Movie>> {
  final AnimesRepository animesRepo;
  FavoriteAnimesNotifier({required this.animesRepo});

  Pagination pagination = Pagination(currentPage: 1, lastPage: 0);

  @override
  FutureOr<List<Movie>> build() async {
    final animes = await getAllFavoriteAnimes(true);
    return animes;
  }

  /// Get all favorite animes
  Future<List<Movie>> getAllFavoriteAnimes(bool isFirstFetch) async {
    try {
      if (isFirstFetch) {
        state = const AsyncLoading();

        final response = await animesRepo.fetchFavoriteAnimes(1);
        pagination.currentPage = response.currentPage ?? 1;
        pagination.lastPage = response.lastPage ?? 0;

        final favoriteAnimes = response.data;

        state = AsyncData(favoriteAnimes);

        return favoriteAnimes;
      } else {
        if (pagination.currentPage >= pagination.lastPage) return [];

        final newPage = pagination.currentPage + 1;
        final response = await animesRepo.fetchFavoriteAnimes(newPage);
        pagination.currentPage = response.currentPage ?? 1;
        pagination.lastPage = response.lastPage ?? 0;

        final favoriteAnimes = response.data;
        final currentAnimes = state.value ?? [];

        final updatedAnimes = List<Movie>.from(currentAnimes)
          ..addAll(favoriteAnimes);

        state = AsyncData(updatedAnimes);

        return updatedAnimes;
      }
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
