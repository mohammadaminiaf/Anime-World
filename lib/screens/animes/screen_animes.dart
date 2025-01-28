import 'package:flutter/material.dart';

import '/common/extensions/extensions.dart';
import '/common/styles/paddings.dart';
import '/common/utils/utils.dart';
import '../screen_home.dart';
import '/views/featured_animes.dart';
import '/widgets/seasonal_anime_view.dart';
import '/widgets/top_animes_list.dart';

class ScreenAnimes extends StatefulWidget {
  const ScreenAnimes({super.key});

  @override
  State<ScreenAnimes> createState() => _ScreenAnimesState();
}

class _ScreenAnimesState extends State<ScreenAnimes> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentSeason = getCurrentSeason().capitalize();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime World'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                ScreenHome.routeName,
                arguments: 1,
              );
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Animes Slider
              const SizedBox(
                height: 300,
                child: TopAnimesList(),
              ),

              Padding(
                padding: Paddings.noBottomPadding,
                child: Column(
                  children: [
                    // Top Ranked animes
                    const SizedBox(
                      height: 350,
                      child: FeaturedAnimes(
                        rankingType: 'all',
                        label: 'Top Ranked',
                      ),
                    ),

                    // Top Popular Animes
                    const SizedBox(
                      height: 350,
                      child: FeaturedAnimes(
                        rankingType: 'bypopularity',
                        label: 'Top Popular',
                      ),
                    ),

                    // Top Movie Animes
                    const SizedBox(
                      height: 350,
                      child: FeaturedAnimes(
                        rankingType: 'movie',
                        label: 'Top Movie Animes',
                      ),
                    ),

                    // Top Upcoming Animes
                    const SizedBox(
                      height: 350,
                      child: FeaturedAnimes(
                        rankingType: 'upcoming',
                        label: 'Top Upcoming Animes',
                      ),
                    ),

                    // Top Movie Animes
                    SizedBox(
                      height: 350,
                      child: SeasonalAnimeView(
                        label: 'Top Animes this $currentSeason',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
