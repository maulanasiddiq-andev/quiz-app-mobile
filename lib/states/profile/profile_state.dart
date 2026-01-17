class ProfileState {
  int quizCount;
  int historyCount;
  bool isLoadingQuizCount;
  bool isLoadingHistoryCount;

  ProfileState({
    this.quizCount = 0,
    this.historyCount = 0,
    this.isLoadingQuizCount = false,
    this.isLoadingHistoryCount = false,
  });

  ProfileState copyWith({
    int? quizCount,
    int? historyCount,
    bool? isLoadingQuizCount,
    bool? isLoadingHistoryCount,
  }) {
    return ProfileState(
      quizCount: quizCount ?? this.quizCount,
      historyCount: historyCount ?? this.historyCount,
      isLoadingQuizCount: isLoadingQuizCount ?? this.isLoadingQuizCount,
      isLoadingHistoryCount: isLoadingHistoryCount ?? this.isLoadingHistoryCount,
    );
  }
}