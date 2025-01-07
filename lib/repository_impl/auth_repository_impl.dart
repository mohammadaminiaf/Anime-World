import '/common/models/api_response.dart';
import '/common/services/dio_client.dart';
import '/constants/app_config.dart';
import '/database_helper/secure_storage_helper.dart';
import '/models/auth/user.dart';
import '/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _dio = DioClient();

  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'auth/login',
        {'username': username, 'password': password},
      );

      // Extracting the JSON data from `response.data`
      final ApiResponse apiResponse = ApiResponse.fromJson(response.data);

      if (apiResponse.statusCode == 200) {
        // The `data` field of the API response
        final data = apiResponse.data;

        // Assuming the `data` contains a user object
        final user = User.fromJson(data);
        final token = apiResponse.accessToken;

        await AppConfig().saveLoginInfo(user, token);

        return user;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to Login');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> register({
    required String name,
    required String username,
    String? email,
    String? phone,
    required String password,
  }) async {
    try {
      final form = {
        'name': name,
        'username': username,
        'email': email,
        'phone': phone,
        'password': password
      };

      final response = await _dio.post('auth/register', form);

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final user = User.fromJson(data);

        return user;
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      rethrow;
    }
  }

  //! Save current user local
  @override
  Future<User?> getCurrentUserLocal() async {
    try {
      final userData = await SecureStorageHelper.getMap('user');
      final token = await SecureStorageHelper.getString('token');

      if (userData != null && token != null) {
        final user = User.fromJson(userData);

        AppConfig().saveLoginInfo(user, token);
        return user;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      final response = await _dio.post('auth/logout', {});
      final ApiResponse apiResponse = ApiResponse.fromJson(response.data);

      if (apiResponse.statusCode == 200) {
        AppConfig().resetLoginInfo();
      }

      return true;
    } catch (e) {
      rethrow;
    }
  }
}
