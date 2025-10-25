import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/models/auth/token_model.dart';

class JwtInterceptor extends Interceptor {
  var storage = FlutterSecureStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final storedToken = await storage.read(key: 'token');

    if (storedToken != null) {
      final jsonToken = jsonDecode(storedToken);      
      final token = TokenModel.fromJson(jsonToken);

      options.headers['Authorization'] = 'Bearer ${token.token}';
    }

    super.onRequest(options, handler);
  }
}