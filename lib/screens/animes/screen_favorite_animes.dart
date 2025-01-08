import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/models/movies/movie.dart';
import '/notifiers/favorite_animes_notifier.dart';

class ScreenFavoriteAnimes extends ConsumerWidget {
  const ScreenFavoriteAnimes({super.key});

  static const routeName = '/screen-favorite-animes';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animesData = ref.watch(favoriteAnimesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Animes'),
      ),
      body: animesData.when(
        data: (animes) {
          return FavoriteAnimesView(animes: animes);
        },
        error: (error, stackTrace) {
          return ErrorScreen(error: error.toString());
        },
        loading: () {
          return const Loader();
        },
      ),
    );
  }
}

class FavoriteAnimesView extends StatelessWidget {
  const FavoriteAnimesView({
    super.key,
    required this.animes,
  });

  final List<Movie> animes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: animes.length,
      itemBuilder: (context, index) {
        final anime = animes[index];

        return FavoriteAnimeCard(
          anime: anime,
        );
      },
    );
  }
}

class FavoriteAnimeCard extends StatelessWidget {
  final Movie anime;

  const FavoriteAnimeCard({
    super.key,
    required this.anime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: CachedNetworkImage(
              imageUrl: anime.imageUrl ?? '',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Title
                Text(
                  anime.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                // Genres
                Text(
                  anime.genres.join(', '),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 10),
                // Rating
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      anime.rating.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Consumer(builder: (context, ref, child) {
                      return IconButton(
                        onPressed: () async {
                          ref
                              .read(favoriteAnimesProvider.notifier)
                              .removeFavoriteAnime(id: anime.id);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
