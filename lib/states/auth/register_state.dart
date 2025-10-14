class RegisterState {
  final String? email;
  final bool isLoading;

  RegisterState({
    this.email,
    this.isLoading = false
  });

  RegisterState copyWith({
    String? email,
    bool? isLoading
  }) {
    return RegisterState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading
    );
  }
}