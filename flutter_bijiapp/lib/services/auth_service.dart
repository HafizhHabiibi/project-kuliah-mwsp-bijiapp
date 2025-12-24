import '../config/app_config.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // ================= REGISTER (AUTO LOGIN) =================
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        AppConfig.register,
        body: {'name': name, 'email': email, 'password': password},
        needsAuth: false,
      );

      final data = _apiService.parseResponse(response);

      if (response.statusCode == 201 && data['status'] == 'success') {
        final token = data['token'];
        await _apiService.saveToken(token);

        final user = UserModel.fromJson(data['user_info']);

        return {
          'success': true,
          'message': data['message'] ?? 'Registration successful',
          'user': user,
          'token': token,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ================= LOGIN =================
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        AppConfig.login,
        body: {'email': email, 'password': password},
        needsAuth: false,
      );

      final data = _apiService.parseResponse(response);

      if (response.statusCode == 200 && data['status'] == 'success') {
        final token = data['token'];
        await _apiService.saveToken(token);

        final user = UserModel.fromJson(data['user_info']);

        return {
          'success': true,
          'message': data['message'] ?? 'Login successful',
          'user': user,
          'token': token,
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ================= GET USER =================
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = await _apiService.get(
        AppConfig.getUser,
        needsAuth: true,
      );

      final data = _apiService.parseResponse(response);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get user info',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ================= LOGOUT =================
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _apiService.post(
        AppConfig.logout,
        body: {},
        needsAuth: true,
      );

      final data = _apiService.parseResponse(response);

      if (response.statusCode == 200) {
        await _apiService.removeToken();
        return {
          'success': true,
          'message': data['message'] ?? 'Logout successful',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Logout failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ================= CHECK AUTH =================
  Future<bool> isLoggedIn() async {
    final token = await _apiService.getToken();
    return token != null && token.isNotEmpty;
  }
}
