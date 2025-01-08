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

  //! Methods to work with favorite animes
  Future<List<Movie>> fetchFavoriteAnimes();
  Future<Movie> createFavoriteAnime({required Movie movie});
  Future<void> deleteFavoriteAnime({required int id});
}
