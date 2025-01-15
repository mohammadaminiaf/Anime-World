import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_config.dart';
import '/locator.dart';
import '/models/auth/user.dart';
import '/models/params/update_profile_params.dart';
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
      state = const AsyncLoading();

      final response = await authRepo.logout();
      if (response == true) {
        await AppConfig().resetLoginInfo();
      }

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  //! Change password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      state = const AsyncLoading();

      await authRepo.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      final user = state.value;
      state = AsyncData(user);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
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

  //! Update profile method
  Future<void> updateUser({required UpdateProfileParams user}) async {
    try {
      state = const AsyncLoading();

      final updatedUser = await authRepo.updateUser(user: user);

      state = AsyncData(updatedUser);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}

final authProvider = AsyncNotifierProvider.autoDispose<AuthNotifier, User?>(
  () => AuthNotifier(authRepo: getIt.get<AuthRepository>()),
);
