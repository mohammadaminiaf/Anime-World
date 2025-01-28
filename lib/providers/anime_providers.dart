import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/api/get_seasonal_animes_api.dart';
import '/locator.dart';
import '/models/anime_details.dart';
import '/repositories/animes_repository.dart';

//! Seasonal Anime
final getSeasonalAnimesProvider = FutureProvider((ref) {
  return getSeasonalAnimesApi(limit: 500);
});

// //! Animes By Ranking
// final getAnimeByRankingProvider = FutureProvider.autoDispose
//     .family<Iterable<Anime>, String>((ref, rankingType) {
//   return getAnimeByRankingTypeApi(
//     rankingType: rankingType,
//     limit: 500,
//   );
// });

//! Anime Details
final animeDetailsProvider =
    FutureProvider.autoDispose.family<AnimeDetails, int?>((ref, id) {
  final animesRepo = getIt.get<AnimesRepository>();
  return animesRepo.fetchAnimeById(id ?? 0);
});
