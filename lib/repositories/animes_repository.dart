import 'package:anime_world/models/anime.dart';

abstract class AnimesRepository {
  Future<Iterable<Anime>> fetchAnimesByRanking({
    required String rankingType,
    required int limit,
  });
}
