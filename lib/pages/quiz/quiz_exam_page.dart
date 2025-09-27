import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/notifiers/quiz/quiz_exam_notifier.dart';

class QuizExamPage extends ConsumerStatefulWidget {
  final QuizModel quiz;
  const QuizExamPage({super.key, required this.quiz});

  @override
  ConsumerState<QuizExamPage> createState() => _QuizExamPageState();
}

class _QuizExamPageState extends ConsumerState<QuizExamPage> {
  late int seconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    seconds = widget.quiz.time * 60;
    startTimer();

    Future(() {
      ref.read(quizExamProvider.notifier).assignQuestions(widget.quiz.questions);
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        timer?.cancel();
      }
    });
  }

  String timeFormatted() {
    var minute = (seconds ~/ 60).toString().padLeft(2, '0');
    var second = (seconds % 60).toString().padLeft(2, '0');

    return '$minute:$second';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizExamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(timeFormatted()),
            ),
          ),
          Expanded(
            child: state.currentQuestion != null
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pertanyaan ${(state.questionIndex + 1).toString()}/${state.questions.length.toString()}"),
                      Text(state.currentQuestion!.text),
                      ...state.currentQuestion!.answers.map((answer) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                answer.text != null
                                ? Text(answer.text!)
                                : SizedBox()
                              ],
                            ),
                            SizedBox(height: 5)
                          ],
                        );
                      })
                    ],
                  ),
                ),
              )
            : SizedBox(),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => ref.read(quizExamProvider.notifier).toPreviousQuestion(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Icon(Icons.arrow_back),
                        Text(
                          "Sebelumnya",
                          style: TextStyle(
                            fontSize: 16
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => ref.read(quizExamProvider.notifier).toNextQuestion(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Text(
                          "Selanjutnya",
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                )
              ),
            ],
          )
        ],
      ),
    );
  }
}