import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '/common/utils/utils.dart';
import '/models/anime.dart';
import '/models/anime_info.dart';

Future<Iterable<Anime>> getSeasonalAnimesApi({
  required int limit,
}) async {
  final year = DateTime.now().year;
  final season = getCurrentSeason();
  final baseUrl =
      "https://api.myanimelist.net/v2/anime/season/$year/$season?limit=$limit";
  final clientId = dotenv.env['CLIENT_ID'] ?? '';

  // Make a GET request
  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {
      'X-MAL-CLIENT-ID': clientId,
    },
  );

  if (response.statusCode == 200) {
    // Successful response
    final Map<String, dynamic> data = json.decode(response.body);
    final seasonalAnime = AnimeInfo.fromJson(data);

    return seasonalAnime.animes;
  } else {
    // Error handling
    debugPrint("Error: ${response.statusCode}");
    debugPrint("Body: ${response.body}");
    throw Exception("Failed to get data!");
  }
}
