import '/models/auth/user.dart';

abstract class AuthRepository {
  //! Method to register user
  Future<User> register({
    required String name,
    required String username,
    String? email,
    String? phone,
    required String password,
  });

  //! Method to login user
  Future<User> login({
    required String username,
    required String password,
  });

  //! Method to log the user out
  Future<bool> logout();

  //! Method to get current user locally
  Future<User?> getCurrentUserLocal();
}
