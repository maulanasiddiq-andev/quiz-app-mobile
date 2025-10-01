import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/notifiers/quiz/quiz_create_notifier.dart';

class QuizQuestionCreatePage extends ConsumerStatefulWidget {
  const QuizQuestionCreatePage({super.key});

  @override
  ConsumerState<QuizQuestionCreatePage> createState() => _QuizQuestionCreatePageState();
}

class _QuizQuestionCreatePageState extends ConsumerState<QuizQuestionCreatePage> {
  late TextEditingController questionController;
  late List<TextEditingController> answerControllers;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController();
    answerControllers = [];
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizCreateProvider);
    final notifier = ref.read(quizCreateProvider.notifier);
    var currentQuestion = state.questions[state.questionIndex];

    if (questionController.text != currentQuestion.text) {
      final oldSelection = questionController.selection;

      questionController.text = currentQuestion.text;

      final newSelection = TextSelection(
        baseOffset: oldSelection.baseOffset.clamp(0, questionController.text.length), 
        extentOffset: oldSelection.extentOffset.clamp(0, questionController.text.length)
      );

      questionController.selection = newSelection;
    }

    return Scaffold(
      appBar: customAppbarComponent("Buat pertanyaan"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  spacing: 15,
                  children: [
                    TextField(
                      controller: questionController,
                      decoration: InputDecoration(
                        hintText: "Pertanyaan"
                      ),
                      onChanged: (value) => notifier.updateQuestion(value),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          for (var i = 0; i < currentQuestion.answers.length; i++)
                            TextField(
                              controller: TextEditingController.fromValue(
                                TextEditingValue(
                                  text: currentQuestion.answers[i].text,
                                  selection: TextSelection.collapsed(offset: currentQuestion.answers[i].text.length)
                                )
                              ),
                              decoration: InputDecoration(
                                hintText: "Jawaban ${i + 1}"
                              ),
                              onChanged: (value) => notifier.updateAnswer(i, value),
                            )
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        notifier.addAnswer();
                      }, 
                      child: Text("Tambah Jawaban")
                    )
                  ],
                ),
              ),
            )
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => notifier.toPreviousQuestion(),
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
                    notifier.toNextQuestion();
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
                              : "Tambah Pertanyaan",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white
                          ),
                        ),
                        Icon(
                          state.questionIndex < state.questions.length - 1
                              ? Icons.arrow_forward
                              : Icons.add,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}