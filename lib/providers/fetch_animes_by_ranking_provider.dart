import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/anime.dart';

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

  final clientId = dotenv.env['CLIENT_ID'] ?? '';
  final dio = Dio()
    ..options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-MAL-CLIENT-ID': clientId,
    };

  const baseUrl = 'https://api.myanimelist.net/v2/';
  final urlProperties =
      'anime/ranking?ranking_type=$rankingType&limit=$limit&offset=0';
  final fullUrl = baseUrl + urlProperties;

  final response = await dio.get(fullUrl);

  if (response.statusCode == 200) {
    final List animesData = response.data['data'];
    final animes = (animesData).map(
      (animeData) {
        return Anime.fromJson(animeData);
      },
    ).toList();

    return animes;
  } else {
    return [];
  }
});
