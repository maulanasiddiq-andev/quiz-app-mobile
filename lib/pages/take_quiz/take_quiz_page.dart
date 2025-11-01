import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/quiz_navigation_button_component.dart';
import 'package:quiz_app/notifiers/quiz/take_quiz_notifier.dart';
import 'package:quiz_app/pages/take_quiz/take_quiz_result_page.dart';
import 'package:quiz_app/utils/format_time.dart';

class TakeQuizPage extends ConsumerStatefulWidget {
  const TakeQuizPage({super.key});

  @override
  ConsumerState<TakeQuizPage> createState() => _TakeQuizPageState();
}

class _TakeQuizPageState extends ConsumerState<TakeQuizPage> {
  int seconds = 0;
  int duration = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final state = ref.read(takeQuizProvider);
      seconds = state.quiz!.time * 60;
      startTimer();
    });
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() {
          seconds--;
          duration++;
        });
      } else {
        timer?.cancel();
        timeOverAlert();
      }
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
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(takeQuizProvider.notifier).confirmToLeave();
                // close the dialog
                Navigator.of(context).pop(true);
              },
              child: Text("Ya", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                // close the dialog
                Navigator.of(context).pop(false);
              },
              child: Text("Tidak", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<bool> confirmSubmittingQuiz(int unansweredQuestionCount) async {
    final result = await showDialog<bool>(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Perhatian"),
          content: Text(
            "Apakah anda yakin ingin menyelesaikan kuis ini?\nAnda masih punya waktu ${formatTime(seconds)}${unansweredQuestionCount > 0 ? ' dan $unansweredQuestionCount soal belum terjawab.' : '.'}",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(takeQuizProvider.notifier).confirmToLeave();
                // close the dialog
                Navigator.of(context).pop(true);
              },
              child: Text("Ya", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                // close the dialog
                Navigator.of(context).pop(false);
              },
              child: Text("Tidak", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      }
    );

    return result ?? false;
  } 

  Future timeOverAlert() async {
    await showDialog<bool>(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Perhatian"),
          content: Text(
            "Waktu mengerjakan kuis sudah habis",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(takeQuizProvider.notifier).confirmToLeave();
                // close the dialog
                Navigator.of(context).pop(true);
              },
              child: Text("Ya", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      }
    );

    final result = await ref.read(takeQuizProvider.notifier).finishQuiz(duration);

    if (!mounted) return;

    if (result == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TakeQuizResultPage(),
        ),
      );
    }    
  } 

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(takeQuizProvider);
    final notifier = ref.read(takeQuizProvider.notifier);
    final colors = Theme.of(context).colorScheme;
    final currentQuestion = state.questions[state.questionIndex];

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
        appBar: CustomAppbarComponent(title: state.quiz?.title ?? "Kuis"),
        drawer: Drawer(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero
          ),
          child: ListView(
            children: [
              ...state.questions.asMap().entries.map((value) {
                final question = value.value;
                final key = value.key;

                return GestureDetector(
                  onTap: () {
                    notifier.goToQuestion(key);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    color: state.questionIndex == key
                      ? colors.onSurface
                      : colors.surface,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            (key + 1).toString(),
                            style: TextStyle(
                              color: state.questionIndex == key
                                ? colors.surface
                                : colors.onSurface,
                              fontSize: 16
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              question.selectedAnswerOrder != null
                                ? question.answers[question.selectedAnswerOrder!].text!
                                : "Belum dijawab",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: state.questionIndex == key
                                  ? colors.surface
                                  : colors.onSurface,
                                fontSize: 16
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
            ],
          ),
        ),
        body: ConnectionCheckComponent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    formatTime(seconds),
                    style: TextStyle(
                      color: seconds > 10
                          ? colors.onSurface
                          : seconds % 2 == 0
                          ? colors.onSurface
                          : colors.error,
                      fontFamily: "Orbitron",
                      fontSize: 16
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pertanyaan ${(state.questionIndex + 1).toString()}/${state.questions.length.toString()}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          currentQuestion.text,
                          style: TextStyle(fontSize: 18),
                        ),
                        currentQuestion.imageUrl != null
                            ? Column(
                                children: [
                                  SizedBox(height: 10),
                                  Image.network(
                                    currentQuestion.imageUrl!,
                                    width: double.infinity,
                                  ),
                                  SizedBox(height: 10),
                                ],
                              )
                            : SizedBox(height: 10),
                        RadioGroup(
                          groupValue: currentQuestion.selectedAnswerOrder,
                          onChanged: (int? value) {
                            currentQuestion.selectedAnswerOrder = value;
                          },
                          child: Column(
                            children: [
                              ...currentQuestion.answers.map((answer) {
                                return RadioListTile(
                                  value: answer.answerOrder,
                                  title: answer.text != null
                                      ? Text(
                                          answer.text!,
                                          style: TextStyle(fontSize: 18),
                                        )
                                      : null,
                                  secondary: answer.imageUrl != null
                                      ? Image.network(
                                          answer.imageUrl!,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: QuizNavigationButtonComponent(
                      onTap: () => notifier.toPreviousQuestion(),
                      icon: Icons.arrow_back,
                      text: "Sebelumnya",
                    ),
                  ),
                  Expanded(
                    child: QuizNavigationButtonComponent(
                      onTap: () async {
                        if (state.questionIndex < state.questions.length - 1) {
                          notifier.toNextQuestion();
                        } else {
                          final unansweredQuestionCount = notifier.countUnansweredQuestions();
                          final confirmResult = await confirmSubmittingQuiz(unansweredQuestionCount);
          
                          if (confirmResult) {
                            final result = await notifier.finishQuiz(duration);
          
                            if (result == true && context.mounted) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TakeQuizResultPage(),
                                ),
                              );
                            }
                          }
                        }
                      },
                      icon: state.questionIndex < state.questions.length - 1
                          ? Icons.arrow_forward
                          : Icons.check,
                      text: state.questionIndex < state.questions.length - 1
                          ? "Selanjutnya"
                          : "Selesai",
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
