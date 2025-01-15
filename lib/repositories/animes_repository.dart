import '/common/models/pagination_data.dart';
import '/models/anime.dart';
import '/models/anime_details.dart';
import '/models/movies/movie.dart';

abstract class AnimesRepository {
  /// Fetchesanimes by ranking type [all, airing, upcoming, tv, movie, ova, special, bypopularity, favorite]
  Future<Iterable<Anime>> fetchAnimesByRanking({
    required String rankingType,
    required int limit,
  });

  /// Fetches a single anime by its id
  Future<AnimeDetails> fetchAnimeById(int id);

  /// Fetch animes by a search query
  Future<PaginationData<Anime>> fetchAnimesBySearch({
    required String query,
    required int pageNum,
  });

  //! Methods to work with favorite animes
  Future<PaginationData<Movie>> fetchFavoriteAnimes(int pageNum);
  Future<Movie> createFavoriteAnime({required Movie movie});
  Future<void> deleteFavoriteAnime({required int id});

  //! Viewed animes
  Future<void> createViewedMovie({required Movie movie});
}
