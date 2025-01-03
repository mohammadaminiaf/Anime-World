import 'package:get_it/get_it.dart';

import '/repositories/animes_repository.dart';
import '/repository_impl/animes_repository_impl.dart';

final getIt = GetIt.instance;

void setup() {
  //! Register all my repositories
  getIt.registerSingleton<AnimesRepository>(AnimesRepositoryImpl());
}
