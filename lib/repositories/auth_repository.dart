import '/models/auth/user.dart';
import '/models/params/update_profile_params.dart';

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

  //! Method to change user's password
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  //! Send OTP method
  Future<bool> sendOtp({required String email});

  //! Verify OTP
  Future<bool> verifyOtp({
    required String otp,
    required String email,
  });

  //! Reset password
  Future<bool> resetPassword({
    required String otp,
    required String email,
    required String newPassword,
  });

  //! Method to get current user locally
  Future<User?> getCurrentUserLocal();

  //! Update user method
  Future<User?> updateUser({required UpdateProfileParams user});

  //! Update user local
  Future<void> updateUserLocal({required User? user});

  //! Delete user account
  Future<bool> deleteUser(String userId);
}
