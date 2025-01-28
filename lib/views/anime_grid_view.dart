import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/models/anime_category.dart';
import '/providers/fetch_animes_by_ranking_provider.dart';
import '/views/animes_grid_list.dart';

class AnimeGridView extends ConsumerWidget {
  const AnimeGridView({
    super.key,
    required this.category,
  });

  final AnimeCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Create specific notifiers here to display data and also show pagination

    final animeData = ref.watch(fetchAllRankingAnimesProvider(
      RankingAnimeParams(
        rankingType: category.rankingType,
        limit: 500,
      ),
    ));

    return animeData.when(
      data: (animes) {
        return AnimesGridList(
          title: category.title,
          animes: animes,
        );
      },
      error: (error, stackTrace) => ErrorScreen(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
