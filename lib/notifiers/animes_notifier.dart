import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/common/models/pagination.dart';
import '/locator.dart';
import '/models/anime.dart';
import '/models/enums/data_status.dart';
import '/repositories/animes_repository.dart';

class AnimesState extends Equatable {
  final String? error;
  final Iterable<Anime>? animes;
  final DataStatus? status;

  const AnimesState({
    this.error,
    this.animes,
    this.status,
  });

  AnimesState copyWith({
    String? error,
    Iterable<Anime>? animes,
    DataStatus? status,
  }) {
    return AnimesState(
      error: error ?? this.error,
      animes: animes ?? this.animes,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [error, animes, status];
}

class AnimesNotifier extends StateNotifier<AnimesState> {
  final AnimesRepository animesRepo;

  AnimesNotifier({
    required this.animesRepo,
  }) : super(const AnimesState());

  final Pagination pagination = Pagination();

  //! Fetch all animes list
  Future<void> fetchAllAnimes({
    required String rankingType,
  }) async {
    try {
      state = state.copyWith(status: DataStatus.loading);

      final allAnimes = await animesRepo.fetchAnimesByRanking(
        rankingType: rankingType,
        nextPageUrl: null,
      );

      if (allAnimes.data.isNotEmpty) {
        pagination.nextPageUrl = allAnimes.nextPageUrl;

        state = state.copyWith(
          animes: allAnimes.data,
          status: DataStatus.loaded,
        );
      } else {
        state = state.copyWith(error: 'No data found');
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  //! Fetch more animes
  Future<void> fetchMoreAnimes({
    required String rankingType,
  }) async {
    // Avoid triggering multiple simultaneous calls
    if (state.status == DataStatus.loadingMore ||
        pagination.nextPageUrl == null) {
      return;
    }

    //! Set loading more
    state = state.copyWith(status: DataStatus.loadingMore);

    try {
      final moreAnimes = await animesRepo.fetchAnimesByRanking(
        rankingType: rankingType,
        nextPageUrl: pagination.nextPageUrl,
      );

      pagination.nextPageUrl = moreAnimes.nextPageUrl;

      if (moreAnimes.data.isNotEmpty) {
        final allAnimes = state.animes ?? [];
        final updatedAnimes = [...allAnimes, ...moreAnimes.data];
        state = state.copyWith(
          animes: updatedAnimes,
          status: DataStatus.loaded,
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {}
  }
}

final animesProvider =
    StateNotifierProvider.autoDispose<AnimesNotifier, AnimesState>(
  (ref) => AnimesNotifier(
    animesRepo: getIt.get<AnimesRepository>(),
  ),
);
