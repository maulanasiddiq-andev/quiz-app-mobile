class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  
  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated
    );
  }
}