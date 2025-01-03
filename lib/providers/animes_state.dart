import 'package:anime_world/models/anime_node.dart';

enum AnimesStatus {
  initial,
  loading,
  loaded,
  error,
}

class AnimesState {
  final String? error;
  final AnimesStatus? status;
  final List<AnimeNode>? animes;

  AnimesState({
    required this.error,
    required this.status,
    required this.animes,
  });

  AnimesState.init({
    this.error,
    this.status,
    this.animes,
  });

  AnimesState copyWith({
    String? error,
    AnimesStatus? status,
    List<AnimeNode>? animes,
  }) {
    return AnimesState(
      error: error ?? this.error,
      status: status ?? this.status,
      animes: animes ?? this.animes,
    );
  }
}
