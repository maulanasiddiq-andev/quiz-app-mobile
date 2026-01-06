import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/input_component.dart';
import 'package:quiz_app/components/pick_image_component.dart';
import 'package:quiz_app/models/quiz_create/question_create_model.dart';
import 'package:quiz_app/notifiers/quiz/quiz_create_notifier.dart';
import 'package:quiz_app/states/quiz/quiz_create_state.dart';

class QuestionCreateComponent extends ConsumerStatefulWidget {
  final QuestionCreateModel question;
  final int questionIndex;
  final int questionsCount;
  const QuestionCreateComponent({
    super.key, 
    required this.question,
    required this.questionIndex,
    required this.questionsCount  
  });

  @override
  ConsumerState<QuestionCreateComponent> createState() => _QuestionCreateComponentState();
}

class _QuestionCreateComponentState extends ConsumerState<QuestionCreateComponent> {
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> answerControllers = [];
  final List<FocusNode> answerFocuses = [];

  @override
  void initState() {
    super.initState();

    initControllers();
  }

  @override
  void didUpdateWidget(covariant QuestionCreateComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    // add answer
    if (widget.question.answers.length > oldWidget.question.answers.length) {
      // empty the answer controllers and focus nodes
      answerControllers.clear();
      answerFocuses.clear();
      for (var answer in widget.question.answers) {
        // assign value to the controller
        final controller = TextEditingController();
        controller.text = answer.text;

        answerControllers.add(controller);
        answerFocuses.add(FocusNode());
      }

      // immediately focus the newly added answer field
      answerFocuses[answerFocuses.length - 1].requestFocus();
    }

    // delete the answer
    if (widget.question.answers.length < oldWidget.question.answers.length) {
      for (var i = 0; i < oldWidget.question.answers.length; i++) {
        // if the deleted index is not the last
        if (i != oldWidget.question.answers.length - 1 && oldWidget.question.answers[i] != widget.question.answers[i]) {
          answerControllers.removeAt(i);
          answerFocuses.removeAt(i);
          break;
        }

        // if the deleted answer is the last
        if (i == oldWidget.question.answers.length - 1) {
          answerControllers.removeAt(i);
          answerFocuses.removeAt(i);
        }
      }
    }

    // case: the current question is removed and the next question become of this index
    if (widget.question != oldWidget.question && widget.questionsCount != oldWidget.questionsCount) {
      initControllers();
    }
  }

  void _syncControllers(QuizCreateState? previous, QuizCreateState next) {
    final updates = {
      questionController: next.questions[widget.questionIndex].text
    };

    for (final entry in updates.entries) {
      final controller = entry.key;
      final newText = entry.value;
      if (controller.text != newText) {
        controller.text = newText;
      }
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    for (var controller in answerControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void initControllers() {
    // questionController.text = widget.question.text;
    answerControllers.clear();
    answerFocuses.clear();
    for (var answer in widget.question.answers) {
      final controller = TextEditingController(text: answer.text);
      answerControllers.add(controller);
      answerFocuses.add(FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final notifier = ref.read(quizCreateProvider.notifier);

    ref.listen(quizCreateProvider, (previous, next) {
      if (previous != next) _syncControllers(previous, next);
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 60),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pertanyaan ${widget.questionIndex + 1}/${widget.questionsCount}"),
            InputComponent(
              title: "Pertanyaan", 
              controller: questionController,
              onChanged: (value) => notifier.updateQuestion(value),
              action: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Pertanyaan harus diisi";
                }

                if (widget.question.answers.length == 1) {
                  return "Jawaban harus lebih dari satu";
                }

                if (widget.question.trueAnswerIndex == null) {
                  return "Tentukan jawaban benar terlebih dahulu";
                }

                return null;
              },
            ),
            PickImageComponent(
              pickImage: () => notifier.pickQuestionImage(colors.primary, colors.onPrimary),
              image: widget.question.image,
            ),
            RadioGroup(
              groupValue: widget.question.trueAnswerIndex,
              onChanged: (int? value) {
                notifier.determineTrueAnswer(value);
              },
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Jawaban",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),  
                  ),
                  for (var i = 0; i < answerControllers.length; i++)
                    Row(
                      children: [
                        Radio(value: i),
                        Expanded(
                          child: Column(
                            children: [
                              InputComponent(
                                focusNode: answerFocuses[i],
                                title: "Jawaban ${i + 1}", 
                                controller: answerControllers[i],
                                onChanged: (value) => notifier.updateAnswer(i, value),
                                action: i == answerControllers.length - 1
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Jawaban harus diisi";
                                  }

                                  return null;
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(child: SizedBox()),
                                  widget.question.answers.length > 1
                                    ? IconButton(
                                        onPressed: () {
                                          notifier.deleteAnswer(i);
                                        }, 
                                        icon: Icon(Icons.delete, size: 20, color: colors.error)
                                      )
                                    : SizedBox(),
                                ],
                              ),
                            ],
                          )
                        )
                      ],
                    )
                ],
              ),
            ),
            widget.question.answers.length > 3
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: TextButton(
                    onPressed: () {
                      notifier.addAnswer();
                    }, 
                    child: Text("Tambah Jawaban")
                  ),
                )
          ],
        ),
      ),
    );
  }
}