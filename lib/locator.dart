import 'package:get_it/get_it.dart';

import '/common/services/dio_client.dart';
import '/common/services/mal_client.dart';
import '/repositories/animes_repository.dart';
import '/repositories/auth_repository.dart';
import '/repository_impl/animes_repository_impl.dart';
import '/repository_impl/auth_repository_impl.dart';

final getIt = GetIt.instance;

void setup() {
  final dio = DioClient();
  final mal = MalClient();

  //! Register all my repositories
  getIt.registerSingleton<AnimesRepository>(AnimesRepositoryImpl(
    dioService: dio,
    malService: mal,
  ));
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl());
}
