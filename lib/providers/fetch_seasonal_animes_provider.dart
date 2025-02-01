import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/locator.dart';
import '/models/anime.dart';
import '/repositories/animes_repository.dart';

final fetchSeasonalAnimesProvider = FutureProvider.family<List<Anime>, int>(
  (ref, int limit) async {
    final animesRepo = getIt.get<AnimesRepository>();
    final animes = await animesRepo.fetchSeasonalAnimes(limit: limit);

    return animes.data;
  },
);
