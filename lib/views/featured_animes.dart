import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/components/view_all_header.dart';
import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/models/anime.dart';
import '/providers/anime_providers.dart';
import '/screens/view_all_animes_screen.dart';
import '/widgets/anime_tile.dart';

class FeaturedAnimes extends ConsumerWidget {
  const FeaturedAnimes({
    super.key,
    required this.rankingType,
    required this.label,
  });

  final String rankingType;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAnimes = ref.watch(getAnimeByRankingProvider(rankingType));

    return allAnimes.when(
      data: (animes) {
        return Column(
          children: [
            // Title part
            ViewAllHeader(
              title: label,
              onViewAllClicked: () {
                context.push(ViewAllAnimesScreen.routeName, extra: {
                  'rankingType': rankingType,
                  'label': label,
                });
              },
            ),

            //! Animes List View
            AnimesListView(
              animes: animes.toList(),
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

class AnimesListView extends StatelessWidget {
  const AnimesListView({
    super.key,
    required this.animes,
  });

  final List<Anime> animes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: animes.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (context, index) {
          final anime = animes.elementAt(index);

          return AnimeTile(
            anime: anime.node,
          );
        },
      ),
    );
  }
}
