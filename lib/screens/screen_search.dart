import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/screens/animes/screen_search_animes.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({super.key});

  static const routeName = '/search';

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Search for animes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                context.push(ScreenSearchAnimes.routeName);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  height: 70,
                  color: Colors.grey[300],
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(50, 10, 20, 10),
                      child: Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class AnimeSearchDelegate extends SearchDelegate<List<AnimeNode>> {
//   List<Anime> _searchResults = [];
//   bool _isLoading = false;
//   String? _errorMessage;

//   Future<void> searchAnime(String query) async {
//     if (query.isEmpty) {
//       _searchResults = [];
//       _errorMessage = null;
//       return;
//     }

//     try {
//       _isLoading = true;
//       _errorMessage = null;
//       _searchResults = List.from(await getAnimesbySearchApi(query: query));
//     } catch (e) {
//       _errorMessage = e.toString();
//     } finally {
//       _isLoading = false;
//     }
//   }

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//           _searchResults = [];
//           _errorMessage = null;
//           showSuggestions(context);
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, []);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return _buildSearchResults();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // Trigger search only if query has changed
//     if (query.isNotEmpty) {
//       searchAnime(query);
//     }
//     return _buildSearchResults();
//   }

//   Widget _buildSearchResults() {
//     if (query.isEmpty) {
//       return const Center(
//         child: Text('Enter a search query to begin'),
//       );
//     }

//     if (_isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     if (_errorMessage != null) {
//       return Center(
//         child: Text('Error: $_errorMessage'),
//       );
//     }

//     if (_searchResults.isEmpty) {
//       return const Center(
//         child: Text('No results found'),
//       );
//     }

//     return SearchResultsView(animes: _searchResults);
//   }
// }
