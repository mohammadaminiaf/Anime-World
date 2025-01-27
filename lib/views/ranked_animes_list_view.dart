import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/common/styles/paddings.dart';
import '/core/widgets/loader.dart';
import '/models/anime.dart';
import '/notifiers/animes_notifier.dart';
import '/widgets/anime_list_tile.dart';

class RankedAnimesListView extends ConsumerStatefulWidget {
  const RankedAnimesListView({
    super.key,
    required this.animes,
    required this.rankingType,
    required this.isLoadingMore,
  });

  final Iterable<Anime> animes;
  final String rankingType;
  final bool isLoadingMore;

  @override
  ConsumerState<RankedAnimesListView> createState() =>
      _RankedAnimesListViewState();
}

class _RankedAnimesListViewState extends ConsumerState<RankedAnimesListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref
          .read(animesProvider.notifier)
          .fetchMoreAnimes(rankingType: widget.rankingType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.defaultPadding,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: widget.animes.length,
              itemBuilder: (context, index) {
                final anime = widget.animes.elementAt(index);
                return AnimeListTile(
                  anime: anime,
                );
              },
            ),
          ),
          if (widget.isLoadingMore) const Loader(),
        ],
      ),
    );
  }
}
