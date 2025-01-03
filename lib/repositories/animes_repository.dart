import '/models/anime.dart';
import '/models/anime_details.dart';

abstract class AnimesRepository {
  /// Fetchesanimes by ranking type [all, airing, upcoming, tv, movie, ova, special, bypopularity, favorite]
  Future<Iterable<Anime>> fetchAnimesByRanking({
    required String rankingType,
    required int limit,
  });

  /// Fetches a single anime by its id
  Future<AnimeDetails> fetchAnimeById(int id);
}
