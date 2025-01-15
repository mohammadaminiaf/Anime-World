import 'package:flutter/foundation.dart';

import '/models/movies/movie.dart';

enum ViewedAnimesStatus {
  initial,
  loading,
  loaded,
  error,
  loadingMore,
  deleting,
  deleted,
  deleteFailed,
}

@immutable
class ViewedAnimesState {
  final ViewedAnimesStatus status;
  final List<Movie> animes;
  final String? errorMessage;

  const ViewedAnimesState({
    this.status = ViewedAnimesStatus.initial,
    this.animes = const [],
    this.errorMessage,
  });

  ViewedAnimesState copyWith({
    ViewedAnimesStatus? status,
    List<Movie>? animes,
    String? errorMessage,
  }) {
    return ViewedAnimesState(
      status: status ?? this.status,
      animes: animes ?? this.animes,
      errorMessage: errorMessage,
    );
  }
}
