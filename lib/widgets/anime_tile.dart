import 'package:anime_world/screens/anime_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/common/styles/text_styles.dart';
import '/models/anime_node.dart';

class AnimeTile extends StatelessWidget {
  const AnimeTile({
    super.key,
    required this.anime,
  });

  final AnimeNode anime;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(AnimeDetailsScreen.routeName, extra: anime.id);
      },
      child: SizedBox(
        width: 150,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Anime Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: anime.mainPicture.medium,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),

            const SizedBox(height: 10),

            // Anime Name
            Text(
              anime.title,
              style: TextStyles.mediumText,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
