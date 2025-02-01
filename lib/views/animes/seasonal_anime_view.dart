import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/components/view_all_header.dart';
import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/providers/fetch_seasonal_animes_provider.dart';
import '/screens/view_all_seasonal_animes_screen.dart';
import '/views/animes/animes_list_view_hor.dart';
// import '/views/anime_list_view.dart';

class SeasonalAnimeView extends ConsumerWidget {
  const SeasonalAnimeView({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonalAnimes = ref.watch(fetchSeasonalAnimesProvider(12));

    final categoryTitle = ViewAllHeader(
      title: label,
      onViewAllClicked: () {
        context.push(
          ViewAllSeasonalAnimesScreen.routeName,
          extra: {'label': label},
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
            AnimesListView(
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
