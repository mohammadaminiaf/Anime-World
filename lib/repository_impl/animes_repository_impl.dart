import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '/models/anime.dart';

import '/repositories/animes_repository.dart';

class AnimesRepositoryImpl implements AnimesRepository {
  //! Method to fetch all animes
  @override
  Future<Iterable<Anime>> fetchAnimesByRanking({
    required String rankingType,
    required int limit,
  }) async {
    final baseUrl =
        'https://api.myanimelist.net/v2/anime/ranking?ranking_type=$rankingType&limit=$limit';

    final clientId = dotenv.env['CLIENT_SECRET'] ?? '';

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'X-MAL-CLIENT-ID': clientId,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> animeNodeList = data['data'];
      final animes = animeNodeList
          .where(
        // Some animes miss main picture so it broke the list view
        // and sometimes even the entire list, and sadly when I checked
        // if the entire node was null, it passes.
        (animeNode) => animeNode['node']['main_picture'] != null,
      )
          .map(
        (node) {
          return Anime.fromJson(node);
        },
      );

      return animes;
    } else {
      debugPrint("Error: ${response.statusCode}");
      debugPrint("Body: ${response.body}");
      throw Exception("Failed to get data!");
    }
  }
}
