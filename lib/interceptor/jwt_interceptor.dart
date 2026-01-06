import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/models/auth/token_model.dart';
import 'package:quiz_app/services/auth_service.dart';

class JwtInterceptor extends Interceptor {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final Dio dio;

  bool isRefreshing = false;
  final List<void Function(String)> _refreshSubscribers = [];

  JwtInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final storedToken = await storage.read(key: 'token');
    if (storedToken != null) {
      final token = TokenModel.fromJson(jsonDecode(storedToken));
      options.headers['Authorization'] = 'Bearer ${token.token}';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final storedToken = await storage.read(key: 'token');
    if (storedToken == null) {
      return handler.reject(err);
    }

    // If refresh in progress -> queue request
    if (isRefreshing) {
      final completer = Completer<Response>();

      _addRefreshSubscriber((newAccessToken) async {
        try {
          err.requestOptions.headers["Authorization"] = "Bearer $newAccessToken";
          final resp = await dio.fetch(err.requestOptions);
          completer.complete(resp);
        } catch (e) {
          completer.completeError(e);
        }
      });

      return completer.future
          .then((r) => handler.resolve(r))
          .catchError((e) => handler.reject(e));
    }

    // Begin refresh
    isRefreshing = true;

    try {
      final token = TokenModel.fromJson(jsonDecode(storedToken));

      final newTokenResponse = await AuthService.refreshToken(token);
      final newToken = newTokenResponse.data!;
      final newTokenJson = jsonEncode(newToken.toJson());

      // Save new token
      await storage.write(key: 'token', value: newTokenJson);

      // Retry original request
      err.requestOptions.headers['Authorization'] = 'Bearer ${newToken.token}';
      final retryResponse = await dio.fetch(err.requestOptions);

      // Notify queued requests
      _onTokenRefreshed(newToken.token);

      return handler.resolve(retryResponse);  // Stop error chain
    } catch (e) {
      return handler.reject(err);
    } finally {
      isRefreshing = false;
    }
  }

  void _addRefreshSubscriber(void Function(String) callback) {
    _refreshSubscribers.add(callback);
  }

  void _onTokenRefreshed(String token) {
    for (final callback in _refreshSubscribers) {
      callback(token);
    }
    _refreshSubscribers.clear();
  }
}
