import 'package:quiz_app/constants/sort_dir_constant.dart';
import 'package:quiz_app/models/identity/simple_user_model.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';

class QuizDetailUserState {
  final bool isLoadingUser;
  final bool isLoading;
  final bool isLoadingMore;
  final int pageIndex;
  final int pageSize;
  final String sortDir;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final SimpleUserModel? user;
  final List<QuizModel> quizzes;

  QuizDetailUserState({
    this.isLoadingUser = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.pageIndex = 0,
    this.pageSize = 10,
    this.sortDir = SortDirConstant.desc,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.user,
    this.quizzes = const []
  });

  QuizDetailUserState copyWith({
    bool? isLoadingUser,
    bool? isLoading,
    bool? isLoadingMore,
    int? pageIndex,
    int? pageSize,
    bool? hasNextPage,
    bool? hasPreviousPage,
    SimpleUserModel? user,
    List<QuizModel>? quizzes,
  }) {
    return QuizDetailUserState(
      isLoadingUser: isLoadingUser ?? this.isLoadingUser,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      user: user ?? this.user,
      quizzes: quizzes ?? this.quizzes,
    );
  }
}