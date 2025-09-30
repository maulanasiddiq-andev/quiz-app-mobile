import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/models/quiz_history/answer_history_model.dart';
import 'package:quiz_app/models/quiz_history/question_history_model.dart';
import 'package:quiz_app/notifiers/quiz_history/quiz_history_detail_notifier.dart';

class QuizHistoryReviewPage extends ConsumerStatefulWidget {
  const QuizHistoryReviewPage({super.key});

  @override
  ConsumerState<QuizHistoryReviewPage> createState() => _QuizHistoryReviewPageState();
}

class _QuizHistoryReviewPageState extends ConsumerState<QuizHistoryReviewPage> {
  Color changeBackgroundColor(QuestionHistoryModel? questionHistory, AnswerHistoryModel answer) {
    if (questionHistory?.selectedAnswerOrder == answer.answerOrder && answer.isTrueAnswer) {
      return Colors.green;
    } else if(answer.isTrueAnswer) {
      return Colors.green;
    } else if (questionHistory?.selectedAnswerOrder == answer.answerOrder && answer.isTrueAnswer == false) {
      return Colors.red;
    }

    return Colors.transparent;
  }
  
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizHistoryDetailProvider);

    return Scaffold(
      appBar: customAppbarComponent("Review Quiz"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        RadioGroup(
                          groupValue: state.currentQuestion!.selectedAnswerOrder,
                          onChanged: (_) {},
                          child: Column(
                            children: [
                              ...state.currentQuestion!.answers.map((answer) {
                                return Container(
                                  color: changeBackgroundColor(state.currentQuestion, answer),
                                  child: RadioListTile<int>(
                                    value: answer.answerOrder,
                                    title: answer.text != null ? Text(answer.text!) : null,
                                    secondary: answer.imageUrl != null
                                      ? Image.network(
                                          answer.imageUrl!,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
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
                  behavior: HitTestBehavior.opaque,
                  onTap: () => ref.read(quizHistoryDetailProvider.notifier).toPreviousQuestion(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white),
                        Text(
                          "Sebelumnya", 
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (state.questionIndex < state.questions.length - 1) {
                      ref.read(quizHistoryDetailProvider.notifier).toNextQuestion();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Text(
                          state.questionIndex < state.questions.length - 1
                              ? "Selanjutnya"
                              : "Selesai",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white
                          ),
                        ),
                        Icon(
                          state.questionIndex < state.questions.length - 1
                              ? Icons.arrow_forward
                              : Icons.check,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}