import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '/constants/app_colors.dart';
import '/models/anime.dart';
import '/screens/anime_details_screen.dart';

class TopAnimeImageSlider extends StatefulWidget {
  const TopAnimeImageSlider({
    super.key,
    required this.animes,
  });

  final Iterable<Anime> animes;

  @override
  State<TopAnimeImageSlider> createState() => _TopAnimeImageSliderState();
}

class _TopAnimeImageSliderState extends State<TopAnimeImageSlider> {
  int _currentPageIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider.builder(
            controller: _controller,
            itemCount: widget.animes.length,
            itemBuilder: (context, index, realIndex) {
              final anime = widget.animes.elementAt(index);
              return TopAnimePicture(
                anime: anime,
              );
            },
            options: CarouselOptions(
              enlargeFactor: 0.22,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              aspectRatio: 16 / 9,
              viewportFraction: 0.88,
              autoPlay: true,
              enlargeCenterPage: true,
              initialPage: _currentPageIndex,
            ),
          ),

          const SizedBox(height: 20),

          // Page Indicator
          AnimatedSmoothIndicator(
            activeIndex: _currentPageIndex,
            count: widget.animes.length,
            effect: CustomizableEffect(
              activeDotDecoration: DotDecoration(
                rotationAngle: 180,
                borderRadius: BorderRadius.circular(8.0),
                color: AppColors.blueColor,
                width: 28.0,
                height: 8.0,
              ),
              dotDecoration: DotDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  width: 28.0,
                  height: 8.0,
                  color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class TopAnimePicture extends StatelessWidget {
  const TopAnimePicture({
    super.key,
    required this.anime,
  });

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(AnimeDetailsScreen.routeName, extra: anime.node.id);
      },
      splashColor: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            anime.node.mainPicture.medium,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
