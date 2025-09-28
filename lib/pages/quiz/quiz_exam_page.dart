import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/exam_result_component.dart';
import 'package:quiz_app/components/take_exam_component.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/notifiers/quiz/quiz_exam_notifier.dart';

class QuizExamPage extends ConsumerStatefulWidget {
  final QuizModel quiz;
  const QuizExamPage({super.key, required this.quiz});

  @override
  ConsumerState<QuizExamPage> createState() => _QuizExamPageState();
}

class _QuizExamPageState extends ConsumerState<QuizExamPage> {
  @override
  void initState() {
    super.initState();

    Future(() {
      ref.read(quizExamProvider.notifier).assignQuestions(widget.quiz);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizExamProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.title)),
      body: state.isDone && state.quizExam != null
        ? ExamResultComponent(quizExam: state.quizExam!)
        : TakeExamComponent(quiz: widget.quiz),
    );
  }
}
