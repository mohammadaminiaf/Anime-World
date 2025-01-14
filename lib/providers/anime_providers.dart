import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/api/get_anime_by_ranking_type_api.dart';
import '/api/get_anime_by_search_api.dart';
import '/api/get_seasonal_animes_api.dart';
import '/locator.dart';
import '/models/anime.dart';
import '/models/anime_details.dart';
import '/repositories/animes_repository.dart';

//! Seasonal Anime
final getSeasonalAnimesProvider = FutureProvider((ref) {
  return getSeasonalAnimesApi(limit: 500);
});

//! Animes By Ranking
final getAnimeByRankingProvider = FutureProvider.autoDispose
    .family<Iterable<Anime>, String>((ref, rankingType) {
  return getAnimeByRankingTypeApi(
    rankingType: rankingType,
    limit: 500,
  );
});

//! Animes By Query
// final getAnimeBySearchProvider =
//     FutureProvider.autoDispose.family<Iterable<Anime>, String>(
//   (ref, query) {
//     return getAnimesbySearchApi(query: query);
//   },
// );

//! Anime Details
final animeDetailsProvider =
    FutureProvider.autoDispose.family<AnimeDetails, int?>((ref, id) {
  final animesRepo = getIt.get<AnimesRepository>();
  return animesRepo.fetchAnimeById(id ?? 0);
});
