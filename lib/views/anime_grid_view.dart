import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/models/anime_category.dart';
import '/notifiers/category_animes/category_animes_notifier.dart';
import '/views/animes_grid_list.dart';

class AnimeGridView extends ConsumerStatefulWidget {
  const AnimeGridView({
    super.key,
    required this.category,
  });

  final AnimeCategory category;

  @override
  ConsumerState<AnimeGridView> createState() => _AnimeGridViewState();
}

class _AnimeGridViewState extends ConsumerState<AnimeGridView> {
  @override
  void initState() {
    super.initState();
    // Fetch initial data for the tab
    Future.microtask(() {
      ref
          .read(categoryAnimesProvider.notifier)
          .fetchAnimes(widget.category.rankingType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state =
        ref.watch(categoryAnimesProvider)[widget.category.rankingType] ??
            CategoryAnimesState();

    if (state.isLoading && state.animes.isEmpty) {
      return const Loader();
    }

    if (state.error != null) {
      return ErrorScreen(error: state.error!);
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            !state.isLoading &&
            state.hasMore) {
          // Load more data when reaching the end of the list
          ref
              .read(categoryAnimesProvider.notifier)
              .fetchAnimes(widget.category.rankingType);
        }
        return false;
      },
      child: AnimesGridList(
        title: widget.category.title,
        animes: state.animes,
      ),
    );
  }
}
