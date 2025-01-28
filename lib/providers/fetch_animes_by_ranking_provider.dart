import 'package:anime_world/locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/anime.dart';
import '/repositories/animes_repository.dart';

class RankingAnimeParams {
  final String rankingType;
  final int limit;

  RankingAnimeParams({
    required this.rankingType,
    required this.limit,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingAnimeParams &&
          runtimeType == other.runtimeType &&
          rankingType == other.rankingType &&
          limit == other.limit;

  @override
  int get hashCode => rankingType.hashCode ^ limit.hashCode;
}

final fetchAllRankingAnimesProvider =
    FutureProvider.family<List<Anime>, RankingAnimeParams>((ref, params) async {
  final rankingType = params.rankingType;
  final limit = params.limit;
  final animesRepo = getIt.get<AnimesRepository>();

  final response = await animesRepo.fetchAnimesByRanking(
    rankingType: rankingType,
    limit: limit,
    nextPageUrl: null,
  );

  if (response.data.isNotEmpty) {
    final animes = response.data;

    return animes;
  } else {
    return [];
  }
});
