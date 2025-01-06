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
            limit: 500,
          ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allAnimes = ref.watch(animesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label),
      ),
      body: allAnimes.when(
        data: (animes) {
          return RankedAnimesListView(animes: animes);
        },
        error: (error, stackTrace) {
          return ErrorScreen(error: error.toString());
        },
        loading: () => const Loader(),
      ),
    );
  }
}
