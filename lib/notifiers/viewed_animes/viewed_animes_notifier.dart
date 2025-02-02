// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '/models/movies/movie.dart';
// import '/notifiers/viewed_animes_state.dart';
// import '/repositories/animes_repository.dart';

// class ViewedMovieNotifier extends StateNotifier<ViewedAnimesState> {
//   final AnimesRepository animesRepo;

//   ViewedMovieNotifier({
//     required this.animesRepo,
//   }) : super(const ViewedAnimesState());

//   // Method to record a viewed movie
//   Future<void> createViewedMovie(Movie movie) async {
//     state = state.copyWith(status: ViewedAnimesStatus.loading);

//     try {
//       final anime = await animesRepo.createViewedMovie(movie: movie);

//       final updatedAnimes = List.of(state.animes)..add(anime);

//       state = state.copyWith(
//         status: ViewedAnimesStatus.loaded,
//         animes: updatedAnimes,
//       );
//     } catch (e) {
//       state = state.copyWith(status: ViewedAnimesStatus.error);
//     }
//   }
// }
