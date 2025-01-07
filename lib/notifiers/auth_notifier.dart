import 'dart:async';

import 'package:anime_world/constants/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/locator.dart';
import '/models/auth/user.dart';
import '/repositories/auth_repository.dart';

class AuthNotifier extends AutoDisposeAsyncNotifier<User?> {
  final AuthRepository authRepo;

  AuthNotifier({required this.authRepo});

  @override
  FutureOr<User?> build() async {
    final user = await getCurrentUserLocal();
    return user;
  }

  //! Login method
  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      state = const AsyncLoading();

      final user = await authRepo.login(username: username, password: password);

      state = AsyncData(user);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  //! Register user method
  Future<void> register({
    required String name,
    required String username,
    required String password,
    String? email,
    String? phone,
  }) async {
    try {
      state = const AsyncLoading();

      final user = await authRepo.register(
        username: username,
        password: password,
        name: name,
        email: email,
        phone: phone,
      );

      state = AsyncData(user);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  //! Logout method
  Future<void> logout() async {
    try {
      final response = await authRepo.logout();
      if (response == true) {
        await AppConfig().resetLoginInfo();
      }
    } catch (e) {
      rethrow;
    }
  }

  //! GET CURRENT USER LOCALLY
  Future<User?> getCurrentUserLocal() async {
    try {
      final user = await authRepo.getCurrentUserLocal();

      state = AsyncData(user);
      return user;
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
    return null;
  }
}

final authProvider = AsyncNotifierProvider.autoDispose<AuthNotifier, User?>(
  () => AuthNotifier(authRepo: getIt.get<AuthRepository>()),
);
