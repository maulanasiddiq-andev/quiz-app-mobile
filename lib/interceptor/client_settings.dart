import 'package:dio/dio.dart';
import 'package:quiz_app/constants/environment_contant.dart';
import 'package:quiz_app/interceptor/jwt_interceptor.dart';

class ClientSettings {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EnvironmentConstant.url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    )
  );

  ClientSettings() {
    _dio.interceptors.add(JwtInterceptor());
  }

  Dio get dio => _dio;
}