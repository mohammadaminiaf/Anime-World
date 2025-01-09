import 'package:flutter/material.dart';

import '/models/anime.dart';

enum SearchStatus {
  initial,
  loading,
  loaded,
  failed,
  loadingMore,
}

@immutable
class SearchAnimesState {
  final SearchStatus? status;
  final String? error;
  final List<Anime> results;
  final int currentPage;
  final int lastPage;

  const SearchAnimesState({
    this.error,
    this.results = const [],
    this.currentPage = 1,
    this.lastPage = 0,
    this.status = SearchStatus.initial,
  });

  SearchAnimesState copyWith({
    String? error,
    List<Anime>? results,
    int? currentPage,
    int? lastPage,
    SearchStatus? status,
  }) {
    return SearchAnimesState(
      error: error ?? error,
      results: results ?? this.results,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      status: status ?? this.status,
    );
  }
}
