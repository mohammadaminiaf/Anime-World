import 'package:anime_world/common/buttons/flat_button.dart';
import 'package:anime_world/models/anime_node.dart';
import 'package:anime_world/models/movies/movie.dart';
import 'package:anime_world/notifiers/favorite_animes_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/common/extensions/extensions.dart';
import '/common/screens/screen_full_images_view.dart';
import '/common/styles/paddings.dart';
import '/common/styles/text_styles.dart';
import '/common/widgets/ios_back_button.dart';
import '../common/widgets/screen_image_view.dart';
import '/common/widgets/read_more_text.dart';
import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/cubits/anime_title_language_cubit.dart';
import '/models/anime_details.dart';
import '/models/picture.dart';
import '/providers/anime_providers.dart';
import '/views/anime_horizontal_list_view.dart';

class ScreenAnimeDetails extends ConsumerWidget {
  static const routeName = '/screen-anime-details';

  const ScreenAnimeDetails({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animeProvider = ref.watch(animeDetailsProvider(id));

    return Scaffold(
      body: animeProvider.when(
        data: (anime) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnimeImage(
                  imageUrl: anime.mainPicture.large,
                  context: context,
                ),
                Padding(
                  padding: Paddings.defaultPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAddToFavoritesButton(anime),
                      // Title
                      _buildAnimeName(
                        defaultName: anime.title,
                        englishName: anime.alternativeTitles.en,
                      ),

                      const SizedBox(height: 20),

                      // Description
                      ReadMoreText(
                        longText: anime.synopsis,
                      ),

                      const SizedBox(height: 10),

                      _buildAnimeInfo(
                        anime: anime,
                      ),

                      const SizedBox(height: 20),

                      anime.background.isNotEmpty
                          ? _buildAnimeBackground(
                              background: anime.background,
                            )
                          : const SizedBox.shrink(),

                      const SizedBox(height: 20),

                      _buildAnimeImages(pictures: anime.pictures),

                      const SizedBox(height: 20),

                      // Related Animes
                      AnimeHorizontalListView(
                        title: 'Related Animes',
                        animes: anime.relatedAnime
                            .map((relatedAnime) => relatedAnime.node)
                            .toList(),
                      ),

                      const SizedBox(height: 20),

                      // Recommendations
                      AnimeHorizontalListView(
                        title: 'Recommendations',
                        animes: anime.recommendations
                            .map((recommendation) => recommendation.node)
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => ErrorScreen(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }

  Widget _buildAddToFavoritesButton(AnimeDetails anime) {
    return Consumer(builder: (context, ref, child) {
      final favoriteAnimes = ref.watch(favoriteAnimesProvider);

      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: FlatButton(
          isLoading: favoriteAnimes.isLoading,
          onPressed: () async {
            final movie = Movie(
              id: anime.id,
              title: anime.title,
              englishTitle: anime.alternativeTitles.en,
              imageUrl: anime.mainPicture.medium,
              genres: anime.genres.map((genre) => genre.name).toList(),
              rating: anime.mean,
            );

            await ref
                .read(favoriteAnimesProvider.notifier)
                .addFavoriteAnime(movie: movie);
          },
          label: 'Add to Favorite',
        ),
      );
    });
  }

  Widget _buildAnimeImage({
    required String imageUrl,
    required BuildContext context,
  }) =>
      Stack(
        children: [
          InkWell(
            onTap: () {
              context.push(ScreenImageView.routeName, extra: imageUrl);
            },
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              height: 400,
              width: double.infinity,
            ),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: Builder(builder: (context) {
              return IosBackButton(
                onPressed: Navigator.of(context).pop,
              );
            }),
          ),
        ],
      );

  Widget _buildAnimeName({
    required String englishName,
    required String defaultName,
  }) =>
      BlocBuilder<AnimeTitleLanguageCubit, bool>(
        builder: (context, state) {
          return Text(
            state ? englishName : defaultName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          );
        },
      );

  Widget _buildAnimeInfo({
    required AnimeDetails anime,
  }) {
    String studios = anime.studios.map((studio) => studio.name).join(', ');
    String genres = anime.genres.map((genre) => genre.name).join(', ');
    String otherNames =
        anime.alternativeTitles.synonyms.map((title) => title).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoText(label: 'Genres: ', info: genres),
        InfoText(label: 'Start date: ', info: anime.startDate),
        InfoText(label: 'End date: ', info: anime.endDate),
        InfoText(label: 'Episodes: ', info: anime.numEpisodes.toString()),
        InfoText(
          label: 'Average Episode Duration: ',
          info: anime.averageEpisodeDuration.toMinute(),
        ),
        InfoText(label: 'Status: ', info: anime.status),
        InfoText(label: 'Rating: ', info: anime.rating),
        InfoText(label: 'Studios: ', info: studios),
        InfoText(label: 'Other Names: ', info: otherNames),
        InfoText(label: 'English Name: ', info: anime.alternativeTitles.en),
        InfoText(label: 'Japanese Name: ', info: anime.alternativeTitles.ja),
      ],
    );
  }

  Widget _buildAnimeBackground({
    required String background,
  }) {
    return WhiteContainer(
      child: Text(
        background,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildAnimeImages({
    required List<Picture> pictures,
  }) {
    return Column(
      children: [
        Text(
          'Image Gallery',
          style: TextStyles.smallText,
        ),
        GridView.builder(
          itemCount: pictures.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 9 / 16,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final image = pictures[index].medium;
            return SizedBox(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    context.push(
                      ScreenFullImagesView.routeName,
                      extra: {
                        'images': pictures.map((e) => e.large).toList(),
                        'index': index,
                      },
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class InfoText extends StatelessWidget {
  const InfoText({
    super.key,
    required this.label,
    required this.info,
  });

  final String label;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return RichText(
        text: TextSpan(
          text: label,
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: info,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    });
  }
}

class WhiteContainer extends StatelessWidget {
  const WhiteContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.white54,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
