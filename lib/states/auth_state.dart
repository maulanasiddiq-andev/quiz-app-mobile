import 'package:quiz_app/models/auth/token_model.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool isLoadingLogout;
  final TokenModel? token;
  final bool isCheckAuthLoading;
  
  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.token,
    this.isCheckAuthLoading = false,
    this.isLoadingLogout = false
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    TokenModel? token,
    bool? isCheckAuthLoading,
    bool? isLoadingLogout
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      isCheckAuthLoading: isCheckAuthLoading ?? this.isCheckAuthLoading,
      isLoadingLogout: isLoadingLogout ?? this.isLoadingLogout
    );
  }
}