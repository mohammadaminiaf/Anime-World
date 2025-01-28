import 'package:anime_world/notifiers/animes_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../views/anime_list_view.dart';
import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/models/anime_category.dart';

class CategoryanimesScreen extends ConsumerStatefulWidget {
  const CategoryanimesScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  final AnimeCategory category;

  static const routeName = '/categories-anime';

  @override
  ConsumerState<CategoryanimesScreen> createState() =>
      _CategoryanimesScreenState();
}

class _CategoryanimesScreenState extends ConsumerState<CategoryanimesScreen> {
  @override
  void initState() {
    Future.microtask(
      () => ref.read(animesProvider.notifier).fetchAllAnimes(
            rankingType: widget.category.rankingType,
          ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final animes = ref.watch(animesProvider).animes;

    if (animes == null) return const Loader();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
      ),
      body: AnimeListView(
        animes: animes,
      ),
    );
  }
}
