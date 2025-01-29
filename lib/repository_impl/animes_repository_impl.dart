import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '/common/models/api_response.dart';
import '/common/models/pagination_data.dart';
import '/common/services/dio_client.dart';
import '/common/services/mal_client.dart';
import '/common/utils/utils.dart';
import '/models/anime.dart';
import '/models/anime_details.dart';
import '/models/anime_info.dart';
import '/models/movies/movie.dart';
import '/repositories/animes_repository.dart';

class AnimesRepositoryImpl implements AnimesRepository {
  final DioClient dioService;
  final MalClient malService;

  AnimesRepositoryImpl({
    required this.dioService,
    required this.malService,
  });

  //! Method to fetch all animes
  @override
  Future<PaginationData<Anime>> fetchAnimesByRanking({
    required String rankingType,
    required String? nextPageUrl,
    int limit = 12,
  }) async {
    final baseUrl = nextPageUrl ??
        'anime/ranking?ranking_type=$rankingType&limit=$limit&offset=0';

    final response = await malService.dio.get(baseUrl);

    if (response.statusCode == 200) {
      final List animesData = response.data['data'];
      final animes = (animesData).map(
        (animeData) {
          return Anime.fromJson(animeData);
        },
      ).toList();

      final PaginationData<Anime> paginationData = PaginationData(
        data: animes,
        fromJson: Anime.fromJson,
        nextPageUrl: response.data['paging']['next'],
      );

      return paginationData;
    } else {
      debugPrint("Error: ${response.statusCode}");
      debugPrint("Body: ${response.data}");
      throw Exception("Failed to get data!");
    }
  }

  //! Fetch anime for a season
  @override
  Future<PaginationData<Anime>> fetchSeasonalAnimes({
    required int limit,
    String? nextPageUrl,
  }) async {
    try {
      final year = DateTime.now().year;
      final season = getCurrentSeason();
      final urlInfo =
          nextPageUrl ?? "anime/season/$year/$season?limit=$limit&offset=0";
      final response = await malService.dio.get(urlInfo);

      if (response.statusCode == 200) {
        // Successful response
        final data = response.data;
        final seasonalAnime = AnimeInfo.fromJson(data);

        final nextPageUrl = response.data['paging']['next'];

        final PaginationData<Anime> animesData = PaginationData(
          data: seasonalAnime.animes.toList(),
          fromJson: Anime.fromJson,
          nextPageUrl: nextPageUrl,
        );

        return animesData;
      } else {
        throw Exception("Failed to get data!");
      }
    } catch (e) {
      rethrow;
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

        // If animes details was opened successfully, add movie to viewed movies
        final movie = Movie(
          id: animeDetails.id,
          title: animeDetails.title,
          englishTitle: animeDetails.alternativeTitles.en,
          imageUrl: animeDetails.mainPicture.medium,
          genres: animeDetails.genres.map((genre) => genre.name).toList(),
          rating: animeDetails.mean,
        );
        await createViewedMovie(movie: movie);

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

  //! Method to fetch animes by a search query
  @override
  Future<PaginationData<Anime>> fetchAnimesBySearch({
    required String query,
    required int pageNum,
  }) async {
    try {
      final baseUrl = "https://api.myanimelist.net/v2/anime?q=$query&limit=10";
      final clientId = dotenv.env['CLIENT_ID'] ?? '';

      final response = await http.get(
        Uri.parse(baseUrl),
        // .replace(queryParameters: {
        //   'limit': 12,
        //   'offset': pageNum,
        // }),
        headers: {'X-MAL-CLIENT-ID': clientId},
      );

      if (response.statusCode == 200) {
        // Successful response
        final Map<String, dynamic> data = json.decode(response.body);
        AnimeInfo animeInfo = AnimeInfo.fromJson(data);
        List<Anime> animes = animeInfo.animes.toList();

        final PaginationData<Anime> animeData =
            PaginationData(data: animes, fromJson: Anime.fromJson);

        return animeData;
      } else {
        // Error handling
        debugPrint("Error: ${response.statusCode}");
        debugPrint("Body: ${response.body}");
        throw Exception("Failed to get data!");
      }
    } catch (e) {
      rethrow;
    }
  }

  //! Method to fetch only favorite animes
  @override
  Future<PaginationData<Movie>> fetchFavoriteAnimes(int pageNum) async {
    try {
      final response =
          await dioService.get('movies/favorite', queryParameters: {
        'page_num': pageNum,
        'page_size': 6,
      });
      final ApiResponse apiResponse = ApiResponse.fromJson(response.data);

      if (apiResponse.statusCode == 200) {
        final data = apiResponse.data;
        final favoriteAnimes = PaginationData.fromJson(data, Movie.fromJson);

        print('hello world');
        return favoriteAnimes;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to get favorite animes');
      }
    } catch (e) {
      rethrow;
    }
  }

  //! Method to add an anime as favorite
  @override
  Future<Movie> createFavoriteAnime({required Movie movie}) async {
    try {
      final response = await dioService.post(
        'movies/favorite',
        movie.toJson(),
      );
      final ApiResponse apiResponse = ApiResponse.fromJson(response.data);

      if (apiResponse.statusCode == 200) {
        final data = apiResponse.data;
        final anime = Movie.fromJson(data);

        return anime;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to get favorite animes');
      }
    } catch (e) {
      rethrow;
    }
  }

  //! Method to delete an anime from favorites
  @override
  Future<void> deleteFavoriteAnime({required int id}) async {
    try {
      final response = await dioService.delete('movies/favorite/$id', {});
      final ApiResponse apiResponse = ApiResponse.fromJson(response.data);

      if (apiResponse.statusCode != 200) {
        throw Exception(apiResponse.message ?? 'Failed to get favorite animes');
      }
    } catch (e) {
      rethrow;
    }
  }

  //! Add movie as viewed
  @override
  Future<void> createViewedMovie({
    required Movie movie,
  }) async {
    await dioService.post('movies/viewed', movie.toJson());
  }
}
