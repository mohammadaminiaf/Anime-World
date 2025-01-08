import '/database_helper/secure_storage_helper.dart';
import '/models/auth/user.dart';

class AppConfig {
  // Create a singleton
  AppConfig._();
  static final _instance = AppConfig._();
  factory AppConfig() => _instance;

  User? currentUser;
  String? accessToken;

  //! Update global user info
  Future<void> updateUserInfo(
      {required User? user, required String? token}) async {
    if (user != null) currentUser = user;
    if (token != null) accessToken = token;
  }

  //! Save user credentials to local storage
  Future<void> saveLoginInfo([User? user, String? token]) async {
    if (user != null) {
      currentUser = user;
      await SecureStorageHelper.putMap('user', user.toJson());
    }
    if (token != null) {
      accessToken = token;
      await SecureStorageHelper.putString('token', token);
    }
  }

  //! Reset user credentials from local storage
  Future<void> resetLoginInfo() async {
    currentUser = null;
    accessToken = null;
    await SecureStorageHelper.putString('user', null);
    await SecureStorageHelper.putString('token', null);
  }
}
