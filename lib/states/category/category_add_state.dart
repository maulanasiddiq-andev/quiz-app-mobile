class CategoryAddState {
  final bool isLoading;

  CategoryAddState({
    this.isLoading = false
  });

  CategoryAddState copyWith({
    bool? isLoading
  }) {
    return CategoryAddState(
      isLoading: isLoading ?? this.isLoading
    );
  }
}