import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
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

    Future.microtask(() {
      ref.read(quizExamProvider.notifier).assignQuestions(widget.quiz);
    });
  }

  Future<bool> confirmLeaveDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Perhatian"),
          content: Text(
            "Apakah anda yakin ingin meninggalkan kuis ini?",
            style: TextStyle(
              fontSize: 16
            )
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(quizExamProvider.notifier).confirmToLeave();
                // close the dialog
                Navigator.of(context).pop(true);
              }, 
              child: Text(
                "Ya",
                style: TextStyle(
                  color: Colors.red
                ),
              )
            ),
            TextButton(
              onPressed: () {
                // close the dialog
                Navigator.of(context).pop(false);
              }, 
              child: Text(
                "Tidak",
                style: TextStyle(
                  color: Colors.blue
                ),
              )
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizExamProvider);
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // the user can leave this page if the quiz is already done
          // or the user is sure to leave the page after confirming it on modal popup
          if (state.isDone || state.isConfirmedToLeave) {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          } else {
            final bool shouldPop = await confirmLeaveDialog();

            if (shouldPop && context.mounted) {
              Navigator.of(context).pop();
            }
          }
        }
      },
      child: Scaffold(
        appBar: customAppbarComponent(
          widget.quiz.title, 
          automaticallyImplyLeading: false,
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary
        ),
        body: state.isDone && state.quizExam != null
          ? ExamResultComponent(quizExam: state.quizExam!)
          : TakeExamComponent(quiz: widget.quiz),
      ),
    );
  }
}
