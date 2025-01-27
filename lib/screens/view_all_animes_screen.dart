import 'package:anime_world/models/enums/data_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '../notifiers/animes_notifier.dart';
import '/views/ranked_animes_list_view.dart';

class ViewAllAnimesScreen extends ConsumerStatefulWidget {
  const ViewAllAnimesScreen({
    super.key,
    required this.rankingType,
    required this.label,
  });

  final String rankingType;
  final String label;

  static const routeName = '/view-all-animes';

  @override
  ConsumerState<ViewAllAnimesScreen> createState() =>
      _ViewAllAnimesScreenState();
}

class _ViewAllAnimesScreenState extends ConsumerState<ViewAllAnimesScreen> {
  @override
  void initState() {
    Future.microtask(
      () => ref.read(animesProvider.notifier).fetchAllAnimes(
            rankingType: widget.rankingType,
          ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(animesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          if (state.status == DataStatus.loading) return const Loader();
          if (state.status == DataStatus.error) {
            return ErrorScreen(
              error: state.error.toString(),
            );
          }

          final animes = state.animes ?? [];

          return RankedAnimesListView(
            animes: animes,
            rankingType: widget.rankingType,
            isLoadingMore: state.status == DataStatus.loadingMore,
          );
        },
      ),
    );
  }
}
