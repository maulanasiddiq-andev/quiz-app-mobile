import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/models/auth/token_model.dart';
import 'package:quiz_app/services/auth_service.dart';

class JwtInterceptor extends Interceptor {
  var storage = FlutterSecureStorage();
  
  final Dio dio;
  bool isRefreshing = false;
  final List<Function(String)> _refreshSubscribers = [];

  JwtInterceptor(this.dio);

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

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check for 401 (Unauthorized)
    if (err.response?.statusCode == 401) {
      print("Unauthorized");
      final storedToken = await storage.read(key: 'token');
      if (storedToken == null) {
        print("No token stored");
        handler.next(err);
      }

      print("Token stored");
      // If already refreshing, queue the request
      if (isRefreshing) {
        final completer = Completer<Response>();
        _addRefreshSubscriber((newToken) async {
          try {
            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            final retryResponse = await dio.fetch(err.requestOptions);
            completer.complete(retryResponse);
          } catch (e) {
            completer.completeError(e);
          }
        });
        return completer.future.then((r) => handler.resolve(r)).catchError((e) => handler.reject(e));
      }

      isRefreshing = true;

      try {
        print("Refreshing");
        final jsonToken = jsonDecode(storedToken!);
        final token = TokenModel.fromJson(jsonToken);
        final newToken = await AuthService.refreshToken(token);

        // Save new token
        final jsonNewToken = newToken.data?.toJson();
        final storedNewToken = jsonEncode(jsonNewToken);
        await storage.write(key: "token", value: storedNewToken);

        // Retry the original failed request
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final retryResponse = await dio.fetch(err.requestOptions);

        // Notify queued requests
        _onTokenRefreshed(storedNewToken);

        handler.resolve(retryResponse);
      } catch (e) {
        // Refresh failed → log out or redirect to login
        handler.next(err);
      } finally {
        isRefreshing = false;
      }
    }

    return handler.next(err);
  }

  void _addRefreshSubscriber(Function(String) callback) {
    _refreshSubscribers.add(callback);
  }

  void _onTokenRefreshed(String newToken) {
    for (final callback in _refreshSubscribers) {
      callback(newToken);
    }
    _refreshSubscribers.clear();
  }
}