import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '/models/anime.dart';
import '/models/anime_details.dart';
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

    final clientId = dotenv.env['CLIENT_ID'] ?? '';

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

  //! Method to fetch details for a specific anime
  @override
  Future<AnimeDetails> fetchAnimeById(int id) async {
    try {
      final baseUrl =
          'https://api.myanimelist.net/v2/anime/$id?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics';

      final clientId = dotenv.env['CLIENT_ID'] ?? '';

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'X-MAL-CLIENT-ID': clientId,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final animeDetails = AnimeDetails.fromJson(data);
        return animeDetails;
      } else {
        debugPrint('Code: ${response.statusCode}');
        debugPrint('Error: ${response.body}');
        throw Exception('Could Not Get Data!');
      }
    } catch (e) {
      rethrow;
    }
  }
}
