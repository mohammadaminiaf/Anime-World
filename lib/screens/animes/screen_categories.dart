import 'package:flutter/material.dart';

import '/models/anime_category.dart';
import '/views/anime_grid_view.dart';

class ScreenCategories extends StatefulWidget {
  const ScreenCategories({super.key});

  @override
  State<ScreenCategories> createState() => _ScreenCategoriesState();
}

class _ScreenCategoriesState extends State<ScreenCategories> {
  final _animeTabs = animeCategories
      .map((animeCategory) => Tab(text: animeCategory.title))
      .toList();

  final _screens = animeCategories
      .map(
        (animeCategory) => AnimeGridView(
          category: animeCategory,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Anime Categories'),
          bottom: TabBar(
            isScrollable: true,
            tabs: _animeTabs,
            indicatorSize: TabBarIndicatorSize.label,
            tabAlignment: TabAlignment.start,
            indicatorWeight: 3,
            indicatorColor: Colors.red,
            labelColor: Colors.red,
          ),
        ),
        body: TabBarView(
          children: _screens,
        ),
      ),
    );
  }
}
