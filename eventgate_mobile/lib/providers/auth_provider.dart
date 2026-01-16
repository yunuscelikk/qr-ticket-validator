import 'package:dio/dio.dart';
import 'package:eventgate/core/api_client.dart';
import 'package:eventgate/core/constants.dart';
import 'package:eventgate/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _apiClient.dio.post(
        AppConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        String token = data['token'];
        await _storage.write(key: AppConstants.authTokenKey, value: token);

        _user = UserModel.fromJson(data['user']);

        _setLoading(false);
        return true;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _errorMessage = e.response?.data['error'] ?? 'Login failed';
      } else {
        _errorMessage = 'Connection error. Check your connection.';
      }
    } catch (e) {
      _errorMessage = 'Unexpected error';
    }

    _setLoading(false);
    return false;
  }

  Future<void> tryAutoLogin() async {
    final token = await _storage.read(key: AppConstants.authTokenKey);

    if (token != null) {
      print("Session found");
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: AppConstants.authTokenKey);
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
}
