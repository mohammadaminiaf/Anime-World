import 'package:anime_world/notifiers/animes_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/models/anime_category.dart';
import '/views/animes_grid_list.dart';

class AnimeGridView extends ConsumerWidget {
  const AnimeGridView({
    super.key,
    required this.category,
  });

  final AnimeCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animes = ref.watch(animesProvider).animes;

    return AnimesGridList(
      title: category.title,
      animes: animes!,
    );
  }
}
