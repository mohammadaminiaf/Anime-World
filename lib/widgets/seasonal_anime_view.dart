import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/components/view_all_header.dart';
import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/models/anime.dart';
import '/screens/anime_details_screen.dart';
import '/screens/view_all_seasonal_animes_screen.dart';
import '/widgets/anime_tile.dart';
import '../providers/anime_providers.dart';

class SeasonalAnimeView extends ConsumerWidget {
  const SeasonalAnimeView({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonalAnimes = ref.watch(getSeasonalAnimesProvider);

    final categoryTitle = ViewAllHeader(
      title: label,
      onViewAllClicked: () {
        Navigator.of(context).pushNamed(
          ViewAllSeasonalAnimesScreen.routeName,
          arguments: {'label': label},
        );
      },
    );

    return seasonalAnimes.when(
      data: (animes) {
        return Column(
          children: [
            // Top Animes this Season + View all
            categoryTitle,
            // Image Slider
            AnimeListView(
              animes: animes,
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        return ErrorScreen(error: error.toString());
      },
      loading: () {
        return const Loader();
      },
    );
  }
}

class AnimeListView extends StatelessWidget {
  const AnimeListView({
    super.key,
    required this.animes,
  });

  final Iterable<Anime> animes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        itemCount: animes.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (context, index) {
          final anime = animes.elementAt(index);
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                AnimeDetailsScreen.routeName,
                arguments: anime.node.id,
              );
            },
            child: AnimeTile(anime: anime.node),
          );
        },
      ),
    );
  }
}
