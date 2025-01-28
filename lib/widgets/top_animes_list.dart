import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/providers/fetch_animes_by_ranking_provider.dart';
import '/widgets/top_animes_image_slider.dart';

class TopAnimesList extends ConsumerWidget {
  const TopAnimesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animeData = ref.watch(fetchAllRankingAnimesProvider(
      RankingAnimeParams(rankingType: 'all', limit: 4),
    ));

    return animeData.when(
      data: (animes) {
        return TopAnimesImageSlider(
          animes: animes.toList() ?? [],
        );
      },
      error: (error, stackTrace) => ErrorScreen(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
