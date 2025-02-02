import 'package:anime_world/screens/screen_anime_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/models/movies/movie.dart';
import '../../notifiers/favorite_animes/favorite_animes_notifier.dart';

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
      body: Consumer(
        builder: (context, ref, child) {
          if (animesData.isLoading) {
            return const Loader();
          } else if (animesData.errorMessage != null) {
            return ErrorScreen(error: animesData.errorMessage!);
          } else {
            return FavoriteAnimesView(animes: animesData.animes);
          }
        },
      ),
    );
  }
}

class FavoriteAnimesView extends ConsumerStatefulWidget {
  const FavoriteAnimesView({
    super.key,
    required this.animes,
  });

  final List<Movie> animes;

  @override
  ConsumerState<FavoriteAnimesView> createState() => _FavoriteAnimesViewState();
}

class _FavoriteAnimesViewState extends ConsumerState<FavoriteAnimesView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handlePagination);
  }

  void _handlePagination() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      ref.read(favoriteAnimesProvider.notifier).fetchFavoriteAnimes(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.animes.length,
      itemBuilder: (context, index) {
        final anime = widget.animes[index];

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
    return GestureDetector(
      onTap: () {
        context.push(ScreenAnimeDetails.routeName, extra: anime.id);
      },
      child: Card(
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
      ),
    );
  }
}
