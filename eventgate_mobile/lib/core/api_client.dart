import 'package:dio/dio.dart';
import 'package:eventgate/core/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiClient() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(
        milliseconds: AppConstants.connectionTimeout,
      ),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      responseType: ResponseType.json,
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await _storage.read(key: AppConstants.authTokenKey);

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            print("Token added: $token");
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          print("API Error: ${e.response?.statusCode} - ${e.message}");

          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
