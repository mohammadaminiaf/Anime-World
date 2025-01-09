import 'package:anime_world/common/models/pagination.dart';
import 'package:anime_world/locator.dart';
import 'package:anime_world/models/movies/movie.dart';
import 'package:anime_world/notifiers/favorite_animes_state.dart';
import 'package:anime_world/repositories/animes_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteAnimesNotifier extends StateNotifier<FavoriteAnimesState> {
  final AnimesRepository animesRepo;
  Pagination pagination = Pagination(currentPage: 1, lastPage: 0);

  FavoriteAnimesNotifier({required this.animesRepo})
      : super(const FavoriteAnimesState());

  /// Initialize and fetch initial data
  Future<void> init() async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await animesRepo.fetchFavoriteAnimes(1);
      pagination.currentPage = response.currentPage ?? 1;
      pagination.lastPage = response.lastPage ?? 0;

      state = state.copyWith(
        isLoading: false,
        animes: response.data,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchFavoriteAnimes(bool isFirstFetch) async {
    try {
      if (isFirstFetch) {
        state = state.copyWith(isLoading: true);

        final response = await animesRepo.fetchFavoriteAnimes(1);
        pagination.currentPage = response.currentPage ?? 1;
        pagination.lastPage = response.lastPage ?? 0;

        state = state.copyWith(
          isLoading: false,
          animes: response.data,
        );
      } else {
        if (pagination.currentPage >= pagination.lastPage) return;

        state = state.copyWith(isLoadingMore: true);

        final newPage = pagination.currentPage + 1;
        final response = await animesRepo.fetchFavoriteAnimes(newPage);
        pagination.currentPage = response.currentPage ?? 1;
        pagination.lastPage = response.lastPage ?? 0;

        state = state.copyWith(
          isLoadingMore: false,
          animes: List.of(state.animes)..addAll(response.data),
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> addFavoriteAnime({required Movie movie}) async {
    try {
      state = state.copyWith(isAdding: true);

      final favoriteMovie = await animesRepo.createFavoriteAnime(movie: movie);

      state = state.copyWith(
        isAdding: false,
        animes: List.of(state.animes)..add(favoriteMovie),
      );
    } catch (e) {
      state = state.copyWith(
        isAdding: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> removeFavoriteAnime({required int id}) async {
    try {
      state = state.copyWith(isRemoving: true);

      await animesRepo.deleteFavoriteAnime(id: id);

      state = state.copyWith(
        isRemoving: false,
        animes: List.of(state.animes)..removeWhere((anime) => anime.id == id),
      );
    } catch (e) {
      state = state.copyWith(
        isRemoving: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final favoriteAnimesProvider = StateNotifierProvider.autoDispose<
    FavoriteAnimesNotifier, FavoriteAnimesState>(
  (ref) {
    final notifier = FavoriteAnimesNotifier(
      animesRepo: getIt.get<AnimesRepository>(),
    );
    notifier.init(); // Trigger the initial fetch
    return notifier;
  },
);
