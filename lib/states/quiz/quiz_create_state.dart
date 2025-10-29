import 'dart:io';
import 'package:quiz_app/models/quiz_create/question_create_model.dart';
import 'package:quiz_app/models/select_data_model.dart';

class QuizCreateState {
  final bool isLoadingCategories;
  final bool isLoadingCreate;
  final String title;
  final String description;
  final int time;
  final File? image;
  final SelectDataModel? category;
  final int questionIndex;
  final List<QuestionCreateModel> questions;

  QuizCreateState({
    this.isLoadingCategories = false,
    this.isLoadingCreate = false,
    this.title = "",
    this.description = "",
    this.time = 0,
    this.category,
    this.questionIndex = 0,
    this.questions = const [],
    this.image
  });

  QuizCreateState copyWith({
    bool? isLoadingCategories,
    bool? isLoadingCreate,
    String? title,
    String? description,
    int? time,
    int? questionIndex,
    List<QuestionCreateModel>? questions,
    File? image,
    SelectDataModel? category
  }) {
    return QuizCreateState(
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      isLoadingCreate: isLoadingCreate ?? this.isLoadingCreate,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      questionIndex: questionIndex ?? this.questionIndex,
      questions: questions ?? this.questions,
      image: image ?? this.image,
      category: category ?? this.category
    );
  }
}