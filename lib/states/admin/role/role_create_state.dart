class RoleCreateState {
  final bool isLoading;

  RoleCreateState({
    this.isLoading = false
  });

  RoleCreateState copyWith({
    bool? isLoading
  }) {
    return RoleCreateState(
      isLoading: isLoading ?? this.isLoading
    );
  }
}