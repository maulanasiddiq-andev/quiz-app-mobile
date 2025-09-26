class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  
  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false
  });

  AuthState copyWith({
    bool isLoading = false,
    bool isAuthenticated = false
  }) {
    return AuthState(
      isLoading: isLoading,
      isAuthenticated: isAuthenticated
    );
  }
}