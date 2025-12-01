import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/auth/token_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/services/google_auth_service.dart';
import 'package:quiz_app/states/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(): super(AuthState()) {
    checkAuth();
  }

  var storage = FlutterSecureStorage();

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final BaseResponse<TokenModel> result = await AuthService.login(email, password);

      final storedToken = jsonEncode(result.data?.toJson());
      await storage.write(key: 'token', value: storedToken);
      saveSubmittedEmail(email);

      state = state.copyWith(
        isLoading: false, 
        isAuthenticated: true,
        token: result.data
      );
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false);
    }
  }

  Future checkAuth() async {
    state = state.copyWith(isCheckAuthLoading: true);

    try {
      var storedToken = await storage.read(key: 'token');

      if (storedToken == null) {
        await deleteCredential();
        state = state.copyWith(isCheckAuthLoading: false, isAuthenticated: false);
      } else {
        final jsonToken = jsonDecode(storedToken);
        final token = TokenModel.fromJson(jsonToken);

        await AuthService.checkAuth(token.token);
        state = state.copyWith(
          isCheckAuthLoading: false, 
          isAuthenticated: true,
          token: token
        );
      }
    } on ApiException catch (_) {
      await deleteCredential();
      state = state.copyWith(isCheckAuthLoading: false, isAuthenticated: false);
    } on DioException catch (_) {
      await deleteCredential();
      state = state.copyWith(isCheckAuthLoading: false, isAuthenticated: false);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final googleAuth = GoogleAuthService();
      await googleAuth.initialize(
        serverClientId: "1065568145771-ok1ilooqacp3ls0phli5bhdnu4pem614.apps.googleusercontent.com",
        clientId: "1065568145771-k3psvrln98sprpvfh1mu10cnt06ibran.apps.googleusercontent.com"  
      );

      final account = await googleAuth.signIn();
      final auth = account.authentication;
      
      state = state.copyWith(isLoading: true);

      final BaseResponse<TokenModel> result = await AuthService.loginWithGoogle(auth.idToken!);

      final storedToken = jsonEncode(result.data?.toJson());
      await storage.write(
        key: 'token', 
        value: storedToken
      );

      state = state.copyWith(
        isLoading: false, 
        isAuthenticated: true,
        token: result.data
      );
    } on GoogleSignInException catch (_) {
      Fluttertoast.showToast(msg: "Proses dibatalkan");
      state = state.copyWith(isLoading: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> saveSubmittedEmail(String email) async {
    if (email == '') return;

    var emailsJson = await storage.read(key: 'emails');
    List<String> emails = [];

    if (emailsJson != null) emails = List<String>.from(jsonDecode(emailsJson));

    if (!emails.contains(email)) emails.add(email);

    await storage.write(key: 'emails', value: jsonEncode(emails));
  }

  Future<List<String>> showSubmittedEmails() async {
    var emailsJson = await storage.read(key: 'emails');
    List<String> emails = [];

    if (emailsJson != null) {
      emails = List<String>.from(jsonDecode(emailsJson));
    }

    return emails;
  }

  Future<bool> logout() async {
    state = state.copyWith(isLoadingLogout: true);
    try {
      // delete the fcm token from the backend
      await AuthService.logout();

      await deleteCredential();
      state = state.copyWith(isLoadingLogout: false); 

      return true;
    } on ApiException catch (_) {
      await deleteCredential();
      state = state.copyWith(isLoadingLogout: false);

      return false;
    } on DioException catch (_) {
      await deleteCredential();
      state = state.copyWith(isLoadingLogout: false);

      return false;
    }
  }

  Future<void> deleteCredential() async {
    await storage.delete(key: 'token');
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());