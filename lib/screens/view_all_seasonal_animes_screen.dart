import 'package:anime_world/notifiers/seasonal_animes/seasonal_animes_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '../views/anime_list_view.dart';

class ViewAllSeasonalAnimesScreen extends ConsumerStatefulWidget {
  const ViewAllSeasonalAnimesScreen({
    super.key,
    required this.label,
  });

  final String label;

  static const routeName = '/view-all-seasonal-animes';

  @override
  ConsumerState<ViewAllSeasonalAnimesScreen> createState() =>
      _ViewAllSeasonalAnimesScreenState();
}

class _ViewAllSeasonalAnimesScreenState
    extends ConsumerState<ViewAllSeasonalAnimesScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_paginate);
    Future.microtask(() {
      ref
          .read(seasonalAnimesNotifierProvider.notifier)
          .fetchSeasonalAnimes(limit: 12);
    });
  }

  void _paginate() {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      ref
          .read(seasonalAnimesNotifierProvider.notifier)
          .fetchSeasonalAnimes(limit: 12);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seasonalAnimesNotifierProvider);

    if (state.isLoading && state.animes.isEmpty) return const Loader();
    if (state.error != null) return ErrorScreen(error: state.error!);

    final animes = state.animes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top animes'),
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          AnimeListView(animes: animes),
          if (state.isLoading && state.hasMore && state.animes.isNotEmpty)
            const SliverToBoxAdapter(child: Loader())
        ],
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
