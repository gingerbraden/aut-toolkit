import 'package:dio/dio.dart';

/// The base API configuration for the ARASAAC API
class ARASAACAPI {
  late final Dio dio;

  ARASAACAPI() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.arasaac.org/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: false,
    ));
  }
}
