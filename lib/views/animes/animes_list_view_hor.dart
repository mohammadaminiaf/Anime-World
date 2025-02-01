import 'package:flutter/material.dart';

import '/models/anime.dart';
import '/widgets/anime_tile.dart';

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
