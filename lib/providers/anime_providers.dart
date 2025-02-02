import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/locator.dart';
import '/models/anime_details.dart';
import '/repositories/animes_repository.dart';

//! Anime Details
final animeDetailsProvider =
    FutureProvider.autoDispose.family<AnimeDetails, int?>((ref, id) {
  final animesRepo = getIt.get<AnimesRepository>();
  return animesRepo.fetchAnimeById(id ?? 0);
});
