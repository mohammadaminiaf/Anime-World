import 'dart:async';

import 'package:anime_world/notifiers/search_animes/search_animes_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/common/styles/paddings.dart';
import '/models/anime.dart';
import '../../notifiers/search_animes/search_animes_state.dart';
import '/widgets/anime_list_tile.dart';

class ScreenSearchAnimes extends ConsumerStatefulWidget {
  const ScreenSearchAnimes({super.key});

  static const routeName = '/screen-search-animes';

  @override
  ConsumerState<ScreenSearchAnimes> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends ConsumerState<ScreenSearchAnimes> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    // Add listener for debounced input handling
    _searchController.addListener(() {
      final query = _searchController.text.trim();

      if (_debounce?.isActive ?? false) _debounce?.cancel();

      // Trigger search only if input length >= 3
      if (query.length >= 3) {
        _debounce = Timer(const Duration(milliseconds: 500), () {
          ref.read(searchProvider.notifier).searchAnimes(query);
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Anime'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for animes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onSubmitted: (query) {
                // Make API call only if query length >= 3
                if (query.trim().length >= 3) {
                  ref.read(searchProvider.notifier).searchAnimes(query.trim());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter at least 3 characters to search.'),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            // Results
            Expanded(
              child: searchState.status == SearchStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : searchState.error != null
                      ? Center(child: Text('Error: ${searchState.error}'))
                      : searchState.results.isEmpty
                          ? const Center(child: Text('No results found'))
                          : SearchResultsView(animes: searchState.results),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({
    super.key,
    required this.animes,
  });

  final Iterable<Anime> animes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.defaultPadding,
      child: ListView.builder(
        itemCount: animes.length,
        itemBuilder: (context, index) {
          final anime = animes.elementAt(index);

          return AnimeListTile(
            anime: anime,
          );
        },
      ),
    );
  }
}
