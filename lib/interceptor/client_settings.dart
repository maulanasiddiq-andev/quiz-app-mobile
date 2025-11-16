import 'package:dio/dio.dart';
import 'package:quiz_app/constants/environment_contant.dart';
import 'package:quiz_app/interceptor/jwt_interceptor.dart';

class ClientSettings {
  static final ClientSettings _instance = ClientSettings._internal();

  factory ClientSettings() => _instance;

  late final Dio _dio;

  ClientSettings._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvironmentConstant.url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(JwtInterceptor(_dio));
  }

  Dio get dio => _dio;
}