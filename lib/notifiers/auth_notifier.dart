import 'dart:convert';
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

      await storage.write(key: 'token', value: result.data?.token);
      saveSubmittedEmail(email);

      state = state.copyWith(isLoading: false, isAuthenticated: true);
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false);
    }
  }

  Future checkAuth() async {
    state = state.copyWith(isLoading: true);

    try {
      var token = await storage.read(key: 'token');

      if (token == null) {
        await deleteCredential();
        state = state.copyWith(isLoading: false, isAuthenticated: false);
      } else {
        await AuthService.checkAuth(token);
        state = state.copyWith(isLoading: false, isAuthenticated: true);
      }
    } on ApiException catch (_) {
      await deleteCredential();
      state = state.copyWith(isLoading: false, isAuthenticated: false);
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
      await storage.write(key: 'token', value: result.data?.token);

      state = state.copyWith(isLoading: false, isAuthenticated: true);
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

  Future<void> logout() async {
    await deleteCredential();
    state = state.copyWith(isAuthenticated: false);
  }

  Future<void> deleteCredential() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'user');
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());