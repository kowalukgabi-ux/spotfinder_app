import 'package:dio/dio.dart';

/// Współdzielony klient Dio używany do komunikacji z zewn. API.
class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 35),
      ),
    );
    dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false),
    );
    return dio;
  }
}
