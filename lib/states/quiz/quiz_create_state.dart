import 'package:quiz_app/models/quiz/category_model.dart';
import 'package:quiz_app/models/quiz_create/question_create_model.dart';

class QuizCreateState {
  final bool isLoadingCategories;
  final String categoryId;
  final List<CategoryModel> categories;
  final String title;
  final String description;
  final int time;
  final int questionIndex;
  final List<QuestionCreateModel> questions;

  QuizCreateState({
    this.isLoadingCategories = false,
    this.categories = const [],
    this.categoryId = "",
    this.title = "",
    this.description = "",
    this.time = 0,
    this.questionIndex = 0,
    this.questions = const []
  });

  QuizCreateState copyWith({
    bool? isLoadingCategories,
    List<CategoryModel>? categories,
    String? categoryId,
    String? title,
    String? description,
    int? time,
    int? questionIndex,
    List<QuestionCreateModel>? questions
  }) {
    return QuizCreateState(
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      categories: categories ?? this.categories,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      questionIndex: questionIndex ?? this.questionIndex,
      questions: questions ?? this.questions
    );
  }
}